; CHECK: (xor i1 (var i1 %__n1) (reservedconst i1 |i1 true|))
define i1 @test5(i1 %C) {
  %V = select i1 %C, i1 false, i1 true
  ret i1 %V
}