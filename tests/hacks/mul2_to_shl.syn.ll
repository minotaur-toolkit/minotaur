; Strength reduction: (x + y) * 2 → shl(add(x, y), 1)
; mul costs 4, shl costs 2 — cheaper with same result
; Requires depth-2: output is shl(add(x,y), 1)
; CHECK: shl i32

define i32 @mul2(i32 %x, i32 %y) {
  %s = add i32 %x, %y
  %r = mul i32 %s, 2
  ret i32 %r
}
