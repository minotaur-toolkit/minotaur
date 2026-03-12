; Hacker's Delight: clamp x to [lo, hi] range
; Uses two selects — synthesizer should find smin+smax
; CHECK: smin

define i32 @clamp_hd(i32 %x, i32 %lo, i32 %hi) {
  %cmp_lo = icmp slt i32 %x, %lo
  %t = select i1 %cmp_lo, i32 %lo, i32 %x
  %cmp_hi = icmp sgt i32 %t, %hi
  %r = select i1 %cmp_hi, i32 %hi, i32 %t
  ret i32 %r
}
