define half @src(half %x, half %y) {
  %s = fsub  half -0.0, %x
  ret half %s
}