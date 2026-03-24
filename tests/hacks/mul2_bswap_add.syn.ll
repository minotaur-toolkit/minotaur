; TEST-ARGS: -minotaur-enable-depth3 -minotaur-no-slice
; Strength reduction with a unary leaf: (bswap(x) + y) * 2 -> shl(add(bswap(x), y), 1)
; Same instruction count, but mul is more expensive than shl
; Requires depth-3: output is shl(add(bswap(x), y), 1)
; CHECK: [online] synthesized solution:
; CHECK: call i64 @llvm.bswap.i64
; CHECK: shl i64

declare i64 @llvm.bswap.i64(i64)

define i64 @mul2_bswap_add(i64 %x, i64 %y) {
  %bx = call i64 @llvm.bswap.i64(i64 %x)
  %s = add i64 %bx, %y
  %r = mul i64 %s, 2
  ret i64 %r
}
