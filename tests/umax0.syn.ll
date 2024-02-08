; CHECK: call i32 @llvm.umax.i32(i32 %x, i32 1)
define i32 @clamp_umin_use(i32 %x) {
  %cmp = icmp eq i32 %x, 0
  call void @use1(i1 %cmp)
  %sel = select i1 %cmp, i32 1, i32 %x
  ret i32 %sel
}

declare void @use1(i1)