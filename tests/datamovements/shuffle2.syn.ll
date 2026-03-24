; CHECK: [online] minotaur completed, no change to the program
; CHECK: ret <4 x i16> %ins.4
define <4 x i16> @syn_sv1(<4 x i16> %a) {
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
