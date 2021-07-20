// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "ConstantSynthesis.h"

#include "ir/globals.h"
#include "smt/smt.h"
#include "util/config.h"
#include "util/errors.h"
#include "util/symexec.h"

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

static bool is_arbitrary(const expr &e) {
  if (e.isConst())
    return false;
  return check_expr(expr::mkForAll(e.vars(), expr::mkVar("#someval", e) != e)).
           isUnsat();
}

static void print_single_varval(ostream &os, State &st, const Model &m,
                                const Value *var, const Type &type,
                                const StateValue &val, unsigned child) {
  if (!val.isValid()) {
    os << "(invalid expr)";
    return;
  }

  // if the model is partial, we don't know for sure if it's poison or not
  // this happens if the poison constraint depends on an undef
  // however, cexs are usually triggered by the worst case, which is poison
  if (auto v = m.eval(val.non_poison);
      (!v.isConst() || v.isFalse())) {
    os << "poison";
    return;
  }

  if (auto *in = dynamic_cast<const Input*>(var)) {
    auto var = in->getUndefVar(type, child);
    if (var.isValid() && m.eval(var, false).isAllOnes()) {
      os << "undef";
      return;
    }
  }

  // TODO: detect undef bits (total or partial) with an SMT query

  expr partial = m.eval(val.value);
  if (is_arbitrary(partial)) {
    os << "any";
    return;
  }

  type.printVal(os, st, m.eval(val.value, true));

  // undef variables may not have a model since each read uses a copy
  // TODO: add intervals of possible values for ints at least?
  if (!partial.isConst()) {
    // some functions / vars may not have an interpretation because it's not
    // needed, not because it's undef
    for (auto &var : partial.vars()) {
      if (isUndef(var)) {
        os << "\t[based on undef value]";
        break;
      }
    }
  }
}

static void print_varval(ostream &os, State &st, const Model &m,
                         const Value *var, const Type &type,
                         const StateValue &val, unsigned child = 0) {
  if (!type.isAggregateType()) {
    print_single_varval(os, st, m, var, type, val, child);
    return;
  }

  os << (type.isStructType() ? "{ " : "< ");
  auto agg = type.getAsAggregateType();
  for (unsigned i = 0, e = agg->numElementsConst(); i < e; ++i) {
    if (i != 0)
      os << ", ";
    print_varval(os, st, m, var, agg->getChild(i), agg->extract(val, i),
                 child + i);
  }
  os << (type.isStructType() ? " }" : " >");
}

using print_var_val_ty = function<void(ostream&, const Model&)>;

namespace vectorsynth {

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

  auto uvars = sv.second;
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
      qvars.insert(val.first.value);
      continue;
    }

    if (ty.isVectorType() && ty.getAsAggregateType()->getChild(0).isIntType()) {
      auto aty = ty.getAsAggregateType();
      for (unsigned I = 0; I < aty->numElementsConst(); ++I) {
        qvars.insert(aty->extract(val.first, I, false).value);
      }
      continue;
    }

    config::dbg()<<"constant synthesizer now only supports synthesizing integers and vector of integers"<<std::endl;
    return errs;
  }
  auto dom_a = src_state.returnDomain()();
  auto dom_b = tgt_state.returnDomain()();

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
  auto [poison_cnstr, value_cnstr] = ty.refines(src_state, tgt_state, sv.first, tv.first);
  if (config::debug) {
    config::dbg()<<"SV"<<std::endl;
    config::dbg()<<sv.first<<std::endl;
    config::dbg()<<"TV"<<std::endl;
    config::dbg()<<tv.first<<std::endl;
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
      result[In] = m.eval(val.first.value);
      s << *var << " = ";
      print_varval(s, src_state, m, var, var->getType(), val.first);
      s << '\n';
    }
  }
  config::dbg()<<s.str();

  return errs;
}

}
