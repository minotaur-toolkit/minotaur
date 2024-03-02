; CHECK: fpext half %a to float
define float @test8(half %a) nounwind {
  %y = fpext half %a to double
  %z = fptrunc double %y to float
  ret float %z
}