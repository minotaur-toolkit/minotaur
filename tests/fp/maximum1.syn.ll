; CHECK: call float @llvm.maximum.f32(float %x, float 1.000000e+00)
define float @maximum_f32_1_maximum_p0_val(float %x) {
  %y = call float @llvm.maximum.f32(float 0.0, float %x)
  %z = call float @llvm.maximum.f32(float %y, float 1.0)
  ret float %z
}

declare float @llvm.maximum.f32(float %Val0, float %Val1)
