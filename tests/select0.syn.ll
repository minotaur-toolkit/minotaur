; CHECK: select i1 %cmp, i32 1, i32 6
define i32 @test52(i32 %n, i32 %m) {
  %cmp = icmp sgt i32 %n, %m
  %. = select i1 %cmp, i32 1, i32 3
  %add = add nsw i32 %., 3
  %storemerge = select i1 %cmp, i32 %., i32 %add
  ret i32 %storemerge
}