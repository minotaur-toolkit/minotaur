; TEST-ARGS: -minotaur-enable-depth3 -minotaur-no-slice
; De Morgan with a counting intrinsic: ~ctlz(x) & ~y -> ~(ctlz(x) | y)
; 4 instructions -> 3 instructions (ctlz + or + xor -1)
; Requires depth-3: output is xor(or(ctlz(x), y), -1)
; CHECK: [online] synthesized solution:
; CHECK: call i64 @llvm.ctlz.i64
; CHECK: or i64

declare i64 @llvm.ctlz.i64(i64, i1 immarg)

define i64 @not_ctlz_and(i64 %x, i64 %y) {
  %lz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  %nlz = xor i64 %lz, -1
  %ny = xor i64 %y, -1
  %r = and i64 %nlz, %ny
  ret i64 %r
}
