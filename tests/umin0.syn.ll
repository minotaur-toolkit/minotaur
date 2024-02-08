; CHECK: call <2 x i8> @llvm.umin.v2i8(<2 x i8> %x, <2 x i8> <i8 -2, i8 -2>)
define <2 x i8> @clamp_umaxval(<2 x i8> %x) {
  %cmp = icmp eq <2 x i8> %x, <i8 255, i8 255>
  %sel = select <2 x i1> %cmp, <2 x i8> <i8 254, i8 254>, <2 x i8> %x
  ret <2 x i8> %sel
}