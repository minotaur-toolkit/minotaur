; Hacker's Delight: average of two unsigned integers without overflow
; avg(x, y) = (x & y) + ((x ^ y) >> 1)
; CHECK: add

define i32 @avg_floor_hd(i32 %x, i32 %y) {
  %and = and i32 %x, %y
  %xor = xor i32 %x, %y
  %shr = lshr i32 %xor, 1
  %avg = add i32 %and, %shr
  ret i32 %avg
}
