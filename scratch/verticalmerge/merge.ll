; ModuleID = 'merge.c'
source_filename = "merge.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local <8 x i64> @interleaved_merge2(<4 x i64> %a, <4 x i64> %b) #0 {
entry:
  %__A.addr.i = alloca <4 x i64>, align 32
  %__a.addr.i3 = alloca <4 x i64>, align 32
  %__b.addr.i4 = alloca <4 x i64>, align 32
  %__a.addr.i = alloca <4 x i64>, align 32
  %__b.addr.i = alloca <4 x i64>, align 32
  %a.addr = alloca <4 x i64>, align 32
  %b.addr = alloca <4 x i64>, align 32
  %hi = alloca <4 x i64>, align 32
  %lo = alloca <4 x i64>, align 32
  %zmm_lo = alloca <8 x i64>, align 64
  %merge = alloca <8 x i64>, align 64
  store <4 x i64> %a, <4 x i64>* %a.addr, align 32
  store <4 x i64> %b, <4 x i64>* %b.addr, align 32
  %0 = load <4 x i64>, <4 x i64>* %a.addr, align 32
  %1 = load <4 x i64>, <4 x i64>* %b.addr, align 32
  store <4 x i64> %0, <4 x i64>* %__a.addr.i, align 32
  store <4 x i64> %1, <4 x i64>* %__b.addr.i, align 32
  %2 = load <4 x i64>, <4 x i64>* %__a.addr.i, align 32
  %3 = bitcast <4 x i64> %2 to <32 x i8>
  %4 = load <4 x i64>, <4 x i64>* %__b.addr.i, align 32
  %5 = bitcast <4 x i64> %4 to <32 x i8>
  %shuffle.i = shufflevector <32 x i8> %3, <32 x i8> %5, <32 x i32> <i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>
  %6 = bitcast <32 x i8> %shuffle.i to <4 x i64>
  store <4 x i64> %6, <4 x i64>* %hi, align 32
  %7 = load <4 x i64>, <4 x i64>* %a.addr, align 32
  %8 = load <4 x i64>, <4 x i64>* %b.addr, align 32
  store <4 x i64> %7, <4 x i64>* %__a.addr.i3, align 32
  store <4 x i64> %8, <4 x i64>* %__b.addr.i4, align 32
  %9 = load <4 x i64>, <4 x i64>* %__a.addr.i3, align 32
  %10 = bitcast <4 x i64> %9 to <32 x i8>
  %11 = load <4 x i64>, <4 x i64>* %__b.addr.i4, align 32
  %12 = bitcast <4 x i64> %11 to <32 x i8>
  %shuffle.i5 = shufflevector <32 x i8> %10, <32 x i8> %12, <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55>
  %13 = bitcast <32 x i8> %shuffle.i5 to <4 x i64>
  store <4 x i64> %13, <4 x i64>* %lo, align 32
  %14 = load <4 x i64>, <4 x i64>* %lo, align 32
  store <4 x i64> %14, <4 x i64>* %__A.addr.i, align 32
  %15 = load <4 x i64>, <4 x i64>* %__A.addr.i, align 32
  %16 = load <4 x i64>, <4 x i64>* %__A.addr.i, align 32
  %shuffle.i6 = shufflevector <4 x i64> %15, <4 x i64> %16, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
  store <8 x i64> %shuffle.i6, <8 x i64>* %zmm_lo, align 64
  %17 = load <8 x i64>, <8 x i64>* %zmm_lo, align 64
  %18 = load <4 x i64>, <4 x i64>* %hi, align 32
  %widen = shufflevector <4 x i64> %18, <4 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %insert = shufflevector <8 x i64> %17, <8 x i64> %widen, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11>
  store <8 x i64> %insert, <8 x i64>* %merge, align 64
  %19 = load <8 x i64>, <8 x i64>* %merge, align 64
  ret <8 x i64> %19
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="512" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cascadelake" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl,+avx512vnni,+bmi,+bmi2,+clflushopt,+clwb,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsavec,+xsaveopt,+xsaves,-amx-bf16,-amx-int8,-amx-tile,-avx512bf16,-avx512bitalg,-avx512er,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vp2intersect,-avx512vpopcntdq,-avxvnni,-cldemote,-clzero,-enqcmd,-fma4,-gfni,-hreset,-kl,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-serialize,-sgx,-sha,-shstk,-sse4a,-tbm,-tsxldtrk,-uintr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"}
