; Hacker's Delight: negate absolute value
; nabs(x) = (x >> 31) - (x ^ (x >> 31))
; = -(abs(x))
; CHECK-NOT: error

define i32 @nabs_hd(i32 %x) {
  %shr = ashr i32 %x, 31
  %xor = xor i32 %x, %shr
  %nabs = sub i32 %shr, %xor
  ret i32 %nabs
}
