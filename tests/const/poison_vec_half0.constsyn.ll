; Expected (one possible model):
;   <2 x half> %_reservedc = < half 0xH7C00, half poison >
;
; Lane 0 is constrained to +oo, lane 1 is unconstrained (source is poison there),
; so the solver often chooses poison for that lane.
define <2 x half> @src(<2 x half> %_reservedc) {
entry:
  %v = insertelement <2 x half> poison, half 0xH7C00, i32 0
  ret <2 x half> %v
}

define <2 x half> @tgt(<2 x half> %_reservedc) {
entry:
  ret <2 x half> %_reservedc
}


