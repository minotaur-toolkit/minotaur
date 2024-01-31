; CHECK: trunc i16 %a to i8
define i8 @syn_sv2(i16 %a) {
entry:
  %and = and i16 %a, 255
  %t = trunc i16 %and to i8
  ret i8 %t
}