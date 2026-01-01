; CHECK: (fcmp_ogt (var double %__n2) (reservedconst double |double 0x4062BFFFEFFFFFFF|) b1)
define i1 @src(double %0) {
if.end155:
  %1 = fptrunc double %0 to float
  %2 = fcmp oge float %1, 1.500000e+02
  ret i1 %2
}