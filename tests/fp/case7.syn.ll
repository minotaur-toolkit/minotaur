; CHECK: select i1 %0, float 1.000000e+00, float -1.000000e+00
define float @src(i1 %0) {
if.else285:
  %t2 = select i1 %0, float -1.000000e+00, float 1.000000e+00
  %t3 = fneg float %t2
  ret float %t3
}