; CHECK: fptosi float %0 to i64
define i64 @src(float %0) {
if.end27:
  %1 = fptosi float %0 to i32
  %2 = sext i32 %1 to i64
  ret i64 %2

sink:                                             ; No predecessors!
  unreachable
}