; CHECK: %sel = select i1 %cmp, fp128 0xL00000000000000004000000000000000, fp128 0xL00000D00000000004000000000000000
define fp128 @fabs_select_constant_negative_negative(i32 %c) {
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, fp128 0xL0000000000000000C000000000000000, fp128 0xL00000D0000000000C000000000000000
  %fabs = call fp128 @llvm.fabs.f128(fp128 %select)
  ret fp128 %fabs
}

declare fp128 @llvm.fabs.f128(fp128)