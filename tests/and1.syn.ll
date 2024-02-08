; CHECK: and i32 %x, %y
define i32 @test59(i32 %x, i32 %y) {
  %and = and i32 %x, %y
  %tobool = icmp ne i32 %x, %y
  %.and = select i1 %tobool, i32 %and, i32 %y
  ret i32 %.and
}