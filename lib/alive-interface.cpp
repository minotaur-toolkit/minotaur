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
#include "llvm/Transforms/Utils/Cloning.h"

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

namespace {

struct AliveInputConfigScope {
  bool OldDisableUndef = util::config::disable_undef_input;
  bool OldDisablePoison = util::config::disable_poison_input;

  AliveInputConfigScope(bool DisableUndef, bool DisablePoison) {
    util::config::disable_undef_input = DisableUndef;
    util::config::disable_poison_input = DisablePoison;
  }

  ~AliveInputConfigScope() {
    util::config::disable_undef_input = OldDisableUndef;
    util::config::disable_poison_input = OldDisablePoison;
  }
};

} // namespace

AliveEngine::AliveEngine(llvm::TargetLibraryInfoWrapperPass &TLI) : TLI(TLI) {
  debug = config::debug_tv ? &std::cerr : &NOP_OSTREAM;
}

bool
AliveEngine::compareFunctions(llvm::Function &Func1, llvm::Function &Func2) {
  // Match standalone alive-tv semantics for equivalence checking: undef inputs
  // remain unconstrained, while poison inputs stay enabled.
  AliveInputConfigScope InputConfig(/*DisableUndef=*/false,
                                    /*DisablePoison=*/false);
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
    if (is_reservedc_input)
      continue;

    auto &ty = i.getType();
    if (ty.isIntType() || ty.isFloatType()) {
      qvars.insert(val->val.value);
      auto &np = val->val.non_poison;
      input_nonpoison_cnstr.add(np.isBool() ? expr(np)
                                            : (np == expr::mkInt(-1, np)));
      continue;
    }

    auto aty = ty.getAsAggregateType();
    if (ty.isVectorType()) {
      if (aty->getChild(0).isIntType() || aty->getChild(0).isFloatType()) {
        for (unsigned I = 0; I < aty->numElementsConst(); ++I)
          qvars.insert(aty->extract(val->val, I, false).value);
        auto &np = val->val.non_poison;
        input_nonpoison_cnstr.add(np.isBool() ? expr(np)
                                              : (np == expr::mkInt(-1, np)));
        continue;
      }
    }

    errs.add("Unknown type is found in argument list.", false);
    return errs;
  }

  auto dom_a = sv.domain;
  auto dom_b = tv.domain;

  auto mk_fml = [&](expr &&refines) -> expr {
    if (refines.isFalse())
      return std::move(refines);

    auto fml = (axioms_expr && input_nonpoison_cnstr() &&
                (pre_tgt && pre_src.implies(refines))).simplify();

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
  expr base = mk_fml(!dom || (poison_cnstr && value_cnstr));

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

  // Prefer synthesizing non-poison reserved constants when possible.
  //
  // This is implemented as a *greedy* post-SAT refinement: we add constraints
  // that keep reserved constant(s) non-poison (or specific lanes non-poison)
  // as long as the formula remains satisfiable.
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

      // Scalar values: prefer non-poison.
      if (np.isBool()) {
        try_add_cnstr(np, "synthesis_prefer_nonpoison");
        continue;
      }

      // Vector values: greedily keep each lane non-poison.
      unsigned bw = np.bits();
      if (bw > 1) {
        for (unsigned bit = 0; bit < bw; ++bit) {
          auto np_bit = np.extract(bit, bit); // 1-bit BV
          try_add_cnstr(np_bit == expr::mkInt(1, np_bit),
                        "synthesis_prefer_nonpoison_lane");
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
  // Keep the existing synthesis search behavior: treat undef inputs as
  // disabled while still allowing poison, then concretely re-verify with the
  // stricter compareFunctions() path below.
  AliveInputConfigScope InputConfig(/*DisableUndef=*/true,
                                    /*DisablePoison=*/false);
  {
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

    // The SMT model expressions in 'result' belong to the solver/context used by
    // find_model(). Drop them before leaving this scope.
    result.clear();
  }

  // Re-verify the concretized target with the standard Alive2 verifier.
  // This guards the synthesis-specific model search against accidentally
  // accepting an existential assignment that does not hold as a concrete
  // refinement once the reserved constants are materialized in LLVM IR.
  llvm::ValueToValueMapTy CloneMap;
  llvm::Function *ConcreteTgt = llvm::CloneFunction(&tgt, CloneMap);
  ConcreteTgt->setName(tgt.getName() + ".constcheck");

  for (auto &[Arg, C] : ConstMap) {
    auto It = CloneMap.find(Arg);
    if (It == CloneMap.end())
      return false;
    auto *ClonedArg = llvm::cast<llvm::Argument>(It->second);
    ClonedArg->replaceAllUsesWith(C);
  }

  bool Verified = compareFunctions(src, *ConcreteTgt);
  ConcreteTgt->eraseFromParent();
  if (!Verified) {
    *debug << "constant synthesis model did not survive concrete re-verification\n";
    return false;
  }

  return true;
}

}
