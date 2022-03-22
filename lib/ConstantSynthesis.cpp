// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "ConstantSynthesis.h"

#include "ir/globals.h"
#include "smt/smt.h"
#include "util/config.h"
#include "util/errors.h"
#include "util/symexec.h"
#include "tools/transform.h"

#include <map>
#include <sstream>

using namespace IR;
using namespace smt;
using namespace tools;
using namespace util;
using namespace std;

// borrowed from alive2
static expr preprocess(Transform &t, const set<expr> &qvars0,
                       const set<expr> &undef_qvars, expr &&e) {
  if (hit_half_memory_limit())
    return expr::mkForAll(qvars0, move(e));

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

  return expr::mkForAll(qvars, move(e));
}

namespace minotaur {

Errors ConstantSynthesis::synthesize(unordered_map<const Value*, expr> &result) const {
  //  calculateAndInitConstants(t);
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

  for (auto &[var, val] : src_state.getValues()) {
    if (!dynamic_cast<const Input*>(var))
      continue;

    if (var->getName().rfind("%_reservedc") == 0) {
      continue;
    }

    auto &ty = var->getType();

    if (ty.isIntType()) {
      qvars.insert(val.val.value);
      continue;
    }

    if (ty.isVectorType() && ty.getAsAggregateType()->getChild(0).isIntType()) {
      auto aty = ty.getAsAggregateType();
      for (unsigned I = 0; I < aty->numElementsConst(); ++I) {
        qvars.insert(aty->extract(val.val, I, false).value);
      }
      continue;
    }

    config::dbg()<<"[ERROR] constant synthesizer only supports "
                 <<"synthesizing integers and vector of integers"<<std::endl;
    return errs;
  }
  auto dom_a = sv.domain;
  auto dom_b = tv.domain;

  expr dom = dom_a && dom_b;

  auto mk_fml = [&](expr &&refines) -> expr {
    // from the check above we already know that
    // \exists v,v' . pre_tgt(v') && pre_src(v) is SAT (or timeout)
    // so \forall v . pre_tgt && (!pre_src(v) || refines) simplifies to:
    // (pre_tgt && !pre_src) || (!pre_src && false) ->   [assume refines=false]
    // \forall v . (pre_tgt && !pre_src(v)) ->  [\exists v . pre_src(v)]
    // false
    if (refines.isFalse())
      return move(refines);

    auto fml = pre_tgt && pre_src.implies(refines);
    return axioms_expr && preprocess(t, qvars, uvars, move(fml));
  };


  const Type &ty = t.src.getType();
  auto [poison_cnstr, value_cnstr] = ty.refines(src_state, tgt_state, sv.val, tv.val);
  if (config::debug) {
    config::dbg()<<"SV"<<std::endl;
    config::dbg()<<sv.val<<std::endl;
    config::dbg()<<"TV"<<std::endl;
    config::dbg()<<tv.val<<std::endl;
    config::dbg()<<"Value Constraints"<<std::endl;
    config::dbg()<<value_cnstr<<std::endl;
    config::dbg()<<"Poison Constraints"<<std::endl;
    config::dbg()<<poison_cnstr<<std::endl;
  }

  auto r = check_expr(mk_fml(dom && value_cnstr && poison_cnstr));

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
  for (auto &[var, val] : tgt_state.getValues()) {
    if (!dynamic_cast<const Input*>(var) &&
        !dynamic_cast<const ConstantInput*>(var))
        continue;

    if (var->getName().rfind("%_reservedc", 0) == 0) {
      auto In = static_cast<const Input *>(var);
      result[In] = m.eval(val.val.value);
      s << *var << " = ";
      tools::print_model_val(s, src_state, m, var, var->getType(), val.val);
      s << '\n';
    }
  }
  //config::dbg()<<s.str();

  return errs;
}

}
