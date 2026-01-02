; Expected (one possible model):
;   i32 %_reservedc = poison
;
; This test is designed so the reserved constant may be synthesized as poison.
define i32 @src(i32 %_reservedc) {
entry:
  ret i32 poison
}

define i32 @tgt(i32 %_reservedc) {
entry:
  ret i32 %_reservedc
}


