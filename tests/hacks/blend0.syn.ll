; Hacker's Delight: bitwise blend / conditional select
; blend(mask, a, b) = (a & mask) | (b & ~mask)
; Equivalent to: b ^ ((a ^ b) & mask)
; CHECK-NOT: error

define i32 @blend_hd(i32 %mask, i32 %a, i32 %b) {
  %xor = xor i32 %a, %b
  %and = and i32 %xor, %mask
  %r = xor i32 %b, %and
  ret i32 %r
}
