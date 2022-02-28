; CHECK: add <2 x i8> %x, <i8 -4, i8 -5>
define <2 x i8> @syn_add_3(<2 x i8> %x, <2 x i8> %y) {
  %ia = sub <2 x i8> %x, <i8 7, i8 7>
  %ib = add <2 x i8> %ia,  <i8 3, i8 2>
  ret <2 x i8> %ib
}
