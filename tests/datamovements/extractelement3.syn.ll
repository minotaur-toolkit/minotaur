; CHECK: extractelement <6 x i32> %1, i16 0
define i32 @shrinkExtractElt_i64_to_i32_0(<3 x i64> %x) {
  %e = extractelement <3 x i64> %x, i32 0
  %t = trunc i64 %e to i32
  ret i32 %t
}