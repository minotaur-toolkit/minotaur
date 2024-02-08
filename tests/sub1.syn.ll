; CHECK: sub <4 x i8> %x, %y
define <4 x i8> @syn_add_3(<4 x i8> %x, <4 x i8> %y) {
  %a = and <4 x i8> %x, <i8 255, i8 0, i8 255, i8 0>
  %b = and <4 x i8> %y, <i8 255, i8 0, i8 255, i8 0>
  %sum1 = sub <4 x i8> %a, %b
  %c = and <4 x i8> %x, <i8 0, i8 255, i8 0, i8 255>
  %d = and <4 x i8> %y, <i8 0, i8 255, i8 0, i8 255>
  %sum2 = sub <4 x i8> %c, %d
  %sum = add <4 x i8> %sum1, %sum2
  ret <4 x i8> %sum
}
