; CHECK:  insertelement <2 x half> <half 0xHFFFF, half 0xH7C00>, half %f, i16 0
define <2 x half> @extractelement_out_of_range(<2 x half> %x, half %f) {
  %b = insertelement <2 x half> undef, half %f, i32 0
  %c = insertelement <2 x half> %b, half 0xH7C00, i32 1
  ret <2 x half> %c
}