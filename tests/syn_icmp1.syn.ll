; CHECK: successfully
define i1 @syn_icmp_1(i4 %x) {
  %ia = zext i4 %x to i16
  %ib = icmp eq i16 0, %ia
  ret i1 %ib
}
