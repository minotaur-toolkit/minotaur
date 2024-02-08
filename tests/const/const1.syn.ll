; CHECK: ret i64 0
define i64 @fold_ptrtoint_inbounds_nullgep_of_nonzero_inbounds_nullgep_zero_offset() {
  %1 = add i64 1234, 0
  %2 = sub i64 %1, 1234
  ret i64 %2
}
