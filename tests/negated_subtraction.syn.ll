; TEST-ARGS: -minotaur-no-slice
; CHECK: [online] synthesized solution:
; CHECK: (sub i32 (var i32 %b) (var i32 %a))

define i32 @src(i32 %a, i32 %b) {
entry:
  %d = sub nsw i32 %a, %b
  %root = sub nsw i32 0, %d
  ret i32 %root
}
