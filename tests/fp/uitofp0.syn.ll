; CHECK: uitofp i24 %i to fp128
define fp128 @ItoFtoF_u24_f32_f128(i24 %i) {
; CHECK-LABEL: @ItoFtoF_u24_f32_f128(
; CHECK-NEXT:    [[R:%.*]] = uitofp i24 [[I:%.*]] to fp128
; CHECK-NEXT:    ret fp128 [[R]]
;
  %x = uitofp i24 %i to float
  %r = fpext float %x to fp128
  ret fp128 %r
}
