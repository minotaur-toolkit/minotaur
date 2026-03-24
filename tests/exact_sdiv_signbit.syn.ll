; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (icmp_slt (var i64 %x) (reservedconst i64 |i64 0|) b1)

define i1 @src(i64 %x) {
entry:
  %q = sdiv exact i64 %x, 24
  %root = icmp ugt i64 %q, 4611686018427387903
  ret i1 %root
}
