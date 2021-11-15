define i32 @test(i1 %C) {
  br label %Loop
Loop: ; preds = %BE2, %BE1, %0
  %IV = phi i32 [ 1, %0 ], [ %IVmerge, %merge ] ; <i32> [#uses=2]
  store i32 %IV, i32* null
  %IV2 = add i32 %IV, 2
  br i1 %C, label %BE1, label %BE2
BE1:  ; preds = %Loop
  %IV3 = add i32 %IV2, 5
  br label %merge
BE2:
  %IV4 = add i32 %IV2, 8
  br label %merge
merge:
  %IVmerge = phi i32 [%IV3, %BE1], [%IV4, %BE2]
  br label %Loop
}