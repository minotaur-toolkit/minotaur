; CHECK: ret <2 x i4> %x
define <2 x i4> @syn_nop_3(<2 x i4> %x, <2 x i4> %y) {
  %ia = sub <2 x i4> %x, <i4 7, i4 9>
  %ib = add <2 x i4> %ia,  <i4 7, i4 9>
  ret <2 x i4> %ib
}
