; CHECK: call float @llvm.maxnum.f32(float %x, float 1.000000e+00)
define float @maxnum_f32_1_maxnum_p0_val(float %x) {
  %y = call float @llvm.maxnum.f32(float 0.0, float %x)
  %z = call float @llvm.maxnum.f32(float %y, float 1.0)
  ret float %z
}



declare float @llvm.maxnum.f32(float %Val0, float %Val1)
