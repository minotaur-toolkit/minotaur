; CHECK: fcmp olt float %1, %0
define i1 @src(float %0, float %1) {
if.then:
  %2 = fsub float %0, %1
  %3 = fcmp ogt float %2, 0.000000e+00
  ret i1 %3
}
