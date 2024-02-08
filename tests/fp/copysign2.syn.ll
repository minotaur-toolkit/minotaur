; CHECK: call float @llvm.copysign.f32(float 1.000000e+00, float %x)
define float @copysign1(float %x) {
  %i = bitcast float %x to i32
  %ispos = icmp sgt i32 %i, -1
  %r = select i1 %ispos, float 1.0, float -1.0
  ret float %r
}