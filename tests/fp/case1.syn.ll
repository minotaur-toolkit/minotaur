; CHECK: rewrite: (var <1 x float> %1)
define float @src(float %0) {
entry:
  %1 = fmul float %0, 0.000000e+00
  %2 = fmul float %1, 3.000000e+00
  ret float %2
}