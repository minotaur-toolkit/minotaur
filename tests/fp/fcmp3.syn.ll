; CHECK: [online] synthesized solution:
; CHECK: (fcmp_ogt (var double %__n2) (reservedconst double |double 0xC07AB00010000001|) b1)
define i1 @src(double %0) {
if.end155:
  %1 = fptrunc double %0 to float
  %2 = fcmp oge float %1, -4.270000e02
  ret i1 %2
}
