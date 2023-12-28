define i1 @src(i1 %_reservedc)  {
entry:
  %add1 = fcmp ole float 1.000000e+00, 0.000000e+00
  ret i1 %add1
}

define i1 @tgt(i1 %_reservedc)  {
entry:
  ret i1 %_reservedc
}
