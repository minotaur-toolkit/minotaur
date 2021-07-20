; ModuleID = 'b.c'
source_filename = "hadamard_highbd_col8_first_pass.c.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nounwind uwtable
define dso_local void @hadamard_highbd_col8_first_pass(i16* nocapture readonly %0, i64 %1, i16* nocapture %2) local_unnamed_addr #0 {
  %4 = load i16, i16* %0, align 2, !tbaa !2
  %5 = getelementptr inbounds i16, i16* %0, i64 %1
  %6 = load i16, i16* %5, align 2, !tbaa !2
  %7 = add i16 %6, %4
  %8 = sub i16 %4, %6
  %9 = shl nsw i64 %1, 1
  %10 = getelementptr inbounds i16, i16* %0, i64 %9
  %11 = load i16, i16* %10, align 2, !tbaa !2
  %12 = mul nsw i64 %1, 3
  %13 = getelementptr inbounds i16, i16* %0, i64 %12
  %14 = load i16, i16* %13, align 2, !tbaa !2
  %15 = add i16 %14, %11
  %16 = sub i16 %11, %14
  %17 = shl nsw i64 %1, 2
  %18 = getelementptr inbounds i16, i16* %0, i64 %17
  %19 = load i16, i16* %18, align 2, !tbaa !2
  %20 = mul nsw i64 %1, 5
  %21 = getelementptr inbounds i16, i16* %0, i64 %20
  %22 = load i16, i16* %21, align 2, !tbaa !2
  %23 = add i16 %22, %19
  %24 = sub i16 %19, %22
  %25 = mul nsw i64 %1, 6
  %26 = getelementptr inbounds i16, i16* %0, i64 %25
  %27 = load i16, i16* %26, align 2, !tbaa !2
  %28 = mul nsw i64 %1, 7
  %29 = getelementptr inbounds i16, i16* %0, i64 %28
  %30 = load i16, i16* %29, align 2, !tbaa !2
  %31 = add i16 %30, %27
  %32 = sub i16 %27, %30
  %33 = add i16 %15, %7
  %34 = add i16 %16, %8
  %35 = sub i16 %7, %15
  %36 = sub i16 %8, %16
  %37 = add i16 %31, %23
  %38 = add i16 %32, %24
  %39 = sub i16 %23, %31
  %40 = sub i16 %24, %32
  %41 = add i16 %37, %33
  store i16 %41, i16* %2, align 2, !tbaa !2
  %42 = add i16 %38, %34
  %43 = getelementptr inbounds i16, i16* %2, i64 7
  store i16 %42, i16* %43, align 2, !tbaa !2
  %44 = add i16 %39, %35
  %45 = getelementptr inbounds i16, i16* %2, i64 3
  store i16 %44, i16* %45, align 2, !tbaa !2
  %46 = add i16 %40, %36
  %47 = getelementptr inbounds i16, i16* %2, i64 4
  store i16 %46, i16* %47, align 2, !tbaa !2
  %48 = sub i16 %33, %37
  %49 = getelementptr inbounds i16, i16* %2, i64 2
  store i16 %48, i16* %49, align 2, !tbaa !2
  %50 = sub i16 %34, %38
  %51 = getelementptr inbounds i16, i16* %2, i64 6
  store i16 %50, i16* %51, align 2, !tbaa !2
  %52 = sub i16 %35, %39
  %53 = getelementptr inbounds i16, i16* %2, i64 1
  store i16 %52, i16* %53, align 2, !tbaa !2
  %54 = sub i16 %36, %40
  %55 = getelementptr inbounds i16, i16* %2, i64 5
  store i16 %54, i16* %55, align 2, !tbaa !2
  ret void
}

;attributes #0 = { nofree norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"short", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
