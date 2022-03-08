; Function Attrs: alwaysinline nounwind readnone
define <16 x i32> @divergence(<16 x i32> %a, <16 x i32> %b, i1 %j) #2 {
  br i1 %j, label %t1, label %f1
t1:
  %a1 = call <16 x i32> @llvm.x86.avx512.mask.padd.d.512(<16 x i32> %a, <16 x i32> %b, <16 x i32> zeroinitializer, i16 43690)
  br label %mid
f1:
  %a2 = call <16 x i32> @llvm.x86.avx512.mask.padd.d.512(<16 x i32> %a, <16 x i32> %b, <16 x i32> zeroinitializer, i16 21845)
  br label %mid
mid:
  %ret_1 = phi <16 x i32> [%a1, %t1], [%a2, %f1]
  %not_j = icmp eq i1 %j, 0
  br i1 %not_j, label %t2, label %f2
t2:
  %b1 = call <16 x i32> @llvm.x86.avx512.mask.padd.d.512(<16 x i32> %a, <16 x i32> %b, <16 x i32> zeroinitializer, i16 43690)
  br label %final
f2:
  %b2 = call <16 x i32> @llvm.x86.avx512.mask.padd.d.512(<16 x i32> %a, <16 x i32> %b, <16 x i32> zeroinitializer, i16 21845)
  br label %final
final:
  %ret_2 = phi <16 x i32> [%b1, %t2], [%b2, %f2]
  %ret = add <16 x i32> %ret_1, %ret_2
  ret <16 x i32> %ret
}

declare <16 x i32> @llvm.x86.avx512.mask.padd.d.512(<16 x i32>, <16 x i32>, <16 x i32>, i16)

