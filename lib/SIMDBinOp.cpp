// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "SIMDBinOp.h"

#include "ir/instr.h"
#include "ir/function.h"
#include "ir/globals.h"
#include "ir/type.h"
#include "smt/expr.h"
#include "smt/exprs.h"
#include "smt/solver.h"
#include "util/compiler.h"

#include "llvm/IR/IntrinsicsX86.h"

#include <functional>
#include <sstream>
#include <iostream>
#include <array>

using namespace smt;
using namespace util;
using namespace std;

namespace IR {

vector<Value*> SIMDBinOp::operands() const {
  return { a, b };
}

#define RAUW(val)    \
  if (val == &what)  \
    val = &with

void SIMDBinOp::rauw(const Value &what, Value &with) {
  RAUW(a);
  RAUW(b);
}

string SIMDBinOp::getOpName(Op op) {
  string str;
  switch (op) {
  case x86_sse2_pavg_w:
    str = "x86.sse2.pavg.w";
  case x86_ssse3_pshuf_b_128:
    str = "x86.ssse3.pshuf.b.128";
    break;
  case x86_avx2_packssdw:
    str = "x86.avx2.packssdw";
    break;
  case x86_avx2_packsswb:
    str = "x86.avx2.packsswb";
    break;
  case x86_avx2_packusdw:
    str = "x86.avx2.packusdw";
    break;
  case x86_avx2_packuswb:
    str = "x86.avx2.packuswb";
    break;
  case x86_avx2_pavg_b:
    str = "x86.avx2.pavg.b";
    break;
  case x86_avx2_pavg_w:
    str = "x86.avx2.pavg.w";
    break;
  case x86_avx2_phadd_d:
    str = "x86.avx2.phadd.d";
    break;
  case x86_avx2_phadd_sw:
    str = "x86.avx2.phadd.sw";
    break;
  case x86_avx2_phadd_w:
    str = "x86.avx2.phadd.w";
    break;
  case x86_avx2_phsub_d:
    str = "x86.avx2.phsub.d";
    break;
  case x86_avx2_phsub_sw:
    str = "x86.avx2.phsub.sw";
    break;
  case x86_avx2_phsub_w:
    str = "x86.avx2.phsub.w";
    break;
  case x86_avx2_pmadd_ub_sw:
    str = "x86.avx2.pmadd.ub.sw";
    break;
  case x86_avx2_pmadd_wd:
    str = "x86.avx2.pmadd.wd";
    break;
  case x86_avx2_pmul_hr_sw:
    str = "x86.avx2.pmul.hr.sw";
    break;
  case x86_avx2_pmulh_w:
    str = "x86.avx2.pmulh.w";
    break;
  case x86_avx2_pmulhu_w:
    str = "x86.avx2.pmulhu.w";
    break;
  case x86_avx2_psign_b:
    str = "x86.avx2.psign.b";
    break;
  case x86_avx2_psign_d:
    str = "x86.avx2.psign.d";
    break;
  case x86_avx2_psign_w:
    str = "x86.avx2.psign.w";
    break;
  case x86_avx2_psll_d:
    str = "x86.avx2.psll.d";
    break;
  case x86_avx2_psll_q:
    str = "x86.avx2.psll.q";
    break;
  case x86_avx2_psll_w:
    str = "x86.avx2.psll.w";
    break;
  case x86_avx2_psllv_d:
    str = "x86.avx2.psllv.d";
    break;
  case x86_avx2_psllv_d_256:
    str = "x86.avx2.psllv.d.256";
    break;
  case x86_avx2_psllv_q:
    str = "x86.avx2.psllv.q";
    break;
  case x86_avx2_psllv_q_256:
    str = "x86.avx2.psllv.q.256";
    break;
  case x86_avx2_psrav_d:
    str = "x86.avx2.psrav.d";
    break;
  case x86_avx2_psrav_d_256:
    str = "x86.avx2.psrav.d.256";
    break;
  case x86_avx2_psrl_d:
    str = "x86.avx2.psrl.d";
    break;
  case x86_avx2_psrl_q:
    str = "x86.avx2.psrl.q";
    break;
  case x86_avx2_psrl_w:
    str = "x86.avx2.psrl.w";
    break;
  case x86_avx2_psrlv_d:
    str = "x86.avx2.psrlv.d";
    break;
  case x86_avx2_psrlv_d_256:
    str = "x86.avx2.psrlv.d.256";
    break;
  case x86_avx2_psrlv_q:
    str = "x86.avx2.psrlv.q";
    break;
  case x86_avx2_psrlv_q_256:
    str = "x86.avx2.psrlv.q.256";
    break;
  case x86_avx2_pshuf_b:
    str = "x86.avx2.pshuf.b";
    break;
  case x86_bmi_pdep_32:
    str = "x86.bmi.pdep.32";
    break;
  case x86_bmi_pdep_64:
    str = "x86.bmi.pdep.64";
    break;
  }
  return str;
}

void SIMDBinOp::print(ostream &os) const {
  os << getName() << " = " << getOpName(op) << " " << *a << ", " << *b;
}

StateValue SIMDBinOp::toSMT(State &s) const {
  auto ty = getType().getAsAggregateType();
  auto aty = a->getType().getAsAggregateType();
  auto bty = b->getType().getAsAggregateType();
  auto &op1 = s[*a];
  auto &op2 = s[*b];

  switch (op) {
  case x86_bmi_pdep_32:
  case x86_bmi_pdep_64: {
    assert (!ty && !aty && !bty);
    // TODO
    UNREACHABLE();
    return { op1.value + op2.value, true };
  }
  // pack both operands and combine
  case x86_avx2_packssdw:
  case x86_avx2_packsswb:
  case x86_avx2_packusdw:
  case x86_avx2_packuswb: {
    vector<StateValue> vals;
    unsigned bw = op == x86_avx2_packssdw || op == x86_avx2_packusdw ? 16 : 8;

    function<expr(const expr&)> fn;
    fn = [&](auto a) -> expr {
      switch (op) {
      case x86_avx2_packssdw:
      case x86_avx2_packsswb: {
        auto smin = expr::IntSMin(bw);
        auto smax = expr::IntSMax(bw);
        return expr::mkIf(a.sle(smin.sext(bw)), smin,
                          expr::mkIf(a.sge(smax.sext(bw)),
                                     smax, a.trunc(bw)));
      }
      case x86_avx2_packusdw:
      case x86_avx2_packuswb: {
        auto umax = expr::IntUMax(bw);
        return expr::mkIf(a.uge(umax.zext(bw)), umax, a.trunc(bw));
      }
      default:
        UNREACHABLE();
      }
    };

    for (unsigned i = 0, e = aty->numElementsConst(); i != e; ++i) {
      auto ai = aty->extract(op1, i);
      vals.emplace_back(fn(ai.value), move(ai.non_poison));
    }
    for (unsigned i = 0, e = bty->numElementsConst(); i != e; ++i) {
      auto bi = bty->extract(op2, i);
      vals.emplace_back(fn(bi.value), move(bi.non_poison));
    }
    return ty->aggregateVals(vals);
  }
  // bitwise arithmetics
  case x86_sse2_pavg_w:
  case x86_avx2_pavg_b:
  case x86_avx2_pavg_w:
  case x86_avx2_pmul_hr_sw:
  case x86_avx2_pmulh_w:
  case x86_avx2_pmulhu_w:
  case x86_avx2_psign_b:
  case x86_avx2_psign_d:
  case x86_avx2_psign_w:
  case x86_avx2_psllv_d:
  case x86_avx2_psllv_d_256:
  case x86_avx2_psllv_q:
  case x86_avx2_psllv_q_256:
  case x86_avx2_psrav_d:
  case x86_avx2_psrav_d_256:
  case x86_avx2_psrlv_d:
  case x86_avx2_psrlv_d_256:
  case x86_avx2_psrlv_q:
  case x86_avx2_psrlv_q_256: {
    vector<StateValue> vals;
    function<expr(const expr&, const expr&)> fn;
    switch (op) {
    case x86_avx2_pavg_b:
      fn = [&](auto a, auto b) -> expr {
        return (a + b + expr::mkUInt(1, 8)).lshr(expr::mkUInt(1, 8));
      };
      break;
    case x86_sse2_pavg_w:
    case x86_avx2_pavg_w:
      fn = [&](auto a, auto b) -> expr {
        return (a + b + expr::mkUInt(1, 16)).lshr(expr::mkUInt(1, 16));
      };
      break;
    case x86_avx2_pmul_hr_sw:
      fn = [&](auto a, auto b) -> expr {
        expr t = (a.sext(16) * b.sext(16)).lshr(expr::mkUInt(14, 32));
        return (t + expr::mkUInt(1, 32)).extract(16, 1);
      };
      break;
    case x86_avx2_pmulh_w:
      fn = [&](auto a, auto b) -> expr {
        return (a.sext(16) * b.sext(16)).extract(31, 16);
      };
      break;
    case x86_avx2_pmulhu_w:
      fn = [&](auto a, auto b) -> expr {
        return (a.zext(16) * b.zext(16)).extract(31, 16);
      };
      break;
    case x86_avx2_psign_b:
    case x86_avx2_psign_d:
    case x86_avx2_psign_w:
      fn = [&](auto a, auto b) -> expr {
        expr zero = expr::mkUInt(0, binop_op0_v[op].second);
        expr neg = zero - a;
        auto bit = b.bits() - 1;
        return expr::mkIf(b == zero,
                          zero,
                          expr::mkIf((b.extract(bit, bit) == expr::mkInt(1, 1)), neg, a));
      };
      break;
    case x86_avx2_psllv_d:
    case x86_avx2_psllv_d_256:
    case x86_avx2_psllv_q:
    case x86_avx2_psllv_q_256:
      fn = [&](auto a, auto b) -> expr {
        return a << b;
      };
      break;
    case x86_avx2_psrav_d:
    case x86_avx2_psrav_d_256:
      fn = [&](auto a, auto b) -> expr {
        return a.ashr(b);
      };
      break;
    case x86_avx2_psrlv_d:
    case x86_avx2_psrlv_d_256:
    case x86_avx2_psrlv_q:
    case x86_avx2_psrlv_q_256:
      fn = [&](auto a, auto b) -> expr {
        return a.lshr(b);
      };
      break;
    default:
      UNREACHABLE();
    };
    for (unsigned i = 0, e = ty->numElementsConst(); i != e; ++i) {
      auto ai = ty->extract(op1, i);
      auto bi = ty->extract(op2, i);
      vals.emplace_back(fn(ai.value, bi.value),
                        ai.non_poison && bi.non_poison);
    }
    return ty->aggregateVals(vals);
  }
  // (binop vector scalar)
  case x86_avx2_psll_d:
  case x86_avx2_psll_q:
  case x86_avx2_psll_w:
  case x86_avx2_psrl_d:
  case x86_avx2_psrl_q:
  case x86_avx2_psrl_w: {
    vector<StateValue> vals;
    unsigned bits = binop_op0_v[op].second;
    expr np = true;
    for (unsigned i = 0, e = bty->numElementsConst(); i < e; ++i) {
      np = np && bty->extract(op2, i).non_poison;
    }
    expr zero = expr::mkUInt(0, binop_op0_v[op].second);
    for (unsigned i = 0, e = aty->numElementsConst(); i != e; ++i) {
      auto ai = aty->extract(op1, i);
      expr t = op2.value.uge(expr::mkUInt(bits, bits * binop_op1_v[op].first));
      expr shift;
      if (op == x86_avx2_psll_d ||
          op == x86_avx2_psll_q ||
          op == x86_avx2_psll_w)
        shift = ai.value << op2.value.trunc(bits);
      else
        shift = ai.value.lshr(op2.value.trunc(bits));
      expr v = expr::mkIf(move(t),
                          move(zero),
                          move(shift));
      vals.emplace_back(move(v), np && ai.non_poison);
    }
    return ty->aggregateVals(vals);
  }

  // fused multiply add
  case x86_avx2_pmadd_ub_sw:
  case x86_avx2_pmadd_wd: {
    vector<StateValue> vals;
    for (unsigned i = 0, e = aty->numElementsConst(); i < e; i = i + 2) {
      auto ai = aty->extract(op1, i);
      auto bi = bty->extract(op2, i);
      auto aj = aty->extract(op1, i + 1);
      auto bj = bty->extract(op2, i + 1);

      unsigned sext_sz = op == x86_avx2_pmadd_ub_sw ? 8 : 16;

      expr v1 = ai.value.sext(sext_sz) * bi.value.sext(sext_sz);
      expr v2 = aj.value.sext(sext_sz) * bj.value.sext(sext_sz);
      expr np = ai.non_poison && bi.non_poison &&
                aj.non_poison && bj.non_poison;
      if (op == x86_avx2_pmadd_ub_sw)
        vals.emplace_back(v1.sadd_sat(v2), move(np));
      else
        vals.emplace_back(v1 + v2, move(np));
    }
    return ty->aggregateVals(vals);
  }

  // horizontal + combine
  case x86_avx2_phadd_d:
  case x86_avx2_phsub_d:
  case x86_avx2_phadd_sw:
  case x86_avx2_phsub_sw:
  case x86_avx2_phadd_w:
  case x86_avx2_phsub_w: {
    vector<StateValue> vals;
    function<expr(const expr&, const expr&)> fn;
    fn = [&](auto a, auto b) -> expr {
      expr ret;
      switch (op) {
      case x86_avx2_phadd_d:
      case x86_avx2_phadd_w:
        ret = a + b;
        break;
      case x86_avx2_phsub_d:
      case x86_avx2_phsub_w:
        ret = a - b;
        break;
      case x86_avx2_phadd_sw:
        ret = a.sadd_sat(b);
        break;
      case x86_avx2_phsub_sw:
        ret = a.ssub_sat(b);
        break;
      default:
        UNREACHABLE();
      }
      return ret;
    };
    unsigned c = (op == x86_avx2_phadd_d || op == x86_avx2_phsub_d) ? 2 : 4;
    for (unsigned i = 0, e = c; i != e; ++i) {
      auto ai1 = aty->extract(op1, 2 * i);
      auto ai2 = aty->extract(op1, 2 * i + 1);
      vals.emplace_back(fn(ai1.value, ai2.value),
                        ai1.non_poison && ai2.non_poison);
    }
    for (unsigned i = 0, e = c; i != e; ++i) {
      auto bi1 = bty->extract(op2, 2 * i);
      auto bi2 = bty->extract(op2, 2 * i + 1);
      vals.emplace_back(fn(bi1.value, bi2.value),
                        bi1.non_poison && bi2.non_poison);
    }
    for (unsigned i = 0, e = c; i != e; ++i) {
      auto ai1 = aty->extract(op1, 2 * i + 2 * c);
      auto ai2 = aty->extract(op1, 2 * i + 2 * c + 1);
      vals.emplace_back(fn(ai1.value, ai2.value),
                        ai1.non_poison && ai2.non_poison);
    }
    for (unsigned i = 0, e = c; i != e; ++i) {
      auto bi1 = bty->extract(op2, 2 * i + 2 * c);
      auto bi2 = bty->extract(op2, 2 * i + 2 * c + 1);
      vals.emplace_back(fn(bi1.value, bi2.value),
                        bi1.non_poison && bi2.non_poison);
    }
    return ty->aggregateVals(vals);
  }

  // shuffle
  case x86_ssse3_pshuf_b_128:
  case x86_avx2_pshuf_b:
    auto vty = static_cast<const VectorType*>(aty);
    vector<StateValue> vals;
    unsigned c;
    switch (op) {
    case x86_ssse3_pshuf_b_128: c = 16; break;
    case x86_avx2_pshuf_b: c = 32; break;
    default: UNREACHABLE();
    }
    for (unsigned i = 0, e = c; i != e; ++i) {
      auto b = (aty->extract(op2, i).value);
      auto r = vty->extract(op1, b & expr::mkUInt(127, 8));
      auto ai = expr::mkIf(b.extract(7, 7) == expr::mkUInt(0, 1),
                            r.value,
                            expr::mkUInt(0, 8));
      auto pi = expr::mkIf(b.extract(7, 7) == expr::mkUInt(0, 1),
                            b.ule(expr::mkUInt(31, 8)) && r.non_poison,
                            true);

      vals.emplace_back(move(ai), move(pi));
    }

    return ty->aggregateVals(vals);
  }
  UNREACHABLE();
}

expr SIMDBinOp::getTypeConstraints(const Function &f) const {
  expr instrconstr;
  switch (op) {
  case x86_bmi_pdep_32:
    instrconstr = getType().enforceIntOrVectorType(32) &&
                  getType() == a->getType() &&
                  getType() == b->getType();
    break;
  case x86_bmi_pdep_64:
    instrconstr = getType().enforceIntOrVectorType(64) &&
                  getType() == a->getType() &&
                  getType() == b->getType();
    break;

  default:
    auto op0 = binop_op0_v[op];
    auto op1 = binop_op1_v[op];
    auto ret = binop_ret_v[op];

    instrconstr = Value::getTypeConstraints() &&
      getType().enforceVectorType() &&
      a->getType().enforceVectorType() &&
      b->getType().enforceVectorType() &&
      // mask is a vector of i32
      a->getType().enforceVectorType([op0](auto &ty)
        { return ty.enforceIntType(op0.second); }) &&
      b->getType().enforceVectorType([op1](auto &ty)
        { return ty.enforceIntType(op1.second); }) &&
      getType().enforceVectorType([ret](auto &ty)
        { return ty.enforceIntType(ret.second); }) &&
      a->getType().getAsAggregateType()->numElements() == op0.first &&
      b->getType().getAsAggregateType()->numElements() == op1.first &&
      getType().getAsAggregateType()->numElements() == ret.first;
    break;
  }
  return instrconstr;
}

unique_ptr<Instr> SIMDBinOp::dup(const string &suffix) const {
  return make_unique<SIMDBinOp>(getType(), getName() + suffix, *a, *b, op);
}

}
