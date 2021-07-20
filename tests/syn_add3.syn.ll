; CHECK: add <2 x i4> %x, <i4 -4, i4 -5>
define <2 x i4> @syn_add_3(<2 x i4> %x, <2 x i4> %y) {
  %ia = sub <2 x i4> %x, <i4 7, i4 7>
  %ib = add <2 x i4> %ia,  <i4 3, i4 2>
  ret <2 x i4> %ib
}
