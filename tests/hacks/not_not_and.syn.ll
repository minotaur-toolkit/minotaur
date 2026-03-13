; De Morgan's: ~(~x & ~y) == x | y
; 4 instructions reduced to 2 (or + xor with -1)
; CHECK: or i32

define i32 @not_not_and(i32 %x, i32 %y) {
  %nx = xor i32 %x, -1
  %ny = xor i32 %y, -1
  %a = and i32 %nx, %ny
  %r = xor i32 %a, -1
  ret i32 %r
}
