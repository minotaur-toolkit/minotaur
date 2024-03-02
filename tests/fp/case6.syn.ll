; CHECK: fcmp oeq float %0, 0.000000e+00
define i1 @src(float %0) {
if.end192:
  %1 = fcmp oge float %0, 0.000000e+00
  %2 = fneg float %0
  %3 = select i1 %1, float %0, float %2
  %4 = fcmp oeq float %3, 0.000000e+00
  ret i1 %4
}

