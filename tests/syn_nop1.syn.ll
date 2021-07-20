; CHECK: ret i4 %x
define i4 @syn_nop_1(i4 %x, i4 %y) {
  %ia = sub i4 %x, 7
  %ib = add i4 %ia, 7
  ret i4 %ib
}
