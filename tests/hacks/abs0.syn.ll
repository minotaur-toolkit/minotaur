; Hacker's Delight: absolute value without branching
; abs(x) = (x ^ (x >> 31)) - (x >> 31)
; expected: minotaur finds a simpler form
; CHECK-NOT: error

define i32 @abs_hd(i32 %x) {
  %shr = ashr i32 %x, 31
  %xor = xor i32 %x, %shr
  %abs = sub i32 %xor, %shr
  ret i32 %abs
}
