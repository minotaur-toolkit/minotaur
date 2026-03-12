; Hacker's Delight: round up to next power of 2
; Uses bit smearing then add 1
; XFAIL: timeout

define i32 @roundup_pow2(i32 %x) {
  %dec = add i32 %x, -1
  %s1 = lshr i32 %dec, 1
  %o1 = or i32 %dec, %s1
  %s2 = lshr i32 %o1, 2
  %o2 = or i32 %o1, %s2
  %s3 = lshr i32 %o2, 4
  %o3 = or i32 %o2, %s3
  %s4 = lshr i32 %o3, 8
  %o4 = or i32 %o3, %s4
  %s5 = lshr i32 %o4, 16
  %o5 = or i32 %o4, %s5
  %r = add i32 %o5, 1
  ret i32 %r
}
