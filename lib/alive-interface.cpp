// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "alive-interface.h"
#include "config.h"
#include "expr.h"

#include "ir/globals.h"
#include "llvm_util/llvm2alive.h"
#include "smt/smt.h"
#include "util/compiler.h"
#include "util/config.h"
#include "util/errors.h"
#include "util/symexec.h"
#include "tools/transform.h"
#include "llvm_util/compare.h"
#include "llvm/ADT/APSInt.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Argument.h"
#include "llvm/Support/TypeSize.h"

#include <map>
#include <sstream>
#include <unordered_map>

using namespace IR;
using namespace smt;
using namespace tools;
using namespace util;
using namespace std;

using namespace llvm;

// borrowed from alive2
static expr preprocess(Transform &t, const set<expr> &qvars0,
                       const set<expr> &undef_qvars, expr &&e) {
  if (hit_half_memory_limit())
    return expr::mkForAll(qvars0, std::move(e));

  // eliminate all quantified boolean vars; Z3 gets too slow with those
  auto qvars = qvars0;
  for (auto I = qvars.begin(); I != qvars.end(); ) {
    auto &var = *I;
    if (!var.isBool()) {
      ++I;
      continue;
    }
    if (hit_half_memory_limit())
      break;

    e = (e.subst(var, true) && e.subst(var, false)).simplify();
    I = qvars.erase(I);
  }

  return expr::mkForAll(qvars, std::move(e));
}

void calculateAndInitConstants(Transform &t);

namespace minotaur {

bool
AliveEngine::compareFunctions(llvm::Function &Func1, llvm::Function &Func2) {
  smt::smt_initializer smt_init;
  llvm_util::Verifier verifier(TLI, smt_init, *debug);
  verifier.quiet = false;
  verifier.compareFunctions(Func1, Func2);

  return verifier.num_correct;
}

Errors
AliveEngine::find_model(Transform &t,
                        unordered_map<const IR::Value*, smt::expr> &result) {

  t.preprocess();
  t.tgt.syncDataWithSrc(t.src);
  ::calculateAndInitConstants(t);

  TransformPrintOpts print_opts;
  t.print(*debug, print_opts);

  State::resetGlobals();
  IR::State src_state(t.src, true);
  util::sym_exec(src_state);
  IR::State tgt_state(t.tgt, false);
  tgt_state.syncSEdataWithSrc(src_state);
  util::sym_exec(tgt_state);
  auto pre_src_and = src_state.getPre();
  auto &pre_tgt_and = tgt_state.getPre();

  // optimization: rewrite "tgt /\ (src -> foo)" to "tgt /\ foo" if src = tgt
  pre_src_and.del(pre_tgt_and);
  expr pre_src = pre_src_and();
  expr pre_tgt = pre_tgt_and();
  expr axioms_expr = expr(true);

  IR::State::ValTy sv = src_state.returnVal(), tv = tgt_state.returnVal();

  auto uvars = sv.undef_vars;
  set<expr> qvars;

  Errors errs;

  for (auto &i : tgt_state.getFn().getInputs()) {
    if (!dynamic_cast<const Input*>(&i))
      continue;

    auto *val = tgt_state.at(i);
    if (!val)
      continue;

    if (i.getName().rfind("%_reservedc") == 0) {
      continue;
    }

    auto &ty = i.getType();

    if (ty.isIntType() || ty.isFloatType()) {
      qvars.insert(val->val.value);
      continue;
    }

    auto aty = ty.getAsAggregateType();
    if (ty.isVectorType() && (aty->getChild(0).isIntType() || aty->getChild(0).isFloatType())) {
      for (unsigned I = 0; I < aty->numElementsConst(); ++I) {
        qvars.insert(aty->extract(val->val, I, false).value);
      }
      continue;
    }

    errs.add("Unknown type is found in argument list.", false);
    return errs;
  }
  auto dom_a = sv.domain;
  auto dom_b = tv.domain;

  auto mk_fml = [&](expr &&refines) -> expr {
    // from the check above we already know that
    // \exists v,v' . pre_tgt(v') && pre_src(v) is SAT (or timeout)
    // so \forall v . pre_tgt && (!pre_src(v) || refines) simplifies to:
    // (pre_tgt && !pre_src) || (!pre_src && false) ->   [assume refines=false]
    // \forall v . (pre_tgt && !pre_src(v)) ->  [\exists v . pre_src(v)]
    // false
    if (refines.isFalse())
      return std::move(refines);

    auto fml = pre_tgt && pre_src.implies(refines);
    return axioms_expr && preprocess(t, qvars, uvars, std::move(fml));
  };


  const IR::Type &ty = t.src.getType();
  auto [poison_cnstr, value_cnstr] = ty.refines(src_state, tgt_state, sv.val, tv.val);
  expr dom = dom_a && dom_b;

/*  auto src_mem = src_state.returnMemory();
  auto tgt_mem = tgt_state.returnMemory();
  auto [memory_cnstr0, ptr_refinement0, mem_undef]
    = src_mem.refined(tgt_mem, false);
  qvars.insert(mem_undef.begin(), mem_undef.end());*/

  // TODO: dom check seems redundant
  // TODO: add memory back here
  auto r = check_expr(mk_fml(poison_cnstr && value_cnstr));

  if (r.isInvalid()) {
    errs.add("Invalid expr", false);
    return errs;
  }

  if (r.isTimeout()) {
    errs.add("Timeout", false);
    return errs;
  }

  if (r.isError()) {
    errs.add("SMT Error: " + r.getReason(), false);
    return errs;
  }

  if (r.isSkip()) {
    errs.add("Skip", false);
    return errs;
  }

  if (r.isUnsat()) {
    errs.add("Unsat", false);
    return errs;
  }

  stringstream s;
  auto &m = r.getModel();
  s << ";result\n";
  for (auto &i : tgt_state.getFn().getInputs()) {
    if (!dynamic_cast<const Input*>(&i) &&
        !dynamic_cast<const ConstantInput*>(&i))
        continue;

    auto *val = tgt_state.at(i);
    if (!val)
      continue;

    if (i.getName().rfind("%_reservedc", 0) == 0) {
      auto In = dynamic_cast<const Input*>(&i);
      result[In] = m.eval(val->val.value, true);
      s << i << " = ";
      tools::print_model_val(s, tgt_state, m, &i, i.getType(), val->val);
      s << '\n';
    }
  }
  *debug << s.str() << endl;
  return errs;
}

static const llvm::fltSemantics &getFloatSemantics(unsigned BitWidth) {
  switch (BitWidth) {
  default:
    llvm_unreachable("Unsupported floating-point semantics!");
    break;
  case 16:
    return llvm::APFloat::IEEEhalf();
  case 32:
    return llvm::APFloat::IEEEsingle();
  case 64:
    return llvm::APFloat::IEEEdouble();
  case 128:
    return llvm::APFloat::IEEEquad();
  }
}

// call constant synthesizer and fill in constMap if synthesis suceeeds
bool
AliveEngine::constantSynthesis(llvm::Function &src, llvm::Function &tgt,
   unordered_map<llvm::Argument*, llvm::Constant*>& ConstMap) {

  std::optional<smt::smt_initializer> smt_init;
  smt_init.emplace();

  auto Func1 = llvm_util::llvm2alive(src, TLI.getTLI(src), true);
  auto Func2 = llvm_util::llvm2alive(tgt, TLI.getTLI(tgt), true);

  if (!Func1.has_value() || !Func2.has_value()) {
    *debug << "error found when converting llvm to alive2\n";
    return false;
  }

  unordered_map<string, Argument*> Arguments;
  for (auto &arg : tgt.args()) {
    string ArgName = "%" + string(arg.getName());
    if (ArgName.starts_with("%_reservedc")) {
      Arguments[ArgName] = &arg;
    }
  }

  Transform t;
  t.src = std::move(*Func1);
  t.tgt = std::move(*Func2);

  unordered_map<const IR::Value*, Argument*> Inputs;
  for (auto &&I : t.tgt.getInputs()) {
    string InputName = I.getName();

    if (InputName.starts_with("%_reservedc")) {
      Inputs[&I] = Arguments[InputName];
    }
  }

  // assume type verifies
  std::unordered_map<const IR::Value*, smt::expr> result;
  Errors errs = find_model(t, result);

  bool ret(errs);
  if (ret) {
    *debug << "unable to find constants: \n" << errs;
    return false;
  }

  for (auto I : Inputs) {
    auto ty = I.second->getType();
    if (ty->isIntegerTy()) {
      IntegerType *ity = cast<IntegerType>(ty);
      ConstMap[I.second] =
        ConstantInt::get(ity, result[I.first].numeral_string(), 10);
    } else if (ty->isIEEELikeFPTy()) {
      unsigned bits = ty->getPrimitiveSizeInBits();
      APInt integer(bits, result[I.first].numeral_string(), 10);
      APFloat fp(getFloatSemantics(bits), integer);

      ConstMap[I.second] = ConstantFP::get(ty, fp);
    } else if (ty->isVectorTy()) {
      auto flat = result[I.first];
      FixedVectorType *vty = cast<FixedVectorType>(ty);
      auto ety = vty->getElementType();
      unsigned bits = vty->getScalarSizeInBits();
      SmallVector<llvm::Constant*> v;
      for (int i = vty->getElementCount().getKnownMinValue()-1; i >= 0; i --) {
        auto elem = flat.extract((i + 1) * bits - 1, i * bits);
        if (!elem.isConst())
          return false;

        if (ety->isIntegerTy()) {
          IntegerType *ety = cast<IntegerType>(vty->getElementType());
          v.push_back(ConstantInt::get(ety, elem.numeral_string(), 10));
        } else if (ety->isIEEELikeFPTy()) {
          APInt integer(bits, elem.numeral_string(), 10);
          APFloat fp(getFloatSemantics(bits), integer);
          v.push_back(ConstantFP::get(ety, fp));
        } else {
          UNREACHABLE();
        }
      }
      ConstMap[I.second] = ConstantVector::get(v);
    }
    else {
      UNREACHABLE();
    }
  }

  return true;
}

}
