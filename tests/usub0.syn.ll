; CHECK: zeroinitializer
declare <2 x i8> @llvm.usub.sat.v2i8(<2 x i8>, <2 x i8>) #0

define <2 x i8> @test_vector_usub_overflow_y2(<2 x i8> %0) {
  %2 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %0, <2 x i8> <i8 100, i8 100>)
  %3 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %2, <2 x i8> <i8 -56, i8 -56>)
  ret <2 x i8> %3
}
