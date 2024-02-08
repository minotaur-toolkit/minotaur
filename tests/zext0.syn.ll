; CHECK: zext <2 x i8> %a to <2 x i16>
define <2 x i16> @syn_sv2(<2 x i8> %a) {
entry:
  %zx = zext <2 x i8> %a to <2 x i16>
  %and = and <2 x i16> %zx, <i16 255, i16 255>
  ret <2 x i16> %and
}