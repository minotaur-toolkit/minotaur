; ModuleID = '/home/liuz/vsyn/vectorsyn/scratch/a.ll'
source_filename = "hadamard_highbd_col8_first_pass.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind willreturn mustprogress
define dso_local void @hadamard_highbd_col8_first_pass(i16* nocapture readonly %0, i64 %1, i16* nocapture %2) local_unnamed_addr #0 {
  %4 = load i16, i16* %0, align 2, !tbaa !2
  %5 = getelementptr inbounds i16, i16* %0, i64 %1
  %6 = load i16, i16* %5, align 2, !tbaa !2
  %7 = shl nsw i64 %1, 1
  %8 = getelementptr inbounds i16, i16* %0, i64 %7
  %9 = load i16, i16* %8, align 2, !tbaa !2
  %10 = mul nsw i64 %1, 3
  %11 = getelementptr inbounds i16, i16* %0, i64 %10
  %12 = load i16, i16* %11, align 2, !tbaa !2
  %13 = shl nsw i64 %1, 2
  %14 = getelementptr inbounds i16, i16* %0, i64 %13
  %15 = load i16, i16* %14, align 2, !tbaa !2
  %16 = mul nsw i64 %1, 5
  %17 = getelementptr inbounds i16, i16* %0, i64 %16
  %18 = load i16, i16* %17, align 2, !tbaa !2
  %19 = mul nsw i64 %1, 6
  %20 = getelementptr inbounds i16, i16* %0, i64 %19
  %21 = load i16, i16* %20, align 2, !tbaa !2
  %22 = mul nsw i64 %1, 7
  %23 = getelementptr inbounds i16, i16* %0, i64 %22
  %24 = load i16, i16* %23, align 2, !tbaa !2
  %25 = insertelement <8 x i16> poison, i16 %24, i32 0
  %26 = insertelement <8 x i16> %25, i16 %6, i32 1
  %27 = insertelement <8 x i16> %26, i16 %12, i32 2
  %28 = insertelement <8 x i16> %27, i16 %18, i32 3
  %29 = insertelement <8 x i16> %28, i16 %15, i32 4
  %30 = insertelement <8 x i16> %29, i16 %4, i32 5
  %31 = insertelement <8 x i16> %30, i16 %9, i32 6
  %32 = insertelement <8 x i16> %31, i16 %21, i32 7
  %33 = insertelement <8 x i16> poison, i16 %21, i32 0
  %34 = insertelement <8 x i16> %33, i16 %4, i32 1
  %35 = insertelement <8 x i16> %34, i16 %9, i32 2
  %36 = insertelement <8 x i16> %35, i16 %15, i32 3
  %37 = insertelement <8 x i16> %36, i16 %18, i32 4
  %38 = insertelement <8 x i16> %37, i16 %6, i32 5
  %39 = insertelement <8 x i16> %38, i16 %12, i32 6
  %40 = insertelement <8 x i16> %39, i16 %24, i32 7
  %41 = add <8 x i16> %32, %40
  %42 = sub <8 x i16> %32, %40
  %43 = shufflevector <8 x i16> %41, <8 x i16> %42, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
  %44 = shufflevector <8 x i16> %41, <8 x i16> %42, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12>
  %45 = add <8 x i16> %43, %44
  %46 = sub <8 x i16> %43, %44
  %47 = shufflevector <8 x i16> %45, <8 x i16> %46, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 12, i32 13, i32 6, i32 7>
  %48 = shufflevector <8 x i16> %46, <8 x i16> %45, <8 x i32> <i32 10, i32 3, i32 8, i32 1, i32 5, i32 4, i32 15, i32 14>
  %49 = add <8 x i16> %47, %48
  %50 = sub <8 x i16> %47, %48
  %51 = shufflevector <8 x i16> %49, <8 x i16> %50, <8 x i32> <i32 0, i32 9, i32 10, i32 3, i32 4, i32 13, i32 14, i32 7>
  %52 = bitcast i16* %2 to <8 x i16>*
  store <8 x i16> %51, <8 x i16>* %52, align 2, !tbaa !2
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind willreturn mustprogress "target-cpu"="skx" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"short", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
