; CHECK: fcmp oge double %0, %1
define i1 @auto_gen_8_retval(double %0, double %1) {
  %3 = fcmp oge double %0, %1
  %4 = fcmp ogt double %0, %1
  %5 = or i1 %3, %4
  ret i1 %5
}
