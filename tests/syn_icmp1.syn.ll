; CHECK: icmp eq i8 %x, 0
define i1 @syn_icmp_1(i8 %x) {
  %ia = zext i8 %x to i16
  %ib = icmp eq i16 0, %ia
  ret i1 %ib
}
