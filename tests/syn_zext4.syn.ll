; CHECK: zext <3 x i8> %a to <3 x i16>
define <3 x i16> @syn_sv2(<3 x i8> %a) {
entry:
  %zx = sext <3 x i8> %a to <3 x i16>
  %and = and <3 x i16> %zx, <i16 255, i16 255, i16 255>
  ret <3 x i16> %and
}