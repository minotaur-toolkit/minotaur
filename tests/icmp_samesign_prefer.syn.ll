; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (icmp_samesign_ult (var i64 %mx) (var i64 %my) b1)

define i1 @icmp_samesign_prefer(i64 %x, i64 %y) {
entry:
  %mx = and i64 %x, 1023
  %my = and i64 %y, 1023
  %diff = sub i64 %mx, %my
  %root = icmp slt i64 %diff, 0
  ret i1 %root
}
