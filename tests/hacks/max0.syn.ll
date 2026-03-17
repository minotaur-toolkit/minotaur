; Hacker's Delight: branchless signed max
; max(x, y) = x ^ ((x ^ y) & -(x < y))
; CHECK: smax i32

define i32 @max_hd(i32 %x, i32 %y) {
  %xor = xor i32 %x, %y
  %cmp = icmp slt i32 %x, %y
  %sext = sext i1 %cmp to i32
  %and = and i32 %xor, %sext
  %max = xor i32 %x, %and
  ret i32 %max
}
