define float @src(float %_reservedc)  {
entry:
  %add1 = fmul float 0x7FF8000000000000, 0.000000e+00
  ret float %add1
}

define float @tgt(float %_reservedc)  {
entry:
  ret float %_reservedc
}
