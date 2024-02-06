; CHECK: fsub float -0.000000e+00, %x
define float @test4(float %x) nounwind  {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[T34:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    ret float [[T34]]
;
  %t1 = fpext float %x to double
  %t2 = fsub double -0.000000e+00, %t1
  %t34 = fptrunc double %t2 to float
  ret float %t34
}