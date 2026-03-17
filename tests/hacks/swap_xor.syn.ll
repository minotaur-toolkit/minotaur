; Hacker's Delight: XOR swap produces original values
; After XOR swap, the second value equals the original first
; CHECK: changed

define i32 @xor_swap_result(i32 %a, i32 %b) {
  %x1 = xor i32 %a, %b
  %y1 = xor i32 %x1, %b
  %x2 = xor i32 %x1, %y1
  ret i32 %x2
}
