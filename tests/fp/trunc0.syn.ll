; CHECK: store volatile double 1.000000e+00, ptr %P, align 8
; CHECK-NEXT: store volatile double -1.000000e+00, ptr %P, align 8

define void @trunc(ptr %P) {
  %B = tail call double @llvm.trunc.f64(double 1.5) nounwind
  store volatile double %B, ptr %P
  %C = tail call double @llvm.trunc.f64(double -1.5) nounwind
  store volatile double %C, ptr %P
  ret void
}

declare double @llvm.trunc.f64(double %Val)