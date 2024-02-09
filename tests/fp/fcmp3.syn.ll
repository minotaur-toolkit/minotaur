; CHECK: fcmp oge double %0, 0xC07AB00010000000
define i1 @src(double %0) {
if.end155:
  %1 = fptrunc double %0 to float
  %2 = fcmp oge float %1, -4.270000e02
  ret i1 %2

sink:                                             ; No predecessors!
  unreachable
}