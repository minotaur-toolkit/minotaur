; CHECK: [online] synthesized solution:
; CHECK: (fcmp_olt (var float %__n2) (reservedconst float |float 0x3FE1287900000000|) b1)
define i1 @src(float %0) {
  %t1 = fmul float %0, 0x3FF0CCCCC0000000
  %t2 = fcmp olt float %t1, 0x3FE20418A0000000
  ret i1 %t2
}
