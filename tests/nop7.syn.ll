; CHECK: ret i32 %x
define i32 @test34(i32 %x, i32 %y) {
  %cmp = icmp sgt i32 %x, %y
  %cond = select i1 %cmp, i32 %x, i32 %y
  %cmp5 = icmp sgt i32 %cond, %x
  %retval = select i1 %cmp5, i32 %x, i32 %cond
  ret i32 %retval
}