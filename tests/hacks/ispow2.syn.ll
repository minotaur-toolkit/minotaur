; Hacker's Delight: test if unsigned is a power of 2
; ispow2(x) = (x & (x - 1)) == 0  (assumes x != 0)
; CHECK-NOT: error

define i1 @ispow2_hd(i32 %x) {
  %dec = add i32 %x, -1
  %and = and i32 %x, %dec
  %cmp = icmp eq i32 %and, 0
  ret i1 %cmp
}
