; CHECK: icmp ugt i64 %0, -4503599627370497
define i1 @rewrite(i64 %0) {
if.end25:
  %1 = lshr i64 %0, 52
  %2 = trunc i64 %1 to i32
  %3 = icmp eq i32 %2, 4095
  ret i1 %3

sink:                                             ; No predecessors!
  unreachable
}
