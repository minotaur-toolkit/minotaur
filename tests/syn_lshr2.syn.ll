; CHECK: (lshr <16 x i16> (var <16 x i16> %__n2) (reservedconst <16 x i16> |<16 x i16> splat (i16 4)|))
define <16 x i16> @syn_ashr_1(<16 x i16> %x, <16 x i16> %y) {
  %ia = udiv <16 x i16> %x, <i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4>
  %ib = udiv <16 x i16> %ia, <i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4>
  ret <16 x i16> %ib
}
