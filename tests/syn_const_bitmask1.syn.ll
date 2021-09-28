; CHECK: 72057594037927680
target triple = "x86_64-apple-macosx10.15.0"

define i64 @mask(i64 %x) {
  %shr = lshr i64 %x, 8
  %shl = shl i64 %shr, 16
  %shr.2 = lshr i64 %shl, 8
  ret i64 %shr.2
}

