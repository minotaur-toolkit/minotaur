; CHECK: (conv_fptosi (var half %__n2) i32)
define i32 @src(half %0) {
if.end27:
  %1 = fptoui half %0 to i16
  %2 = zext i16 %1 to i32
  ret i32 %2
}