; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (icmp_slt (var i8 %x) (reservedconst i8 |i8 0|) b1)

declare i8 @llvm.umax.i8(i8, i8)

define i1 @src(i8 %x) {
entry:
  %m = call i8 @llvm.umax.i8(i8 %x, i8 1)
  %n = xor i8 %x, -1
  %root = icmp ugt i8 %m, %n
  ret i1 %root
}
