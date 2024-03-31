; CHECK:  insertelement <2 x half> <half 0xH7C00, half 0xHFFFF>, half %f, i16 1
define <2 x half> @extractelement_out_of_range(<2 x half> %x, half %f) {
  %b = insertelement <2 x half> poison, half %f, i32 1
  %c = insertelement <2 x half> %b, half 0xH7C00, i32 0
  ret <2 x half> %c
}