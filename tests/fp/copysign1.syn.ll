; CHECK: call float @llvm.copysign.f32(float %x, float %y)
define float @fneg_mag(float %x, float %y) {
  %n = fneg float %x
  %r = call float @llvm.copysign.f32(float %n, float %y)
  ret float %r
}

declare float @llvm.copysign.f32(float, float)