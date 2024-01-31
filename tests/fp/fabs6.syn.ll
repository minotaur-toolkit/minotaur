; CHECK: select i1 %cmp, double 1.000000e+00, double 2.000000e+00
define double @fabs_select_constant_negative_negative(i32 %c) {
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, double -1.0, double -2.0
  %fabs = call double @llvm.fabs.f64(double %select)
  ret double %fabs
}

declare double @llvm.fabs.f64(double)