; CHECK: call <16 x i16> @llvm.x86.avx2.pavg.w
define <16 x i16> @syn_pavg_0(<16 x i16> %a, <16 x i16> %b)  {
entry:
  %za = zext <16 x i16> %a to <16 x i17>
  %zb = zext <16 x i16> %b to <16 x i17>
  %add = add <16 x i17> %za, %zb
  %add_1 = add <16 x i17> %add, <i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1>
  %sh = lshr <16 x i17> %add_1, <i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1, i17 1>
  %ret = trunc <16 x i17> %sh to <16 x i16>
  ret <16 x i16> %ret
}
