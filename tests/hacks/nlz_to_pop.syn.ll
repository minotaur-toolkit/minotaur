; Hacker's Delight: propagate leftmost 1-bit right, then popcount
; Computes floor(log2(x)) + 1 = 32 - nlz(x) for x != 0
; This is a common SWAR bit-smearing pattern
; CHECK: ctpop

define i32 @smear_popcount(i32 %x) {
  %s1 = lshr i32 %x, 1
  %o1 = or i32 %x, %s1
  %s2 = lshr i32 %o1, 2
  %o2 = or i32 %o1, %s2
  %s3 = lshr i32 %o2, 4
  %o3 = or i32 %o2, %s3
  %s4 = lshr i32 %o3, 8
  %o4 = or i32 %o3, %s4
  %s5 = lshr i32 %o4, 16
  %o5 = or i32 %o4, %s5
  %pop = call i32 @llvm.ctpop.i32(i32 %o5)
  ret i32 %pop
}

declare i32 @llvm.ctpop.i32(i32)
