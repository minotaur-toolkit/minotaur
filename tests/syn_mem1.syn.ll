; CHECK: ret i32 128
define i32 @src(i32* align 4 %p) {
  store i32 128, i32* %p
  %v = load i32, i32* %p
  ret i32 %v
}
