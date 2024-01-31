; CHECK:  call <2 x float> @llvm.minimum.v2f32(<2 x float> %x, <2 x float> zeroinitializer)
define <2 x float> @minimum_f32_1_minimum_p0_val(<2 x float> %x) {
  %y = call <2 x float> @llvm.minimum.v2f32(<2 x float> <float 0.0, float 1.0>, <2 x float> %x)
  %z = call <2 x float> @llvm.minimum.v2f32(<2 x float> %y, <2 x float> <float 1.0, float 0.0>)
  ret <2 x float> %z
}



declare <2 x float> @llvm.minimum.v2f32(<2 x float> %Val0, <2 x float> %Val1)
