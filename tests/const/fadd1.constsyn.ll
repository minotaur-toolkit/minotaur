define float @src(float %_reservedc)  {
entry:
  %add1 = fadd float 1.000000e+00, 1.000000e+00
  ret float %add1
}

define float @tgt(float %_reservedc)  {
entry:
  ret float %_reservedc
}
