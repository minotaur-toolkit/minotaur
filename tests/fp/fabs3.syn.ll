; CHECK: ret float 0.000000e+00
define float @fabs_select_constant_neg0(i32 %c) {
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -0.0, float 0.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

declare float @llvm.fabs.f32(float)