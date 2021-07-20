; CHECK: add i4 %x, -3
define i4 @syn_add_1(i4 %x, i4 %y) {
  %ia = sub i4 %x, 7
  %ib = add i4 %ia, 4
  ret i4 %ib
}
