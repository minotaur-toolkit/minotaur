; CHECK: changed
define <2 x i16> @syn_add_3(<2 x i16> %w, <2 x i16> %u) {
  %x = bitcast <2 x i16> %w to <4 x i8>
  %y = bitcast <2 x i16> %u to <4 x i8>
  %a = and <4 x i8> %x, <i8 255, i8 0, i8 255, i8 0>
  %b = and <4 x i8> %y, <i8 255, i8 0, i8 255, i8 0>
  %sum1 = add <4 x i8> %a, %b
  %c = and <4 x i8> %x, <i8 0, i8 255, i8 0, i8 255>
  %d = and <4 x i8> %y, <i8 0, i8 255, i8 0, i8 255>
  %sum2 = add <4 x i8> %c, %d
  %sum = add <4 x i8> %sum1, %sum2
  %ret = bitcast <4 x i8> %sum to <2 x i16>
  ret <2 x i16> %ret
}
