define float @src(float %_reservedc)  {
entry:
  %add1 = fsub float 1.000000e+00, 0x7FF8000000000000
  ret float %add1
}

define float @tgt(float %_reservedc)  {
entry:
  ret float %_reservedc
}
