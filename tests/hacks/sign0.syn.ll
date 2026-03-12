; Hacker's Delight: sign function
; sign(x) = (x >> 31) | (-x >>> 31)
;         = -1 if x < 0, 0 if x == 0, 1 if x > 0
; CHECK-NOT: error

define i32 @sign_hd(i32 %x) {
  %shr = ashr i32 %x, 31
  %neg = sub i32 0, %x
  %lshr = lshr i32 %neg, 31
  %sign = or i32 %shr, %lshr
  ret i32 %sign
}
