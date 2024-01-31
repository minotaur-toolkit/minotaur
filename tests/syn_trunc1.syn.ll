; CHECK: trunc <3 x i16> %a to <3 x i8>
define <3 x i8> @syn_sv2(<3 x i16> %a) {
entry:
  %and = and <3 x i16> %a, <i16 255, i16 255, i16 255>
  %t = trunc <3 x i16> %and to <3 x i8>
  ret <3 x i8> %t
}