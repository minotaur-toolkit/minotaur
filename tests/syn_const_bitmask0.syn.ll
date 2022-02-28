; CHECK: 16776960

define i32 @mask(i32 %x) {
  %shr = lshr i32 %x, 8
  %shl = shl i32 %shr, 16
  %shr.2 = lshr i32 %shl, 8
  ret i32 %shr.2
}

