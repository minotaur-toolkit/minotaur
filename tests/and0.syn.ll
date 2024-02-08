; CHECK: and i32 %x, %y
define i32 @test41(i1 %cond, i32 %x, i32 %y) {
  %z = and i32 %x, %y
  %s = select i1 %cond, i32 %y, i32 %z
  %r = and i32 %x, %s
  ret i32 %r
}