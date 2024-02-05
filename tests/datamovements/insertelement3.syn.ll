; CHECK:  ret <2 x half> %x
; TODO: fixme
define <2 x half> @extractelement_out_of_range(<2 x half> %x, i32 %i) {
  %b = insertelement <2 x half> %x, half 0xH7C00, i32 1
  %c = insertelement <2 x half> %b, half 0xH7C01, i32 4
  ret <2 x half> %c
}