; CHECK: call half @llvm.maximum.f16(half %x, half %y)
define half @reduce_precision(half %x, half %y) {
  %x.ext = fpext half %x to float
  %y.ext = fpext half %y to float
  %maximum = call float @llvm.maximum.f32(float %x.ext, float %y.ext)
  %trunc = fptrunc float %maximum to half
  ret half %trunc
}

declare float @llvm.maximum.f32(float, float)