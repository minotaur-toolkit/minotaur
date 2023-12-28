; CHECK: shufflevector
define <2 x i16> @syn_sv3(<2 x i16> %a, <2 x i16> %b) {
entry:
  %ext.1 = extractelement <2 x i16> %a, i32 0
  %ext.2 = extractelement <2 x i16> %b, i32 1
  %ins.1 = insertelement <2 x i16> undef,  i16 %ext.1, i32 1
  %ins.2 = insertelement <2 x i16> %ins.1, i16 %ext.2, i32 0
  ret <2 x i16> %ins.2
}

