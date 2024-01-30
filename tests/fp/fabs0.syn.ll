; CHECK: call float @llvm.fabs.f32(float %x)
define float @select_fneg(i1 %c, float %x) {
  %n = fneg float %x
  %s = select i1 %c, float %n, float %x
  %fabs = call float @llvm.fabs.f32(float %s)
  ret float %fabs
}

declare float @llvm.fabs.f32(float)