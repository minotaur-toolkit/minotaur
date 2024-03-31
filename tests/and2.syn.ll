; CHECK: select i1 %y, i1 false, i1 %x
; fixme

define i1 @not_false_not(i1 %x, i1 %y) {
; CHECK-LABEL: @not_false_not(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i1 [[Y:%.*]], true
; CHECK-NEXT:    [[R:%.*]] = select i1 [[X:%.*]], i1 [[NOTY]], i1 false
; CHECK-NEXT:    ret i1 [[R]]
;
  %notx = xor i1 %x, true
  %noty = xor i1 %y, true
  %r = select i1 %notx, i1 false, i1 %noty
  ret i1 %r
}
