; CHECK: call half @llvm.maxnum.f16(half %x, half %y)
define half @reduce_precision(half %x, half %y) {
  %x.ext = fpext half %x to float
  %y.ext = fpext half %y to float
  %maxnum = call float @llvm.maxnum.f32(float %x.ext, float %y.ext)
  %trunc = fptrunc float %maxnum to half
  ret half %trunc
}

declare float @llvm.maxnum.f32(float, float)