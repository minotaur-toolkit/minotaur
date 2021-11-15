define i32 @test(i1 %C) {
  br label %Loop
Loop: ; preds = %BE2, %BE1, %0
  %IV = phi i32 [ 1, %0 ], [ %IV2, %BE1 ] ; <i32> [#uses=2]
  store i32 %IV, i32* null
  %IV2 = add i32 %IV, 2
  br label %BE1
BE1:  ; preds = %Loop
  %IV3 = add i32 %IV2, 5
  br label %Loop
}