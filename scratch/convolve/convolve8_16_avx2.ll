; ModuleID = 'convolve8_16_avx2.c'
source_filename = "convolve8_16_avx2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: mustprogress nofree nosync nounwind readonly uwtable willreturn
define dso_local <4 x i64> @convolve8_16_avx2(<4 x i64>* nocapture readonly %s, <4 x i64>* nocapture readonly %f) local_unnamed_addr #0 {
entry:
  %0 = bitcast <4 x i64>* %s to <32 x i8>*
  %1 = load <32 x i8>, <32 x i8>* %0, align 32, !tbaa !3
  %2 = bitcast <4 x i64>* %f to <32 x i8>*
  %3 = load <32 x i8>, <32 x i8>* %2, align 32, !tbaa !3
  %4 = tail call <16 x i16> @llvm.x86.avx2.pmadd.ub.sw(<32 x i8> %1, <32 x i8> %3) #4
  %arrayidx3 = getelementptr inbounds <4 x i64>, <4 x i64>* %s, i64 1
  %5 = bitcast <4 x i64>* %arrayidx3 to <32 x i8>*
  %6 = load <32 x i8>, <32 x i8>* %5, align 32, !tbaa !3
  %arrayidx4 = getelementptr inbounds <4 x i64>, <4 x i64>* %f, i64 1
  %7 = bitcast <4 x i64>* %arrayidx4 to <32 x i8>*
  %8 = load <32 x i8>, <32 x i8>* %7, align 32, !tbaa !3
  %9 = tail call <16 x i16> @llvm.x86.avx2.pmadd.ub.sw(<32 x i8> %6, <32 x i8> %8) #4
  %arrayidx6 = getelementptr inbounds <4 x i64>, <4 x i64>* %s, i64 2
  %10 = bitcast <4 x i64>* %arrayidx6 to <32 x i8>*
  %11 = load <32 x i8>, <32 x i8>* %10, align 32, !tbaa !3
  %arrayidx7 = getelementptr inbounds <4 x i64>, <4 x i64>* %f, i64 2
  %12 = bitcast <4 x i64>* %arrayidx7 to <32 x i8>*
  %13 = load <32 x i8>, <32 x i8>* %12, align 32, !tbaa !3
  %14 = tail call <16 x i16> @llvm.x86.avx2.pmadd.ub.sw(<32 x i8> %11, <32 x i8> %13) #4
  %arrayidx9 = getelementptr inbounds <4 x i64>, <4 x i64>* %s, i64 3
  %15 = bitcast <4 x i64>* %arrayidx9 to <32 x i8>*
  %16 = load <32 x i8>, <32 x i8>* %15, align 32, !tbaa !3
  %arrayidx10 = getelementptr inbounds <4 x i64>, <4 x i64>* %f, i64 3
  %17 = bitcast <4 x i64>* %arrayidx10 to <32 x i8>*
  %18 = load <32 x i8>, <32 x i8>* %17, align 32, !tbaa !3
  %19 = tail call <16 x i16> @llvm.x86.avx2.pmadd.ub.sw(<32 x i8> %16, <32 x i8> %18) #4
  %add.i33 = add <16 x i16> %19, %9
  %add.i = add <16 x i16> %4, <i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64>
  %add.i34 = add <16 x i16> %add.i, %14
  %20 = tail call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> %add.i34, <16 x i16> %add.i33) #4
  %21 = ashr <16 x i16> %20, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  %22 = bitcast <16 x i16> %21 to <4 x i64>
  ret <4 x i64> %22
}

; Function Attrs: mustprogress nofree nosync nounwind readonly uwtable willreturn
define dso_local <4 x i64> @convolve8_16_avx2_opt(<4 x i64>* nocapture readonly %s, <4 x i64>* nocapture readonly %f) local_unnamed_addr #1 {
entry:
  %0 = bitcast <4 x i64>* %s to <64 x i8>*
  %1 = load <64 x i8>, <64 x i8>* %0, align 64, !tbaa !3
  %2 = bitcast <4 x i64>* %f to <64 x i8>*
  %3 = load <64 x i8>, <64 x i8>* %2, align 64, !tbaa !3
  %4 = tail call <32 x i16> @llvm.x86.avx512.pmaddubs.w.512(<64 x i8> %1, <64 x i8> %3) #4
  %5 = bitcast <32 x i16> %4 to <8 x i64>
  %arrayidx3 = getelementptr inbounds <4 x i64>, <4 x i64>* %s, i64 2
  %6 = bitcast <4 x i64>* %arrayidx3 to <64 x i8>*
  %7 = load <64 x i8>, <64 x i8>* %6, align 64, !tbaa !3
  %arrayidx4 = getelementptr inbounds <4 x i64>, <4 x i64>* %f, i64 2
  %8 = bitcast <4 x i64>* %arrayidx4 to <64 x i8>*
  %9 = load <64 x i8>, <64 x i8>* %8, align 64, !tbaa !3
  %10 = tail call <32 x i16> @llvm.x86.avx512.pmaddubs.w.512(<64 x i8> %7, <64 x i8> %9) #4
  %11 = bitcast <32 x i16> %10 to <8 x i64>
  %vecinit3.i = shufflevector <8 x i64> %5, <8 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %vecinit3.i61 = shufflevector <8 x i64> %5, <8 x i64> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %vecinit3.i65 = shufflevector <8 x i64> %11, <8 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %vecinit3.i69 = shufflevector <8 x i64> %11, <8 x i64> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %12 = bitcast <4 x i64> %vecinit3.i to <16 x i16>
  %13 = bitcast <4 x i64> %vecinit3.i65 to <16 x i16>
  %14 = bitcast <4 x i64> %vecinit3.i61 to <16 x i16>
  %15 = bitcast <4 x i64> %vecinit3.i69 to <16 x i16>
  %add.i70 = add <16 x i16> %15, %14
  %add.i = add <16 x i16> %12, <i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64, i16 64>
  %add.i71 = add <16 x i16> %add.i, %13
  %16 = tail call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> %add.i71, <16 x i16> %add.i70) #4
  %17 = ashr <16 x i16> %16, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  %18 = bitcast <16 x i16> %17 to <4 x i64>
  ret <4 x i64> %18
}

; Function Attrs: nofree nosync nounwind readnone
declare <16 x i16> @llvm.x86.avx2.pmadd.ub.sw(<32 x i8>, <32 x i8>) #2

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16>, <16 x i16>) #3

; Function Attrs: nofree nosync nounwind readnone
declare <32 x i16> @llvm.x86.avx512.pmaddubs.w.512(<64 x i8>, <64 x i8>) #2

attributes #0 = { mustprogress nofree nosync nounwind readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="256" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cascadelake" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl,+avx512vnni,+bmi,+bmi2,+clflushopt,+clwb,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsavec,+xsaveopt,+xsaves,-amx-bf16,-amx-int8,-amx-tile,-avx512bf16,-avx512bitalg,-avx512er,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vp2intersect,-avx512vpopcntdq,-avxvnni,-cldemote,-clzero,-enqcmd,-fma4,-gfni,-hreset,-kl,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-serialize,-sgx,-sha,-shstk,-sse4a,-tbm,-tsxldtrk,-uintr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop" }
attributes #1 = { mustprogress nofree nosync nounwind readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="512" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cascadelake" "target-features"="+64bit,+adx,+aes,+avx,+avx2,+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl,+avx512vnni,+bmi,+bmi2,+clflushopt,+clwb,+cmov,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsavec,+xsaveopt,+xsaves,-amx-bf16,-amx-int8,-amx-tile,-avx512bf16,-avx512bitalg,-avx512er,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vp2intersect,-avx512vpopcntdq,-avxvnni,-cldemote,-clzero,-enqcmd,-fma4,-gfni,-hreset,-kl,-lwp,-movdir64b,-movdiri,-mwaitx,-pconfig,-pku,-prefetchwt1,-ptwrite,-rdpid,-rtm,-serialize,-sgx,-sha,-shstk,-sse4a,-tbm,-tsxldtrk,-uintr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop" }
attributes #2 = { nofree nosync nounwind readnone }
attributes #3 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{!"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
