; CHECK: call float @llvm.fabs.f32
define float @square_fabs_shrink_call2(float %x) {
  %sq = fmul float %x, %x
  %ext = fpext float %sq to double
  %fabs = call double @llvm.fabs.f64(double %ext)
  %trunc = fptrunc double %fabs to float
  ret float %trunc
}

declare double @llvm.fabs.f64(double)