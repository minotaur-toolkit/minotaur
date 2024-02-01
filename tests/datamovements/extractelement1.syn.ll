; CHECK: extractelement <2 x i32> %x, i32 0
define i32 @extractelement_out_of_range(<2 x i32> %x, i32 %i) {
  %p = sub i32 %i, %i
  %E1 = extractelement <2 x i32> %x, i32 %p
  ret i32 %E1
}