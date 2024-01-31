; CHECK: call float @llvm.minnum.f32(float 0.000000e+00, float %x)
define float @minnum_f32_1_minnum_p0_val(float %x) {
  %y = call float @llvm.minnum.f32(float 0.0, float %x)
  %z = call float @llvm.minnum.f32(float %y, float 1.0)
  ret float %z
}



declare float @llvm.minnum.f32(float %Val0, float %Val1)
