; CHECK: shufflevector <4 x half> %a, <4 x half> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
define <4 x half> @syn_sv1(<4 x half> %a) {
entry:
  %ext.1 = extractelement <4 x half> %a, i32 0
  %ext.2 = extractelement <4 x half> %a, i32 1
  %ext.3 = extractelement <4 x half> %a, i32 2
  %ext.4 = extractelement <4 x half> %a, i32 3
  %ins.1 = insertelement <4 x half> undef,  half %ext.1, i32 3
  %ins.2 = insertelement <4 x half> %ins.1, half %ext.2, i32 2
  %ins.3 = insertelement <4 x half> %ins.2, half %ext.3, i32 1
  %ins.4 = insertelement <4 x half> %ins.3, half %ext.4, i32 0
  ret <4 x half> %ins.4
}