; CHECK: zext i16 %x to i32
define i32 @test58(i16 %x) {
  %tobool = icmp ne i16 %x, 1
  %conv = zext i16 %x to i32
  %cond = select i1 %tobool, i32 %conv, i32 1
  ret i32 %cond
}