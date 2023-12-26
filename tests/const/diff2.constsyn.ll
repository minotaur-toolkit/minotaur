define <8 x i32> @src(<16 x i16> %0, <16 x i16> %_reservedc) {
entry:
    %1 = bitcast <16 x i16> %0 to <8 x i32>
    %2 = call <8 x i32> @llvm.x86.avx2.psrai.d(<8 x i32> %1, i32 16)
    %3 = call <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16> %0, <16 x i16> <i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0>)
    %4 = sub nsw <8 x i32> %3, %2
    ret <8 x i32> %4
}

define <8 x i32> @tgt(<16 x i16> %0, <16 x i16> %_reservedc) {
entry:
    %intr = call <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16> %0, <16 x i16> %_reservedc)
    ret <8 x i32> %intr
}


declare <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.psrai.d(<8 x i32>, i32)
