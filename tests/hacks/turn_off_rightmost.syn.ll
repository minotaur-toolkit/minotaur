; Hacker's Delight: turn off the rightmost 1-bit
; x & (x - 1) — also known as Kernighan's bit trick
; CHECK: add

define i32 @turnoff_rightmost(i32 %x) {
  %dec = add i32 %x, -1
  %r = and i32 %x, %dec
  ret i32 %r
}
