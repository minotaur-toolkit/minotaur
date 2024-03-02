; CHECK:  select i1 %c2, float %t5, float %t6
define float @src(float %0, float %1, i1 %c1, i1 %c2) {
if.else:
  %t4 = fneg float %1
  %t5 = select i1 %c1, float %1, float %t4
  %t6 = select i1 %c1, float %t4, float %1
  %t7 = select i1 %c2, float %t6, float %t5
  %t8 = fneg float %t7
  ret float %t8

sink:                                             ; No predecessors!
  unreachable
}