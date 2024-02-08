; CHECK: shufflevector <16 x i16> %0, <16 x i16> zeroinitializer
define <4 x i32> @xnn_f16_f32_vcvt_ukernel__scalar_x4_(<16 x i16> %0) {
vector.body:
  %1 = shufflevector <16 x i16> %0, <16 x i16> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = shl nuw <4 x i32> %2, <i32 16, i32 16, i32 16, i32 16>
  ret <4 x i32> %3

sink:                                             ; No predecessors!
  unreachable
}