; CHECK: add i233 %x, -3
define i233 @syn_add_2(i233 %x, i233 %y) {
  %ia = sub i233 %x, 7
  %ib = add i233 %ia, 4
  ret i233 %ib
}
