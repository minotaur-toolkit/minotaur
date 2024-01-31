; CHECK: ret float %mul
define float @square_nnan_fabs_intrinsic_f32(float %x) {
  %mul = fmul nnan float %x, %x
  %fabsf = call float @llvm.fabs.f32(float %mul)
  ret float %fabsf
}

declare float @llvm.fabs.f32(float)