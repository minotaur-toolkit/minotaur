; CHECK: call <2 x float> @llvm.maxnum.v2f32(<2 x float> %x, <2 x float> <float 1.000000e+00, float 1.000000e+00>)
define <2 x float> @maxnum_f32_1_maxnum_p0_val(<2 x float> %x) {
  %y = call <2 x float> @llvm.maxnum.v2f32(<2 x float> <float 0.0, float 1.0>, <2 x float> %x)
  %z = call <2 x float> @llvm.maxnum.v2f32(<2 x float> %y, <2 x float> <float 1.0, float 0.0>)
  ret <2 x float> %z
}



declare <2 x float> @llvm.maxnum.v2f32(<2 x float> %Val0, <2 x float> %Val1)
