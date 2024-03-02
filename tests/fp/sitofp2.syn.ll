; CHECK: sitofp i32 %i to double
define double @FtoItoFtoF_f32_s32_f32_f64(float %f) {
  %i = fptosi float %f to i32
  %x = sitofp i32 %i to float
  %r = fpext float %x to double
  ret double %r
}