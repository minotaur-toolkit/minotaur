; ModuleID = '/home/liuz/vsyn/vectorsyn/scratch/a.ll'
source_filename = "b.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

declare <8 x i16> @llvm.masked.gather.v8i16(<8 x i16*>, i32, <8 x i1>, <8 x i16>)

; Function Attrs: nofree norecurse nosync nounwind willreturn mustprogress
define dso_local void @hadamard_highbd_col8_first_pass(i16* nocapture readonly %0, i64 %1, i16* nocapture %2) local_unnamed_addr #0 {
  %ie = insertelement <1 x i64> poison, i64 %1, i32 0
  %sv = shufflevector <1 x i64> %ie, <1 x i64> poison, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %m = mul nsw <8 x i64> %sv, <i64 7, i64 1, i64 3, i64 5, i64 4, i64 0, i64 2, i64 6>
  %gep = getelementptr inbounds i16, i16* %0, <8 x i64> %m
  %gather = call <8 x i16> @llvm.masked.gather.v8i16(<8 x i16*> %gep,  i32 0, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)  
  %sv.1 = shufflevector <8 x i16> %gather, <8 x i16> poison, <8 x i32> <i32 7, i32 5, i32 6, i32 4, i32 3, i32 1, i32 2,i32 0>
  %4 = add <8 x i16> %gather, %sv.1
  %5 = sub <8 x i16> %gather, %sv.1
  %6 = shufflevector <8 x i16> %4, <8 x i16> %5, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
  %7 = shufflevector <8 x i16> %4, <8 x i16> %5, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12>
  %8 = add <8 x i16> %6, %7
  %9 = sub <8 x i16> %6, %7
  %10 = shufflevector <8 x i16> %8, <8 x i16> %9, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 12, i32 13, i32 6, i32 7>
  %11 = shufflevector <8 x i16> %9, <8 x i16> %8, <8 x i32> <i32 10, i32 3, i32 8, i32 1, i32 5, i32 4, i32 15, i32 14>
  %12 = add <8 x i16> %10, %11
  %13 = sub <8 x i16> %10, %11
  %14 = shufflevector <8 x i16> %12, <8 x i16> %13, <8 x i32> <i32 0, i32 9, i32 10, i32 3, i32 4, i32 13, i32 14, i32 7>
  %15 = bitcast i16* %2 to <8 x i16>*
  store <8 x i16> %14, <8 x i16>* %15, align 2, !tbaa !2
  ret void
}


!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"short", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
