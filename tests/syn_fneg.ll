define half @src(half noundef %x, half noundef %y) {
  %s = fsub half -0.0, %x
  ret half %s
}

define half @tgt(half noundef %x, half noundef %y) {
  %s = fneg half %x
  ret half %s
}

declare void @fn(half)
