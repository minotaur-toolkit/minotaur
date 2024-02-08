; CHECK: ret i233 %x
define i233 @syn_nop_2(i233 %x, i233 %y) {
  %ia = sub i233 %x, 7
  %ib = add i233 %ia, 7
  ret i233 %ib
}
