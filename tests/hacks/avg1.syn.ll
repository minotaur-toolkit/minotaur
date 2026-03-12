; Hacker's Delight: ceiling average without overflow
; avg_ceil(x, y) = (x | y) - ((x ^ y) >> 1)
; CHECK: sub

define i32 @avg_ceil_hd(i32 %x, i32 %y) {
  %or = or i32 %x, %y
  %xor = xor i32 %x, %y
  %shr = lshr i32 %xor, 1
  %avg = sub i32 %or, %shr
  ret i32 %avg
}
