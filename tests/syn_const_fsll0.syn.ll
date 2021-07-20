; CHECK: ret i32 59
target triple = "x86_64-apple-macosx10.15.0"

define i32 @tgt() {
  %v = call i32 @ffsl(i64 9223372036854775808)
  %ret = sub i32 %v, 5
  ret i32 %ret
}

declare i32 @ffsl(i64) nounwind willreturn

