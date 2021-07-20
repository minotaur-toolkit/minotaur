; CHECK: sub <4 x i64> <i64 -6, i64 -8, i64 -16, i64 -58>, %a
define <4 x i64> @syn_add_4(<4 x i64> %a, <4 x i64> %b, <4 x i64> %c) {
entry:
  %add.i = add <4 x i64> %a, <i64 3, i64 4, i64 8, i64 40>
  %x = add <4 x i64> %add.i, <i64 3, i64 4, i64 8, i64 18>
  %y = add <4 x i64> %x, <i64 3, i64 4, i64 8, i64 31>
  %z = sub <4 x i64> <i64 3, i64 4, i64 8, i64 31>, %y
  ret <4 x i64> %z
}
