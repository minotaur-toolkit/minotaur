; CHECK: call half @llvm.minnum.f16(half 0xH0000, half %x)
define half @maximum_f16_1_minnum_p0_val(half %x) {
  %y = call half @llvm.minnum.f16(half 0.0, half %x)
  %z = call half @llvm.minnum.f16(half %y, half 1.0)
  ret half %z
}



declare half @llvm.minnum.f16(half %Val0, half %Val1)
