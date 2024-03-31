; CHECK: fcmp ogt half %0, %1
define i1 @src(half %0, half %1) {
if.then:
  %2 = fsub half %0, %1
  %3 = fcmp ogt half %2, 0.000000e+00
  ret i1 %3
}
