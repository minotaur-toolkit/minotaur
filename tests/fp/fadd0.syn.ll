; CHECK: fsub half %y, %x
define half @fneg_op0(half %x, half %y) {
  %neg = fsub half -0.0, %x
  %add = fadd half %neg, %y
  ret half %add
}
