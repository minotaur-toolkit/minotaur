; CHECK: xor i1 %t5, %t7
define i1 @src(float %0, float %1, i1 %2, i1 %3, i1 %4) {
  %t5 = fcmp ult float %0, 0.000000e+00
  %t6 = select i1 %t5, float -1.000000e+00, float 1.000000e+00
  %t7 = fcmp ult float %1, 0.000000e+00
  %t8 = select i1 %t7, float -1.000000e+00, float 1.000000e+00
  %t9 = fcmp une float %t6, %t8
  ret i1 %t9
}
