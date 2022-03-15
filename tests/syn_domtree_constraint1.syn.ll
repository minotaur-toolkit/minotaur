; CHECK: add i4 %x, -3
define i4 @syn_add_1(i4 %x, i4 %y, i1 %bool) {
  %ia = sub i4 %x, 7
  br i1 %bool, label %tru, label %fal
tru:
  %ib = add i4 %ia, 4
  %ic = mul i4 %ib, 2
  br label %final
fal:
  br label %final
final:
  %if = add i4 %ia, 4
  %iff = mul i4 %if, 2
  ret i4 %iff
}
