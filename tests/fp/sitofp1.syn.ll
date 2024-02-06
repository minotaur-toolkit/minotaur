; CHECK: sitofp <2 x i23> %i to <2 x fp128>
define <2 x fp128> @ItoFtoF_u24_f32_f128(<2 x i23> %i) {
; CHECK-LABEL: @ItoFtoF_u24_f32_f128(
; CHECK-NEXT:    [[R:%.*]] = uitofp i24 [[I:%.*]] to fp128
; CHECK-NEXT:    ret fp128 [[R]]
;
  %x = sitofp <2 x i23> %i to <2 x float>
  %r = fpext <2 x float> %x to <2 x fp128>
  ret <2 x fp128> %r
}
