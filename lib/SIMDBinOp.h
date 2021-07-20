// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "ir/value.h"
#include "ir/instr.h"

#include <array>

namespace IR {

class Function;

class SIMDBinOp final : public Instr {
public:
  static constexpr std::array<std::pair<unsigned, unsigned>, 41> binop_op0_v = {
  /* x86_sse2_pavg_w */      std::make_pair(8, 16),
  /* x86_ssse3_pshuf_b_128 */std::make_pair(16, 8),
  /* x86_avx2_packssdw */    std::make_pair(8, 32),
  /* x86_avx2_packsswb */    std::make_pair(16, 16),
  /* x86_avx2_packusdw */    std::make_pair(8, 32),
  /* x86_avx2_packuswb */    std::make_pair(16, 16),
  /* x86_avx2_pavg_b */      std::make_pair(32, 8),
  /* x86_avx2_pavg_w */      std::make_pair(16, 16),
  /* x86_avx2_phadd_d */     std::make_pair(8, 32),
  /* x86_avx2_phadd_sw */    std::make_pair(16, 16),
  /* x86_avx2_phadd_w */     std::make_pair(16, 16),
  /* x86_avx2_phsub_d */     std::make_pair(8, 32),
  /* x86_avx2_phsub_sw */    std::make_pair(16, 16),
  /* x86_avx2_phsub_w */     std::make_pair(16, 16),
  /* x86_avx2_pmadd_ub_sw */ std::make_pair(32, 8),
  /* x86_avx2_pmadd_wd */    std::make_pair(16, 16),
  /* x86_avx2_pmul_hr_sw */  std::make_pair(16, 16),
  /* x86_avx2_pmulh_w */     std::make_pair(16, 16),
  /* x86_avx2_pmulhu_w */    std::make_pair(16, 16),
  /* x86_avx2_psign_b */     std::make_pair(32, 8),
  /* x86_avx2_psign_d */     std::make_pair(8, 32),
  /* x86_avx2_psign_w */     std::make_pair(16, 16),
  /* x86_avx2_psll_d */      std::make_pair(8, 32),
  /* x86_avx2_psll_q */      std::make_pair(4, 64),
  /* x86_avx2_psll_w */      std::make_pair(16, 16),
  /* x86_avx2_psllv_d */     std::make_pair(4, 32),
  /* x86_avx2_psllv_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psllv_q */     std::make_pair(2, 64),
  /* x86_avx2_psllv_q_256 */ std::make_pair(4, 64),
  /* x86_avx2_psrav_d */     std::make_pair(4, 32),
  /* x86_avx2_psrav_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psrl_d */      std::make_pair(8, 32),
  /* x86_avx2_psrl_q */      std::make_pair(4, 64),
  /* x86_avx2_psrl_w */      std::make_pair(16, 16),
  /* x86_avx2_psrlv_d */     std::make_pair(4, 32),
  /* x86_avx2_psrlv_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psrlv_q */     std::make_pair(2, 64),
  /* x86_avx2_psrlv_q_256 */ std::make_pair(4, 64),
  /* x86_avx2_pshuf_b */     std::make_pair(32, 8),
  /* x86_bmi_pdep_32 */      std::make_pair(1, 32),
  /* x86_bmi_pdep_64 */      std::make_pair(1, 64),
  };

  static constexpr std::array<std::pair<unsigned, unsigned>, 41> binop_op1_v = {
  /* x86_sse2_pavg_w */      std::make_pair(8, 16),
  /* x86_ssse3_pshuf_b_128 */std::make_pair(16, 8),
  /* x86_avx2_packssdw */    std::make_pair(8, 32),
  /* x86_avx2_packsswb */    std::make_pair(16, 16),
  /* x86_avx2_packusdw */    std::make_pair(8, 32),
  /* x86_avx2_packuswb */    std::make_pair(16, 16),
  /* x86_avx2_pavg_b */      std::make_pair(32, 8),
  /* x86_avx2_pavg_w */      std::make_pair(16, 16),
  /* x86_avx2_phadd_d */     std::make_pair(8, 32),
  /* x86_avx2_phadd_sw */    std::make_pair(16, 16),
  /* x86_avx2_phadd_w */     std::make_pair(16, 16),
  /* x86_avx2_phsub_d */     std::make_pair(8, 32),
  /* x86_avx2_phsub_sw */    std::make_pair(16, 16),
  /* x86_avx2_phsub_w */     std::make_pair(16, 16),
  /* x86_avx2_pmadd_ub_sw */ std::make_pair(32, 8),
  /* x86_avx2_pmadd_wd */    std::make_pair(16, 16),
  /* x86_avx2_pmul_hr_sw */  std::make_pair(16, 16),
  /* x86_avx2_pmulh_w */     std::make_pair(16, 16),
  /* x86_avx2_pmulhu_w */    std::make_pair(16, 16),
  /* x86_avx2_psign_b */     std::make_pair(32, 8),
  /* x86_avx2_psign_d */     std::make_pair(8, 32),
  /* x86_avx2_psign_w */     std::make_pair(16, 16),
  /* x86_avx2_psll_d */      std::make_pair(4, 32),
  /* x86_avx2_psll_q */      std::make_pair(2, 64),
  /* x86_avx2_psll_w */      std::make_pair(8, 16),
  /* x86_avx2_psllv_d */     std::make_pair(4, 32),
  /* x86_avx2_psllv_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psllv_q */     std::make_pair(2, 64),
  /* x86_avx2_psllv_q_256 */ std::make_pair(4, 64),
  /* x86_avx2_psrav_d */     std::make_pair(4, 32),
  /* x86_avx2_psrav_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psrl_d */      std::make_pair(4, 32),
  /* x86_avx2_psrl_q */      std::make_pair(2, 64),
  /* x86_avx2_psrl_w */      std::make_pair(8, 16),
  /* x86_avx2_psrlv_d */     std::make_pair(4, 32),
  /* x86_avx2_psrlv_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psrlv_q */     std::make_pair(2, 64),
  /* x86_avx2_psrlv_q_256 */ std::make_pair(4, 64),
  /* x86_avx2_pshuf_b */     std::make_pair(32, 8),
  /* x86_bmi_pdep_32 */      std::make_pair(1, 32),
  /* x86_bmi_pdep_64 */      std::make_pair(1, 64),
  };

  static constexpr std::array<std::pair<unsigned, unsigned>, 41> binop_ret_v = {
  /* x86_sse2_pavg_w */      std::make_pair(8, 16),
  /* x86_ssse3_pshuf_b_128 */std::make_pair(16, 8),
  /* x86_avx2_packssdw */    std::make_pair(16, 16),
  /* x86_avx2_packsswb */    std::make_pair(32, 8),
  /* x86_avx2_packusdw */    std::make_pair(16, 16),
  /* x86_avx2_packuswb */    std::make_pair(32, 8),
  /* x86_avx2_pavg_b */      std::make_pair(32, 8),
  /* x86_avx2_pavg_w */      std::make_pair(16, 16),
  /* x86_avx2_phadd_d */     std::make_pair(8, 32),
  /* x86_avx2_phadd_sw */    std::make_pair(16, 16),
  /* x86_avx2_phadd_w */     std::make_pair(16, 16),
  /* x86_avx2_phsub_d */     std::make_pair(8, 32),
  /* x86_avx2_phsub_sw */    std::make_pair(16, 16),
  /* x86_avx2_phsub_w */     std::make_pair(16, 16),
  /* x86_avx2_pmadd_ub_sw */ std::make_pair(16, 16),
  /* x86_avx2_pmadd_wd */    std::make_pair(8, 32),
  /* x86_avx2_pmul_hr_sw */  std::make_pair(16, 16),
  /* x86_avx2_pmulh_w */     std::make_pair(16, 16),
  /* x86_avx2_pmulhu_w */    std::make_pair(16, 16),
  /* x86_avx2_psign_b */     std::make_pair(32, 8),
  /* x86_avx2_psign_d */     std::make_pair(8, 32),
  /* x86_avx2_psign_w */     std::make_pair(16, 16),
  /* x86_avx2_psll_d */      std::make_pair(8, 32),
  /* x86_avx2_psll_q */      std::make_pair(4, 64),
  /* x86_avx2_psll_w */      std::make_pair(16, 16),
  /* x86_avx2_psllv_d */     std::make_pair(4, 32),
  /* x86_avx2_psllv_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psllv_q */     std::make_pair(2, 64),
  /* x86_avx2_psllv_q_256 */ std::make_pair(4, 64),
  /* x86_avx2_psrav_d */     std::make_pair(4, 32),
  /* x86_avx2_psrav_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psrl_d */      std::make_pair(8, 32),
  /* x86_avx2_psrl_q */      std::make_pair(4, 64),
  /* x86_avx2_psrl_w */      std::make_pair(16, 16),
  /* x86_avx2_psrlv_d */     std::make_pair(4, 32),
  /* x86_avx2_psrlv_d_256 */ std::make_pair(8, 32),
  /* x86_avx2_psrlv_q */     std::make_pair(2, 64),
  /* x86_avx2_psrlv_q_256 */ std::make_pair(4, 64),
  /* x86_avx2_pshuf_b */     std::make_pair(32, 8),
  /* x86_bmi_pdep_32 */      std::make_pair(1, 32),
  /* x86_bmi_pdep_64 */      std::make_pair(1, 64),
  };

  enum Op { x86_sse2_pavg_w,
            x86_ssse3_pshuf_b_128,
            x86_avx2_packssdw,
            x86_avx2_packsswb,
            x86_avx2_packusdw,
            x86_avx2_packuswb,
            x86_avx2_pavg_b,
            x86_avx2_pavg_w,
            x86_avx2_phadd_d,
            x86_avx2_phadd_sw,
            x86_avx2_phadd_w,
            x86_avx2_phsub_d,
            x86_avx2_phsub_sw,
            x86_avx2_phsub_w,
            x86_avx2_pmadd_ub_sw,
            x86_avx2_pmadd_wd,
            x86_avx2_pmul_hr_sw,
            x86_avx2_pmulh_w,
            x86_avx2_pmulhu_w,
            x86_avx2_psign_b,
            x86_avx2_psign_d,
            x86_avx2_psign_w,
            x86_avx2_psll_d,
            x86_avx2_psll_q,
            x86_avx2_psll_w,
            x86_avx2_psllv_d,
            x86_avx2_psllv_d_256,
            x86_avx2_psllv_q,
            x86_avx2_psllv_q_256,
            x86_avx2_psrav_d,
            x86_avx2_psrav_d_256,
            x86_avx2_psrl_d,
            x86_avx2_psrl_q,
            x86_avx2_psrl_w,
            x86_avx2_psrlv_d,
            x86_avx2_psrlv_d_256,
            x86_avx2_psrlv_q,
            x86_avx2_psrlv_q_256,
            x86_avx2_pshuf_b,
            x86_bmi_pdep_32,
            x86_bmi_pdep_64 };
private:
  Value *a, *b;
  Op op;

public:
  SIMDBinOp(Type &type, std::string &&name, Value &a, Value &b, Op op)
    : Instr(type, move(name)), a(&a), b(&b), op(op) {}
  std::vector<Value*> operands() const override;
  void rauw(const Value &what, Value &with) override;
  void print(std::ostream &os) const override;
  StateValue toSMT(State &s) const override;
  smt::expr getTypeConstraints(const Function &f) const override;
  std::unique_ptr<Instr> dup(const std::string &suffix) const override;
  static std::string getOpName(Op op);
};

}
