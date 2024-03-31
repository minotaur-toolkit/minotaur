; CHECK: fcmp uno double %0, %1
define i1 @src(double %0, double %1, double %2, double %3, double %4, double %5, i1 %6, i1 %7, i8 %8) {
entry:
  %t1 = fcmp uno double %0, 0.000000e+00
  %t2 = fcmp uno double %1, 0.000000e+00
  %t3 = select i1 %t1, i1 true, i1 %t2
  ret i1 %t3
}