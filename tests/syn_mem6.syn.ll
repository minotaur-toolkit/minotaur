; CHECK: 37815825351104580816894
target datalayout="e"
define i64 @src(<2 x i64>* %p, i1 %foo) {
entry:
  br i1 %foo, label %t, label %f
t:
  store <2 x i64> <i64 4094, i64 2050>, <2 x i64>* %p
  br label %ret
f:
  store <2 x i64> <i64 4094, i64 2052>, <2 x i64>* %p
  br label %ret
ret:
  %p2 = bitcast <2 x i64>* %p to i128*
  %v = load i128, i128* %p2
  %r = trunc i128 %v to i64
  ret i64 %r
}
