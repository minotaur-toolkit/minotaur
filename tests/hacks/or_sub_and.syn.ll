; Hacker's Delight: (x | y) - (x & y) == x ^ y
; Requires depth-2 enumeration to discover the xor rewrite
; CHECK: xor i32

define i32 @or_sub_and(i32 %x, i32 %y) {
  %or = or i32 %x, %y
  %and = and i32 %x, %y
  %r = sub i32 %or, %and
  ret i32 %r
}
