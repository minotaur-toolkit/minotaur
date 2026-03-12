; Hacker's Delight: midpoint without overflow (signed)
; midpoint(a, b) = a + (b - a) / 2
; More robust than (a + b) / 2 which overflows
; CHECK: add

define i32 @midpoint_hd(i32 %a, i32 %b) {
  %diff = sub i32 %b, %a
  %half = ashr i32 %diff, 1
  %mid = add i32 %a, %half
  ret i32 %mid
}
