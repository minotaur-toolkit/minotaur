; CHECK: ret <4 x i64> %a
define <4 x i64> @syn_add_4(<4 x i64> %a) {
entry:
  %ext.1 = extractelement <4 x i64> %a, i32 0
  %ext.2 = extractelement <4 x i64> %a, i32 1
  %ext.3 = extractelement <4 x i64> %a, i32 2 
  %ext.4 = extractelement <4 x i64> %a, i32 3 
  %ins.1 = insertelement <4 x i64> undef,  i64 %ext.1, i32 0
  %ins.2 = insertelement <4 x i64> %ins.1, i64 %ext.2, i32 1
  %ins.3 = insertelement <4 x i64> %ins.2, i64 %ext.3, i32 2 
  %ins.4 = insertelement <4 x i64> %ins.3, i64 %ext.4, i32 3 
  ret <4 x i64> %ins.4
}
