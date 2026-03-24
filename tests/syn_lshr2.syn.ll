; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (lshr <2 x i8> (var <2 x i8> %x) (reservedconst <2 x i8> |<2 x i8> splat (i8 4)|))

define <2 x i8> @src(<2 x i8> %x) {
entry:
  %a = udiv <2 x i8> %x, <i8 4, i8 4>
  %root = udiv <2 x i8> %a, <i8 4, i8 4>
  ret <2 x i8> %root
}
