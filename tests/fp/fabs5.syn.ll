; CHECK: select i1 %cmp, float 1.000000e+00, float 2.000000e+00
define float @fabs_select_constant_negative_negative(i32 %c) {
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -1.0, float -2.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

declare float @llvm.fabs.f32(float)