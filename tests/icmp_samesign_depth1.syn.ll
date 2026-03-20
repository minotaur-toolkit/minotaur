; CHECK: (icmp_samesign_ult

define i1 @icmp_samesign_depth1(i1 %c, i64 %x, i64 %y, i64 %z) {
entry:
  %root = icmp eq i64 %x, %y
  ret i1 %root
}
