; CHECK: ret float %sq
define float @square_fabs_shrink_call2(float %x) {
; CHECK-LABEL: @square_fabs_shrink_call2(
; CHECK-NEXT:    [[SQ:%.*]] = fmul float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.fabs.f32(float [[SQ]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %sq = fmul float %x, %x
  %ext = fpext float %sq to double
  %fabs = call double @llvm.fabs.f64(double %ext)
  %trunc = fptrunc double %fabs to float
  ret float %trunc
}

declare double @llvm.fabs.f64(double)