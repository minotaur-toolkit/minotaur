define dso_local <32 x i8> @test_mm_hsub_epi32(<32 x i8> %a) local_unnamed_addr #0 {
entry:
  %fst = extractelement <32 x i8> %a, i32 0
  %snd = extractelement <32 x i8> %a, i32 1
  %new = insertelement <32 x i8> %a, i8 %snd, i32 0
  %new2 = insertelement <32 x i8> %new, i8 %fst, i32 1
  %new3 = insertelement <32 x i8> %new2, i8 0, i32 4
  ret <32 x i8> %new3
}
