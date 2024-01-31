; CHECK: call float @llvm.minimum.f32(float 0.000000e+00, float %x)
define float @minimum_f32_1_minimum_p0_val(float %x) {
  %y = call float @llvm.minimum.f32(float 0.0, float %x)
  %z = call float @llvm.minimum.f32(float %y, float 1.0)
  ret float %z
}

declare float @llvm.minimum.f32(float %Val0, float %Val1)
