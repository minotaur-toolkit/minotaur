; CHECK: ret i32 %x
define i32 @test33(i32 %x, i32 %y) {
  %cmp = icmp sgt i32 %x, %y
  %cond = select i1 %cmp, i32 %y, i32 %x
  %cmp5 = icmp sgt i32 %cond, %x
  %retval = select i1 %cmp5, i32 %cond, i32 %x
  ret i32 %retval
}