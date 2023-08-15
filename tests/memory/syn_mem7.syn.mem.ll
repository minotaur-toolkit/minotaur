; CHECK: -2
target datalayout="e"
define i8 @src(i1 %foo) {
entry:
  %p = alloca <2 x i64>
  %sel = select i1 %foo, <2 x i64> <i64 4094, i64 2050>, <2 x i64> <i64 4094, i64 2052>
  store <2 x i64> %sel, <2 x i64>* %p
  %p2 = bitcast <2 x i64>* %p to i128*
  %v = load i128, i128* %p2
  %r = trunc i128 %v to i8
  ret i8 %r
}
