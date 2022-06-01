; CHECK: 37852718839251999920126
target datalayout="e"
define i128 @src(<2 x i64>* %p) {
  store <2 x i64> <i64 4094, i64 2050>, <2 x i64>* %p
  store <2 x i64> <i64 4094, i64 2052>, <2 x i64>* %p
  %p2 = bitcast <2 x i64>* %p to i128*
  %v = load i128, i128* %p2
  ret i128 %v
}
