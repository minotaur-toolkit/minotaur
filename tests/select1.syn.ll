; CHECK: select i1 %cmp2, i32 16777215, i32 0
define i32 @pr61361(i32 %arg) {
; CHECK-LABEL: @pr61361(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[ARG:%.*]], 0
; CHECK-NEXT:    [[SEL2:%.*]] = select i1 [[CMP2]], i32 16777215, i32 0
; CHECK-NEXT:    ret i32 [[SEL2]]
;
  %cmp1 = icmp eq i32 %arg, 1
  %sel1 = select i1 %cmp1, i32 0, i32 33554431
  %cmp2 = icmp eq i32 %arg, 0
  %sel2 = select i1 %cmp2, i32 %sel1, i32 0
  %ashr = ashr i32 %sel2, 1
  ret i32 %ashr
}
