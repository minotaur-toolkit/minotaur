; CHECK: fadd half %a, %b
declare half    @llvm.minimum.f16(half %Val0, half %Val1)
declare half    @llvm.maximum.f16(half %Val0, half %Val1)

define half @test(half %a, half %b) {
entry:
  %min = call half @llvm.minimum.f16(half %a, half %b)
  %max = call half @llvm.maximum.f16(half %a, half %b)
  %res = fadd half %min, %max
  ret half %res
}
