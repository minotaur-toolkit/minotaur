; ModuleID = 'convolve8_16_avx2.c'
source_filename = "convolve8_16_avx2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: mustprogress nofree nosync nounwind readonly uwtable willreturn
define dso_local <8 x i64> @interleaved_merge2(<4 x i64> %a, <4 x i64> %b) local_unnamed_addr #0 {
entry:
  %0 = bitcast <4 x i64> %a to <32 x i8>
  %1 = bitcast <4 x i64> %b to <32 x i8>
  %sv = shufflevector <32 x i8> %0, <32 x i8> %1,  <64 x i32> <i32 0, i32 32, i32 1, i32 33,i32 2, i32 34,i32 3, i32 35,i32 4, i32 36,i32 5, i32 37,i32 6, i32 38,i32 7, i32 39,i32 8, i32 40,i32 9, i32 41,i32 10, i32 42,i32 11, i32 43,i32 12, i32 44,i32 13, i32 45,i32 14, i32 46,i32 15, i32 47,i32 16, i32 48,i32 17, i32 49,i32 18, i32 50,i32 19, i32 51,i32 20, i32 52,i32 21, i32 53,i32 22, i32 54,i32 23, i32 55,i32 24, i32 56,i32 25, i32 57,i32 26, i32 58,i32 27, i32 59,i32 28, i32 60,i32 29, i32 61,i32 30, i32 62,i32 31, i32 63>
  %ret = bitcast <64 x i8> %sv to <8 x i64>
  ret <8 x i64> %ret
}


!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{!"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
