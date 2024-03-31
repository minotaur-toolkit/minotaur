; CHECK: and <2 x i8> %x, <i8 -1, i8 0>
; was expecting insertelement <2 x i8> %x, i8 0, i8 1
define <2 x i8> @extractelement_out_of_range(<2 x i8> %x, i32 %i) {
  %p = and <2 x i8> %x, <i8 255, i8 15>
  %q = and <2 x i8> %p, <i8 255, i8 240>
  ret <2 x i8> %q
}