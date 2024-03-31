; CHECK: insertelement <2 x half> %x, half %f, i16 1
define <2 x half> @extractelement_out_of_range(<2 x half> %x, half %f) {
  %b = insertelement <2 x half> %x, half 0xH7C00, i32 1
  %c = insertelement <2 x half> %b, half %f, i32 1
  ret <2 x half> %c
}