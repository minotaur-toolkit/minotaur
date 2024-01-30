; CHECK: <i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1>

; long duration test case

define <8 x i32> @sliced_(<16 x i16> %0) {
entry:
  %1 = call <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16> %0, <16 x i16> <i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1>)
  %2 = call <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16> %0, <16 x i16> <i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0>)
  %3 = sub nsw <8 x i32> %2, %1
  ret <8 x i32> %3
}

declare <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16>, <16 x i16>)