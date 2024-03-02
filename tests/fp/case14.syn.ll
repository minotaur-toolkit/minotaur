; CHECK:  and i32 %1, -2147483648
define i32 @src(float %0) {
if.then83:
  %1 = tail call float @llvm.fabs.f32(float %0)
  %2 = bitcast float %0 to i32
  %3 = bitcast float %1 to i32
  %4 = xor i32 %3, %2
  ret i32 %4
}
declare float @llvm.fabs.f32(float)