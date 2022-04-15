; CHECK: shufflevector
define <3 x i16> @syn_sv2(<3 x i16> %a, <3 x i16> %b) {
entry:
  %ext.1 = extractelement <3 x i16> %a, i32 0
  %ext.2 = extractelement <3 x i16> %b, i32 1
  %ext.3 = extractelement <3 x i16> %b, i32 1
  %ins.1 = insertelement <3 x i16> poison,  i16 %ext.1, i32 1
  %ins.2 = insertelement <3 x i16> %ins.1, i16 %ext.2, i32 0
  %ins.3 = insertelement <3 x i16> %ins.2, i16 %ext.3, i32 2
  ret <3 x i16> %ins.3
}