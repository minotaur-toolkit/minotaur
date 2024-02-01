; CHECK: extractelement <2 x double> %x, i32 0
define double @extractelement_out_of_range(<2 x double> %x, i32 %i) {
  %p = sub i32 %i, %i
  %E1 = extractelement <2 x double> %x, i32 %p
  ret double %E1
}