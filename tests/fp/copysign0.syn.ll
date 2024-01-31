; CHECK: call float @llvm.copysign.f32(float %x, float %y)
define float @fabs_mag(float %x, float %y) {
; CHECK-LABEL: @fabs_mag(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.copysign.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[R]]
;
  %a = call float @llvm.fabs.f32(float %x)
  %r = call float @llvm.copysign.f32(float %a, float %y)
  ret float %r
}

declare float @llvm.fabs.f32(float)
declare float @llvm.copysign.f32(float, float)