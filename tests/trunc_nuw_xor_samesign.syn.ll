; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (icmp_samesign_ult (var i8 %x) (reservedconst i8 |i8 1|) b1)

define i1 @src(i8 %x) {
entry:
  %b = trunc nuw i8 %x to i1
  %root = xor i1 %b, true
  ret i1 %root
}
