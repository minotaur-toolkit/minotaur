; CHECK: call half @llvm.maximum.f16(half %x, half 0xH3C00)
define half @maximum_f16_1_maximum_p0_val(half %x) {
  %y = call half @llvm.maximum.f16(half 0.0, half %x)
  %z = call half @llvm.maximum.f16(half %y, half 1.0)
  ret half %z
}



declare half @llvm.maximum.f16(half %Val0, half %Val1)
