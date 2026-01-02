; Expected (one possible model):
;   <2 x float> %_reservedc = < float 1.000000e+00, float poison >
;
; Lane 0 is constrained to 1.0, lane 1 is unconstrained (source is poison there),
; so the solver often chooses poison for that lane.
define <2 x float> @src(<2 x float> %_reservedc) {
entry:
  %v = insertelement <2 x float> poison, float 1.000000e+00, i32 0
  ret <2 x float> %v
}

define <2 x float> @tgt(<2 x float> %_reservedc) {
entry:
  ret <2 x float> %_reservedc
}


