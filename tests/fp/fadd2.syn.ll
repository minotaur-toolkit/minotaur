; CHECK: fadd float %x, 0.000000e+00
define float @test(float %x) nounwind  {
  %t1 = fpext float %x to double
  %t3 = fadd double %t1, 0.000000e+00
  %t34 = fptrunc double %t3 to float
  ret float %t34
}