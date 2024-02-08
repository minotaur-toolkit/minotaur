; CHECK: icmp sle i32 %0, %1
define i1 @sggrqf__cmp106(i32 %0, i32 %1) {
if.end92:
  %2 = sub nsw i32 %0, %1
  %3 = icmp slt i32 %2, 1
  ret i1 %3

sink:                                             ; No predecessors!
  unreachable
}
