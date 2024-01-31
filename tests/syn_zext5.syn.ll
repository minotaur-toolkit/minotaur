; CHECK: zext i8 %a to i16
define i16 @syn_sv2(i8 %a) {
entry:
  %zx = sext i8 %a to i16
  %and = and i16 %zx, 255
  ret i16 %and
}