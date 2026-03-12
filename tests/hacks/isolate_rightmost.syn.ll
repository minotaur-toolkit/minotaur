; Hacker's Delight: isolate the rightmost 1-bit
; x & (-x) — extracts the lowest set bit
; CHECK-NOT: error

define i32 @isolate_rightmost(i32 %x) {
  %neg = sub i32 0, %x
  %r = and i32 %x, %neg
  ret i32 %r
}
