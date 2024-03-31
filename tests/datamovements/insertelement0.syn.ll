; CHECK: and <2 x i3> %x, <i3 -1, i3 0>
define <2 x i3> @extractelement_out_of_range(<2 x i3> %x, i32 %i) {
  %p = and <2 x i3> %x, <i3 7, i3 4>
  %q = and <2 x i3> %p, <i3 7, i3 1>
  ret <2 x i3> %q
}