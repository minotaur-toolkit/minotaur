define <4 x float> @src(<4 x float> %a, <4 x i8> %_reservedc_113) {
entry:
  %ext.1 = extractelement <4 x float> %a, i32 0
  %ext.2 = extractelement <4 x float> %a, i32 1
  %ext.3 = extractelement <4 x float> %a, i32 2
  %ext.4 = extractelement <4 x float> %a, i32 3
  %ins.1 = insertelement <4 x float> undef,  float %ext.1, i32 3
  %ins.2 = insertelement <4 x float> %ins.1, float %ext.2, i32 2
  %ins.3 = insertelement <4 x float> %ins.2, float %ext.3, i32 1
  %ins.4 = insertelement <4 x float> %ins.3, float %ext.4, i32 0
  ret <4 x float> %ins.4
}

define <4 x float> @tgt(<4 x float> %0, <4 x i8> %_reservedc_113) {
entry:
  %sv = call <4 x float> @__fksv.700(<4 x float> %0, <4 x float> poison, <4 x i8> %_reservedc_113)
  ret <4 x float> %sv

sink:                                             ; No predecessors!
  unreachable
}
declare <4 x float> @__fksv.700(<4 x float>, <4 x float>, <4 x i8>)
