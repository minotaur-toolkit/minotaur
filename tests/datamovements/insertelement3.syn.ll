; CHECK: [online] synthesized solution:
; CHECK: (fneg <2 x half> (var <2 x half> %__n2))
; langref: If idx exceeds the length of val for a fixed-length vector, the result is a poison value.
define <2 x half> @extractelement_out_of_range(<2 x half> %x, i32 %i) {
  %b = insertelement <2 x half> %x, half 0xH7C00, i32 1
  %c = insertelement <2 x half> %b, half 0xH7C01, i32 4
  ret <2 x half> %c
}
