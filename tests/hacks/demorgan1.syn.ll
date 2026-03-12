; De Morgan's law: ~(a | b) == ~a & ~b
; The multi-instruction form should simplify
; CHECK-NOT: error

define i32 @demorgan_or(i32 %a, i32 %b) {
  %nota = xor i32 %a, -1
  %notb = xor i32 %b, -1
  %r = and i32 %nota, %notb
  ret i32 %r
}
