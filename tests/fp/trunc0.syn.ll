; CHECK: [online] minotaur completed, no change to the program
; CHECK: @llvm.trunc.f64(double 1.500000e+00)
; CHECK: @llvm.trunc.f64(double -1.500000e+00)

define void @trunc(ptr %P) {
  %B = tail call double @llvm.trunc.f64(double 1.5) nounwind
  store volatile double %B, ptr %P
  %C = tail call double @llvm.trunc.f64(double -1.5) nounwind
  store volatile double %C, ptr %P
  ret void
}

declare double @llvm.trunc.f64(double %Val)
