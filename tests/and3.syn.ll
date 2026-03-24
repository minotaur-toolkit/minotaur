; CHECK: [online] minotaur completed, no change to the program
; CHECK: %2 = zext <4 x i16> %1 to <4 x i32>
define <4 x i32> @xnn_f16_f32_vcvt_ukernel__scalar_x2_(<8 x i16> %0) {
vector.body:
  %1 = shufflevector <8 x i16> %0, <8 x i16> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %2 = zext <4 x i16> %1 to <4 x i32>
  ret <4 x i32> %2

sink:                                             ; No predecessors!
  unreachable
}
