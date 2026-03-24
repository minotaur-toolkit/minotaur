; TEST-ARGS: -minotaur-enable-depth3 -minotaur-no-slice
; De Morgan with a unary leaf: ~bswap(x) & ~y -> ~(bswap(x) | y)
; 4 instructions -> 3 instructions (bswap + or + xor -1)
; Requires depth-3: output is xor(or(bswap(x), y), -1)
; CHECK: [online] synthesized solution:
; CHECK: call i64 @llvm.bswap.i64
; CHECK: or i64

declare i64 @llvm.bswap.i64(i64)

define i64 @not_bswap_and(i64 %x, i64 %y) {
  %bx = call i64 @llvm.bswap.i64(i64 %x)
  %nbx = xor i64 %bx, -1
  %ny = xor i64 %y, -1
  %r = and i64 %nbx, %ny
  ret i64 %r
}
