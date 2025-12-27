; CHECK: (fcmp_ogt (var double %__n3) (reservedconst double |double 0x405FFFFFFFFFFFFF|) b1)
declare double @llvm.floor.f64(double)

define i1 @src(double %0, i1 %1) {
  %t2 = fmul double %0, 7.812500e-03
  %t3 = call double @llvm.floor.f64(double %t2)
  %t4 = fcmp ogt double %t3, 0.000000e+00
  ret i1 %t4

}