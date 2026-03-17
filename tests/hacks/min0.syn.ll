; Hacker's Delight: branchless signed min
; min(x, y) = y ^ ((x ^ y) & -(x < y))
; CHECK: smin i32

define i32 @min_hd(i32 %x, i32 %y) {
  %xor = xor i32 %x, %y
  %cmp = icmp slt i32 %x, %y
  %sext = sext i1 %cmp to i32
  %and = and i32 %xor, %sext
  %min = xor i32 %y, %and
  ret i32 %min
}
