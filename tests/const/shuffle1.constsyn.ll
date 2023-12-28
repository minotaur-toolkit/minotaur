define <4 x i16> @src(<4 x i16> %a, <4 x i8> %_reservedc_113) {
entry:
  %ext.1 = extractelement <4 x i16> %a, i32 0
  %ext.2 = extractelement <4 x i16> %a, i32 1
  %ext.3 = extractelement <4 x i16> %a, i32 2
  %ext.4 = extractelement <4 x i16> %a, i32 3
  %ins.1 = insertelement <4 x i16> undef,  i16 %ext.1, i32 3
  %ins.2 = insertelement <4 x i16> %ins.1, i16 %ext.2, i32 2
  %ins.3 = insertelement <4 x i16> %ins.2, i16 %ext.3, i32 1
  %ins.4 = insertelement <4 x i16> %ins.3, i16 %ext.4, i32 0
  ret <4 x i16> %ins.4
}

define <4 x i16> @tgt(<4 x i16> %0, <4 x i8> %_reservedc_113) {
entry:
  %sv = call <4 x i16> @__fksv.700(<4 x i16> %0, <4 x i16> poison, <4 x i8> %_reservedc_113)
  ret <4 x i16> %sv

sink:                                             ; No predecessors!
  unreachable
}
declare <4 x i16> @__fksv.700(<4 x i16>, <4 x i16>, <4 x i8>)
