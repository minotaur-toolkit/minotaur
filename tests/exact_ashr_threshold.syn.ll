; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (icmp_sgt (var i64 %x) (reservedconst i64 |i64 56|) b1)

define i1 @src(i64 %x) {
entry:
  %q = ashr exact i64 %x, 3
  %root = icmp sgt i64 %q, 7
  ret i1 %root
}
