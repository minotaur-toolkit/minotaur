; CHECK: shufflevector <2 x i32> %1, <2 x i32> <i32 4, i32 3>, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
define <4 x i32> @extractelement_out_of_range(<4 x i32> %x, i64 %i) {
  %f = trunc i64 %i to i32
  %g = lshr i64 %i, 32
  %h = trunc i64 %g to i32
  %b = insertelement <4 x i32> <i32 1, i32 2, i32 3, i32 4>, i32 %f, i32 0
  %c = insertelement <4 x i32> %b, i32 %h, i32 1
  ret <4 x i32> %c
}