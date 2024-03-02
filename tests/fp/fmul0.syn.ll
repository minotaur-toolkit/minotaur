define half @test2(half %x, half %y) nounwind  {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T56:%.*]] = fmul half [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret half [[T56]]
;
  %t1 = fpext half %x to float
  %t23 = fpext half %y to float
  %t5 = fmul float %t1, %t23
  %t56 = fptrunc float %t5 to half
  ret half %t56
}