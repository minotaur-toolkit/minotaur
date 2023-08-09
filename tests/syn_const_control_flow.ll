
define i1 @src(i32 %0) {
entry:
  %1 = add i32 %0, -1
  %2 = and i32 %0, 7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %do.body.prol.loopexit, label %sink

do.body.prol.loopexit:                            ; preds = %entry
  %4 = icmp ult i32 %1, 7
  %5 = add i1 %3, %4
  ret i1 %5

sink:                                             ; preds = %entry
  unreachable
}


