; CHECK: call half @llvm.minimum.f16(half 0xH0000, half %x)
define half @minimum_f16_1_minimum_p0_val(half %x) {
  %y = call half @llvm.minimum.f16(half 0.0, half %x)
  %z = call half @llvm.minimum.f16(half %y, half 1.0)
  ret half %z
}



declare half @llvm.minimum.f16(half %Val0, half %Val1)
