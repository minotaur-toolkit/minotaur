; CHECK: zext i1 %C to i32
define i32 @test6(i1 %C) {
  %V = select i1 %C, i32 1, i32 0
  ret i32 %V
}