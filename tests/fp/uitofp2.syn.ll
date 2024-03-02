; CHECK: uitofp i24 %i to double
define double @ItoFtoF_u24_f32_f128(i24 %i) {
  %x = uitofp i24 %i to float
  %r = fpext float %x to double
  ret double %r
}