; CHECK: ret i1 true
define i1 @test39(i1 %cond, double %x) {
; CHECK-LABEL: @test39(
; CHECK-NEXT:    ret i1 true
;
  %s = select i1 %cond, double %x, double 0x7FF0000000000000 ; RHS = +infty
  %cmp = fcmp ule double %x, %s
  ret i1 %cmp
}