; CHECK: call half @llvm.minnum.f16(half %x, half %y)
define half @reduce_precision(half %x, half %y) {
  %x.ext = fpext half %x to float
  %y.ext = fpext half %y to float
  %minnum = call float @llvm.minnum.f32(float %x.ext, float %y.ext)
  %trunc = fptrunc float %minnum to half
  ret half %trunc
}

declare float @llvm.minnum.f32(float, float)