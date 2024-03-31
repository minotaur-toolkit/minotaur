; CHECK:  insertelement <2 x i64> %1, i64 %i, i16 0
define <4 x i32> @extractelement_out_of_range(<4 x i32> %x, i64 %i) {
  %f = trunc i64 %i to i32
  %g = lshr i64 %i, 32
  %h = trunc i64 %g to i32
  %b = insertelement <4 x i32> %x, i32 %f, i32 0
  %c = insertelement <4 x i32> %b, i32 %h, i32 1
  ret <4 x i32> %c
}