; CHECK: zext i16 %x to i32
define i32 @test56(i16 %x) {
  %tobool = icmp eq i16 %x, 0
  %conv = zext i16 %x to i32
  %cond = select i1 %tobool, i32 0, i32 %conv
  ret i32 %cond
}
