; CHECK:  <i32 -2147483648, i32 -2147483648>
define <2 x i32> @select_icmp_slt0_xor_vec(<2 x i32> %x) {
  %cmp = icmp slt <2 x i32> %x, zeroinitializer
  %xor = xor <2 x i32> %x, <i32 2147483648, i32 2147483648>
  %x.xor = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %xor
  ret <2 x i32> %x.xor
}
