
define i1 @src(i32 %0, i1 %_reservedc_0) {
entry:
  %1 = add i32 %0, -1
  %2 = and i32 %0, 7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %do.body.prol.loopexit, label %sink

do.body.prol.loopexit:                            ; preds = %entry
  %4 = icmp ult i32 %1, 7
  ret i1 %4

sink:                                             ; preds = %entry
  unreachable
}


define i1 @tgt(i32 %0, i1 %_reservedc_0) {
entry:
  %1 = and i32 %0, 7
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %do.body.prol.loopexit, label %sink

do.body.prol.loopexit:                            ; preds = %entry
  ret i1 %_reservedc_0

sink:                                             ; preds = %entry
  unreachable
}
