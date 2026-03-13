; De Morgan's: ~x & ~y → ~(x | y)
; 3 instructions → 2 instructions (or + xor -1)
; Requires depth-2: output is xor(or(x,y), -1)
; CHECK: or i32

define i32 @nor(i32 %x, i32 %y) {
  %nx = xor i32 %x, -1
  %ny = xor i32 %y, -1
  %r = and i32 %nx, %ny
  ret i32 %r
}
