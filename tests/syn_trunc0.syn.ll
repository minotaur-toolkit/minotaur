; CHECK: trunc <2 x i16> %a to <2 x i8>
define <2 x i8> @syn_sv2(<2 x i16> %a) {
entry:
  %and = and <2 x i16> %a, <i16 255, i16 255>
  %t = trunc <2 x i16> %and to <2 x i8>
  ret <2 x i8> %t
}