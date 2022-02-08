
define i32 @reduce(<8 x i32> %a) {
  %b = shufflevector <8 x i32> %a, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %c = add <8 x i32> %a, %b
  %d = shufflevector <8 x i32> %c, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %e = add <8 x i32> %c, %d
  %f = shufflevector <8 x i32> %e, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %g = add <8 x i32> %e, %f
  %res = extractelement <8 x i32> %g, i32 0
  ret i32 %res
}



define i32 @reduce2(<8 x i32> %a) {
  %res = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> %a)
  ret i32 %res
}

declare i32 @llvm.vector.reduce.add.v8i32(<8 x i32> %a)