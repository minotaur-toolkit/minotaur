// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "alive-interface.h"

#include "ir/globals.h"
#include "llvm_util/llvm2alive.h"
#include "smt/smt.h"
#include "util/compiler.h"
#include "util/errors.h"
#include "util/symexec.h"
#include "tools/transform.h"
#include "llvm_util/compare.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Argument.h"
#include "llvm/Transforms/Utils/Local.h"

#include <sstream>
#include <unordered_map>

using namespace IR;
using namespace smt;
using namespace tools;
using namespace util;
using namespace std;

using namespace llvm;

// Minotaur constant synthesis wants to be robust to Alive2's NaN payload
// nondeterminism. In particular, for FP returns we usually only care that both
// sides return *a* NaN, not that the exact bit-pattern matches.
static pair<expr, expr>
refines_relaxed_nan(const IR::Type &ty, IR::State &src_s, IR::State &tgt_s,
                    const IR::StateValue &src, const IR::StateValue &tgt) {
  if (ty.isFloatType()) {
    auto *fty = ty.getAsFloatType();
    expr src_qnan = fty->isNaN(src.value, /*signalling=*/false);
    expr src_snan = fty->isNaN(src.value, /*signalling=*/true);
    expr tgt_qnan = fty->isNaN(tgt.value, /*signalling=*/false);
    expr tgt_snan = fty->isNaN(tgt.value, /*signalling=*/true);
    expr src_nan = src_qnan || src_snan;
    expr tgt_nan = tgt_qnan || tgt_snan;
    // Only relax NaN equality if the NaN came from Alive2's nondeterministic
    // NaN construction (FloatType::fromFloat), which introduces vars like:
    // - "#NaN*" (fresh nondet vars)
    // - "choice*" (ChoiceExpr selector)
    // - "#preferred_qnan"
    //
    // This avoids breaking tests that intentionally depend on exact NaN payload
    // bits, e.g. half insertelement of 0x7C01 (SNaN) vs other NaN payloads.
    auto is_nondet_nan_var = [](const expr &v) -> bool {
      auto name = v.fn_name();
      return name.rfind("#NaN", 0) == 0 ||
             name.rfind("choice", 0) == 0 ||
             name == "#preferred_qnan";
    };
    auto contains_nondet_nan = [&](const expr &e) -> bool {
      for (const auto &v : e.vars()) {
        if (is_nondet_nan_var(v))
          return true;
      }
      return false;
    };

    bool relax = contains_nondet_nan(src.value) || contains_nondet_nan(tgt.value);
    expr relaxed_eq = (relax ? ((src_nan && tgt_nan) || (src.value == tgt.value))
                             : (src.value == tgt.value));
    return { src.non_poison.implies(tgt.non_poison),
             (src.non_poison && tgt.non_poison).implies(relaxed_eq) };
  }

  if (auto aty = ty.getAsAggregateType()) {
    smt::AndExpr poison, value;
    for (unsigned i = 0, e = aty->numElementsConst(); i < e; ++i) {
      auto [p, v] = refines_relaxed_nan(aty->getChild(i), src_s, tgt_s,
                                        aty->extract(src, i),
                                        aty->extract(tgt, i));
      poison.add(std::move(p));
      value.add(std::move(v));
    }
    return { poison(), value() };
  }

  // Default to Alive2's standard refinement.
  return ty.refines(src_s, tgt_s, src, tgt);
}

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

namespace minotaur {

static std::ostream NOP_OSTREAM(nullptr);

AliveEngine::AliveEngine(llvm::TargetLibraryInfoWrapperPass &TLI) : TLI(TLI) {
  util::config::disable_undef_input = true;
  util::config::disable_poison_input = false;
  debug = config::debug_tv ? &std::cerr : &NOP_OSTREAM;
}

bool
AliveEngine::compareFunctions(llvm::Function &Func1, llvm::Function &Func2) {
  smt::smt_initializer smt_init;
  llvm_util::Verifier verifier(TLI, smt_init, *debug);
  verifier.compareFunctions(Func1, Func2);

  return verifier.num_correct;
}

Errors
AliveEngine::find_model(Transform &t,
                        unordered_map<const IR::Value*, AliveEngine::ModelVal> &result) {

  t.preprocess();

  TransformPrintOpts print_opts;
  t.print(*debug, print_opts);

  tools::TransformVerify tv_exec(t, /*check_each_var=*/false);
  auto [src_state_u, tgt_state_u] = tv_exec.exec();
  auto &src_state = *src_state_u;
  auto &tgt_state = *tgt_state_u;
  auto pre_src_and = src_state.getPre();
  auto &pre_tgt_and = tgt_state.getPre();

  // Optimization: rewrite "tgt /\ (src -> foo)" to "tgt /\ foo" ONLY if
  // pre_src == pre_tgt. Doing this unconditionally weakens the antecedent of
  // the implication and can make incorrect candidates look valid (notably in
  // constant synthesis FP cases like tests/fp/case11.syn.ll).
  //
  // NOTE: We compare the assembled precondition expressions structurally
  // (expr::eq) instead of comparing AndExpr containers, because smt::expr's
  // operator== returns an SMT boolean expression (not a C++ bool).
  expr pre_src = pre_src_and();
  expr pre_tgt = pre_tgt_and();
  if (pre_src.eq(pre_tgt)) {
    pre_src_and.del(pre_tgt_and);
    pre_src = pre_src_and();
  }
  expr axioms_expr = expr(true);

  IR::State::ValTy sv = src_state.returnVal(), tv = tgt_state.returnVal();

  auto uvars = sv.undef_vars;
  set<expr> qvars;
  AndExpr input_nonpoison_cnstr;

  Errors errs;

  for (auto &i : tgt_state.getFn().getInputs()) {
    if (!dynamic_cast<const Input*>(&i))
      continue;

    auto *val = tgt_state.at(i);
    if (!val)
      continue;

    bool is_reservedc_input = i.getName().rfind("%_reservedc") == 0;
    if (is_reservedc_input) {
      continue;
    }

    auto &ty = i.getType();

    if (ty.isIntType() || ty.isFloatType()) {
      qvars.insert(val->val.value);
      // Allow poison synthesis only for reserved constants; real inputs are
      // constrained to be non-poison so synthesis can't "cheat" by picking
      // poison for inputs.
      auto &np = val->val.non_poison;
      input_nonpoison_cnstr.add(np.isBool() ? expr(np) : (np == expr::mkInt(-1, np)));
      continue;
    }

    auto aty = ty.getAsAggregateType();
    if (ty.isVectorType()) {
      if (aty->getChild(0).isIntType() || aty->getChild(0).isFloatType()) {
        for (unsigned I = 0; I < aty->numElementsConst(); ++I) {
          qvars.insert(aty->extract(val->val, I, false).value);
        }
        auto &np = val->val.non_poison;
        input_nonpoison_cnstr.add(np.isBool() ? expr(np) : (np == expr::mkInt(-1, np)));
        continue;
      }
    }

    errs.add("Unknown type is found in argument list.", false);
    return errs;
  }

  // ∃ reserved constants . ∀ (inputs) . refines
  //
  // NOTE: we intentionally do NOT add Alive2's NaN payload/quieting "choice*"
  // / "#NaN*" / "#preferred_qnan" vars to the universal quantifier set (qvars).
  // Doing so makes constant synthesis spuriously UNSAT in FP tests like fadd2.


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

    // Simplify aggressively: this can eliminate spurious NaN nondeterminism
    // introduced by Alive2's conservative FP-to-bits lowering (fromFloat) in
    // cases where the expression is in fact non-NaN (e.g. some maxnum patterns).
    auto fml = (axioms_expr && input_nonpoison_cnstr() &&
                (pre_tgt && pre_src.implies(refines))).simplify();

    // Quantification matters a lot for constant synthesis soundness:
    // any Alive2 "quantified vars" (undef-related, etc.) and "nondet vars"
    // (e.g. NaN payload/quieting choices) must NOT remain as free top-level
    // existentials, otherwise Z3 can pick them to make an incorrect constant
    // appear valid (e.g. tests/fp/case11.syn.ll collapsing to ret false).
    //
    // We follow Alive2's refinement checking strategy: quantify source quantvars,
    // source nondet vars, and target fn-call quantvars.
    auto is_reservedc = [](const expr &v) -> bool {
      auto name = v.fn_name();
      return name.rfind("%_reservedc", 0) == 0;
    };

    auto add_qvars = [&](const std::set<expr> &vars) {
      for (const auto &v : vars) {
        if (is_reservedc(v))
          continue;
        qvars.insert(v);
      }
    };

    add_qvars(src_state.getQuantVars());
    // Some Alive2 "nondet" vars are true semantic nondeterminism/unknowns
    // (e.g. NaN payload choice), while others intentionally model underspecified
    // behavior (e.g. tie-breaking in min/max intrinsics via maxminnondet!*).
    // Quantifying the latter universally tends to overconstrain constant
    // synthesis and can block legitimate rewrites (e.g. fp/minnum2.syn.ll).
    for (const auto &v : src_state.getNondetVars()) {
      auto name = v.fn_name();
      if (name.rfind("maxminnondet", 0) == 0)
        continue;
      if (is_reservedc(v))
        continue;
      qvars.insert(v);
    }
    add_qvars(tgt_state.getFnQuantVars());

    return preprocess(t, qvars, uvars, std::move(fml));
  };


  const IR::Type &ty = t.src.getType();
  auto [poison_cnstr, value_cnstr]
    = refines_relaxed_nan(ty, src_state, tgt_state, sv.val, tv.val);
  expr dom = dom_a && dom_b;

  // Prefer synthesizing *non-poison* reserved constants when possible:
  // after finding a SAT model, greedily add constraints that force reserved
  // constant(s) to be non-poison (or non-poison lanes) as long as the formula
  // remains SAT. This is purely a model-preference heuristic.
  expr base = mk_fml(poison_cnstr && value_cnstr);
  smt::Solver solver;
  solver.add(base);
  auto r = solver.check("synthesis");

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

  // Try to bias the model toward poison reserved constants (or poison lanes).
  //
  // This is implemented as a *greedy* post-SAT refinement: we add constraints
  // that flip reserved constant(s) to poison (or specific lanes to poison) as
  // long as the formula remains satisfiable.
  //
  // NOTE: We only do this for %_reservedc* inputs (existential vars).
  if (r.isSat()) {
    auto try_add_cnstr = [&](expr cnstr, const char *tag) {
      smt::SolverPush push(solver);
      solver.add(cnstr);
      auto r2 = solver.check(tag);
      if (r2.isSat()) {
        r = std::move(r2);
        // Keep the constraint if it is satisfiable, so later attempts build on it.
        solver.add(std::move(cnstr));
        return;
      }
    };

    for (auto &i : tgt_state.getFn().getInputs()) {
      if (!dynamic_cast<const Input*>(&i))
        continue;
      if (i.getName().rfind("%_reservedc", 0) != 0)
        continue;
      auto *val = tgt_state.at(i);
      if (!val)
        continue;

      const expr &np = val->val.non_poison;

      // Scalar poison: force non_poison=false if it's a bool.
      if (np.isBool()) {
        try_add_cnstr(!np, "synthesis_prefer_poison");
        continue;
      }

      // Vector poison: if non_poison is a bitvector with 1 bit per lane,
      // try to force each lane to be poison (bit=0) greedily.
      unsigned bw = np.bits();
      if (bw > 1) {
        for (unsigned bit = 0; bit < bw; ++bit) {
          auto np_bit = np.extract(bit, bit); // 1-bit BV
          try_add_cnstr(np_bit == expr::mkInt(0, np_bit),
                        "synthesis_prefer_poison_lane");
        }
      }
    }
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
      // Store both the value and its non_poison predicate so callers can
      // synthesize LLVM poison constants (PoisonValue) when needed.
      result[&i] = { m.eval(val->val.value, true), m.eval(val->val.non_poison, true) };
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

  // Alive2's symbolic executor/VCGen is much more robust when the input IR
  // doesn't contain unreachable basic blocks (e.g., "sink" blocks with no preds),
  // which are common in Minotaur's sliced candidates and test corpus.
  //
  // These blocks are semantically irrelevant, but we've observed they can trigger
  // crashes inside Alive2 when doing constant synthesis.
  llvm::removeUnreachableBlocks(src);
  llvm::removeUnreachableBlocks(tgt);

  auto Func1 = llvm_util::llvm2alive(src, TLI.getTLI(src), true);

  if (!Func1.has_value()) {
    *debug << "error found when converting llvm to alive2 (src)\n";
    return false;
  }

  // Target conversion must be done with IsSrc=false and using the globals from
  // the source to keep memories/globals consistent across the pair.
  auto gvsInSrc = Func1->getGlobalVars();
  auto Func2 = llvm_util::llvm2alive(tgt, TLI.getTLI(tgt), false, gvsInSrc);

  if (!Func2.has_value()) {
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
  std::unordered_map<const IR::Value*, AliveEngine::ModelVal> result;
  Errors errs = find_model(t, result);

  bool ret(errs);
  if (ret) {
    *debug << "unable to find constants: \n" << errs;
    return false;
  }

  for (auto I : Inputs) {
    auto it = result.find(I.first);
    if (it == result.end()) {
      *debug << "unable to find model value for " << I.first->getName() << "\n";
      return false;
    }
    auto &[model_v, model_np] = it->second;
    auto ty = I.second->getType();

    auto is_poison = [&](const smt::expr &np) -> bool {
      if (!np.isValid())
        return false;
      if (np.isBool())
        return np.isFalse();
      // non_poison is a BV mask; all-ones means non-poison
      return !np.isAllOnes();
    };

    if (ty->isIntegerTy()) {
      if (is_poison(model_np)) {
        ConstMap[I.second] = llvm::PoisonValue::get(ty);
        continue;
      }
      IntegerType *ity = cast<IntegerType>(ty);
      ConstMap[I.second] =
        ConstantInt::get(ity, model_v.numeral_string(), 10);
    } else if (ty->isIEEELikeFPTy()) {
      if (is_poison(model_np)) {
        ConstMap[I.second] = llvm::PoisonValue::get(ty);
        continue;
      }
      unsigned bits = ty->getPrimitiveSizeInBits();
      APInt integer(bits, model_v.numeral_string(), 10);
      APFloat fp(getFloatSemantics(bits), integer);

      ConstMap[I.second] = ConstantFP::get(ty, fp);
    } else if (ty->isVectorTy()) {
      auto flat = model_v;
      FixedVectorType *vty = cast<FixedVectorType>(ty);
      auto ety = vty->getElementType();
      unsigned bits = vty->getScalarSizeInBits();
      SmallVector<llvm::Constant*> v;
      unsigned n = vty->getElementCount().getKnownMinValue();

      // Synthesize per-lane poison using the non_poison bitvector.
      // Alive2 encodes vector non_poison as 1 bit per element, concatenated
      // with element 0 as the MSB. This lets us construct e.g.
      //   <half 0xH7C00, half poison>
      // instead of collapsing to a fully-poison vector.
      for (int i = (int)n - 1; i >= 0; --i) {
        bool lane_poison = false;
        if (model_np.isBV() && model_np.bits() == n) {
          // element 0 is encoded in the MSB; with the extraction order below
          // (i = n-1 .. 0) we have:
          //   i = n-1  -> element 0 -> np bit index = n-1
          //   i = 0    -> element n-1 -> np bit index = 0
          unsigned bit = (unsigned)i;
          auto np_bit = model_np.extract(bit, bit);
          lane_poison = np_bit.isConst() && !np_bit.isAllOnes();
        }

        if (lane_poison) {
          v.push_back(llvm::PoisonValue::get(ety));
          continue;
        }

        auto elem = flat.extract((i + 1) * bits - 1, i * bits);
        if (!elem.isConst())
          return false;

        if (ety->isIntegerTy()) {
          IntegerType *etyi = cast<IntegerType>(vty->getElementType());
          v.push_back(ConstantInt::get(etyi, elem.numeral_string(), 10));
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
