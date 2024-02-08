; CHECK: sub <2 x i32> zeroinitializer, %x
define <2 x i32> @PR27817_nsw_vec(<2 x i32> %x) {
; CHECK-LABEL: @PR27817_nsw_vec(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i32> zeroinitializer, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[SUB]]
;
  %cmp = icmp eq <2 x i32> %x, <i32 -2147483648, i32 -2147483648>
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %sel = select <2 x i1> %cmp, <2 x i32> <i32 -2147483648, i32 -2147483648>, <2 x i32> %sub
  ret <2 x i32> %sel
}
