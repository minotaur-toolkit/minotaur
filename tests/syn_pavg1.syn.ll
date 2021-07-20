; CHECK: call <16 x i16> @llvm.x86.avx2.pavg.w
define <16 x i16> @syn_pavg_0(<16 x i16> %a, <16 x i16> %b)  {
entry:
  %add = add <16 x i16> %a, %b
  %add_1 = add <16 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %sh = lshr <16 x i16> %add_1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <16 x i16> %sh
}
