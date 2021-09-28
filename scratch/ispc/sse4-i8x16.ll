;;  Copyright (c) 2013, 2015, Google, Inc.
;;  Copyright(c) 2019 Intel
;;  All rights reserved.
;;
;;  Redistribution and use in source and binary forms, with or without
;;  modification, are permitted provided that the following conditions are
;;  met:
;;
;;    * Redistributions of source code must retain the above copyright
;;      notice, this list of conditions and the following disclaimer.
;;
;;    * Redistributions in binary form must reproduce the above copyright
;;      notice, this list of conditions and the following disclaimer in the
;;      documentation and/or other materials provided with the distribution.
;;
;;    * Neither the name of Google, Inc. nor the names of its
;;      contributors may be used to endorse or promote products derived from
;;      this software without specific prior written permission.
;;
;;
;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
;;   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
;;   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
;;   OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;;   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Define common 4-wide stuff


;;  Copyright (c) 2010-2021, Intel Corporation
;;  All rights reserved.
;;
;;  Redistribution and use in source and binary forms, with or without
;;  modification, are permitted provided that the following conditions are
;;  met:
;;
;;    * Redistributions of source code must retain the above copyright
;;      notice, this list of conditions and the following disclaimer.
;;
;;    * Redistributions in binary form must reproduce the above copyright
;;      notice, this list of conditions and the following disclaimer in the
;;      documentation and/or other materials provided with the distribution.
;;
;;    * Neither the name of Intel Corporation nor the names of its
;;      contributors may be used to endorse or promote products derived from
;;      this software without specific prior written permission.
;;
;;
;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
;;   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
;;   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
;;   OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;;   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  

;; This file provides a variety of macros used to generate LLVM bitcode
;; parametrized in various ways.  Implementations of the standard library
;; builtins for various targets can use macros from this file to simplify
;; generating code for their implementations of those builtins.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; It is a bit of a pain to compute this in m4 for 32 and 64-wide targets...




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; vector convertation utilities
;; convert vector of one width into vector of other width
;;
;; $1: vector element type
;; $2: vector of the first width
;; $3: vector of the second width





































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;saturation arithmetic
 


;; create vector constant. Used by saturation_arithmetic_novec_universal below.


                        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Saturarion arithmetic, not supported here, needed for compatibility











declare <16 x i32> @__padds_vi32(<16 x i32>, <16 x i32>)
declare <16 x i32> @__paddus_vi32(<16 x i32>, <16 x i32>)


declare <16 x i64> @__padds_vi64(<16 x i64>, <16 x i64>)
declare <16 x i64> @__paddus_vi64(<16 x i64>, <16 x i64>)



declare i8 @__padds_ui8(i8, i8) nounwind alwaysinline
declare i8 @__paddus_ui8(i8, i8) nounwind alwaysinline


declare i16 @__padds_ui16(i16, i16) nounwind alwaysinline
declare i16 @__paddus_ui16(i16, i16) nounwind alwaysinline


declare i32 @__padds_ui32(i32, i32) nounwind alwaysinline
declare i32 @__paddus_ui32(i32, i32) nounwind alwaysinline


declare i64 @__padds_ui64(i64, i64) nounwind alwaysinline
declare i64 @__paddus_ui64(i64, i64) nounwind alwaysinline




declare <16 x i32> @__psubs_vi32(<16 x i32>, <16 x i32>)
declare <16 x i32> @__psubus_vi32(<16 x i32>, <16 x i32>)


declare <16 x i64> @__psubs_vi64(<16 x i64>, <16 x i64>)
declare <16 x i64> @__psubus_vi64(<16 x i64>, <16 x i64>)



declare i8 @__psubs_ui8(i8, i8) nounwind alwaysinline
declare i8 @__psubus_ui8(i8, i8) nounwind alwaysinline


declare i16 @__psubs_ui16(i16, i16) nounwind alwaysinline
declare i16 @__psubus_ui16(i16, i16) nounwind alwaysinline


declare i32 @__psubs_ui32(i32, i32) nounwind alwaysinline
declare i32 @__psubus_ui32(i32, i32) nounwind alwaysinline


declare i64 @__psubs_ui64(i64, i64) nounwind alwaysinline
declare i64 @__psubus_ui64(i64, i64) nounwind alwaysinline





declare <16 x i8> @__pmuls_vi8(<16 x i8>, <16 x i8>)
declare <16 x i8> @__pmulus_vi8(<16 x i8>, <16 x i8>)


declare <16 x i16> @__pmuls_vi16(<16 x i16>, <16 x i16>)
declare <16 x i16> @__pmulus_vi16(<16 x i16>, <16 x i16>)


declare <16 x i32> @__pmuls_vi32(<16 x i32>, <16 x i32>)
declare <16 x i32> @__pmulus_vi32(<16 x i32>, <16 x i32>)


declare <16 x i64> @__pmuls_vi64(<16 x i64>, <16 x i64>)
declare <16 x i64> @__pmulus_vi64(<16 x i64>, <16 x i64>)



declare i8 @__pmuls_ui8(i8, i8) nounwind alwaysinline
declare i8 @__pmulus_ui8(i8, i8) nounwind alwaysinline


declare i16 @__pmuls_ui16(i16, i16) nounwind alwaysinline
declare i16 @__pmulus_ui16(i16, i16) nounwind alwaysinline


declare i32 @__pmuls_ui32(i32, i32) nounwind alwaysinline
declare i32 @__pmulus_ui32(i32, i32) nounwind alwaysinline


declare i64 @__pmuls_ui64(i64, i64) nounwind alwaysinline
declare i64 @__pmulus_ui64(i64, i64) nounwind alwaysinline




declare <16 x i8> @__pdivs_vi8(<16 x i8>, <16 x i8>)
declare <16 x i8> @__pdivus_vi8(<16 x i8>, <16 x i8>)


declare <16 x i16> @__pdivs_vi16(<16 x i16>, <16 x i16>)
declare <16 x i16> @__pdivus_vi16(<16 x i16>, <16 x i16>)


declare <16 x i32> @__pdivs_vi32(<16 x i32>, <16 x i32>)
declare <16 x i32> @__pdivus_vi32(<16 x i32>, <16 x i32>)


declare <16 x i64> @__pdivs_vi64(<16 x i64>, <16 x i64>)
declare <16 x i64> @__pdivus_vi64(<16 x i64>, <16 x i64>)



declare i8 @__pdivs_ui8(i8, i8) nounwind alwaysinline
declare i8 @__pdivus_ui8(i8, i8) nounwind alwaysinline


declare i16 @__pdivs_ui16(i16, i16) nounwind alwaysinline
declare i16 @__pdivus_ui16(i16, i16) nounwind alwaysinline


declare i32 @__pdivs_ui32(i32, i32) nounwind alwaysinline
declare i32 @__pdivus_ui32(i32, i32) nounwind alwaysinline


declare i64 @__pdivs_ui64(i64, i64) nounwind alwaysinline
declare i64 @__pdivus_ui64(i64, i64) nounwind alwaysinline



declare i64 @__abs_ui64(i64 %a)
declare <16 x i64> @__abs_vi64(<16 x i64> %a)

;; utility function used by saturation_arithmetic_novec below.  This shouldn't be called by
;; target .ll files directly.
;; $1: {add,sub} (used in constructing function names)
                        


;; implementation for targets which doesn't have h/w instructions



;;4-wide vector saturation arithmetic



;;8-wide vector saturation arithmetic



;;16-wide vector saturation arithmetic



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; vector deconstruction utilities
;; split 8-wide vector into 2 4-wide vectors
;;
;; $1: vector element type
;; $2: 8-wide vector
;; $3: first 4-wide vector
;; $4: second 4-wide vector











;; $1: vector element type
;; $2: input 32-wide vector
;; $3-$4: 2 output 16-wide vectors


;; $1: vector element type
;; $2: input 32-wide vector
;; $3-$6: 4 output 8-wide vectors


;; $1: vector element type
;; $2: input 32-wide vector
;; $3-$10: 8 output 4-wide vectors


;; $1: vector element type
;; $2: input 64-wide vector
;; $3-$6: 4 output 16-wide vectors


;; $1: vector element type
;; $2: input 64-wide vector
;; $3-$10: 8 output 8-wide vectors


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; vector assembly: wider vector from several narrower vectors
;;
;; $1: vector element type
;; $2-$5: 4 input 4-wide vectors
;; $6: output 16-wide vector


;; $1: vector element type
;; $2-$9: 4 input 4-wide vectors
;; $10: output 16-wide vector


;; $1: vector element type
;; $2: first n-wide vector
;; $3: second n-wide vector
;; $4: result 2*n-wide vector


;; $1: vector element type
;; $2-$3: 2 input 16-wide vectors
;; $4: output 32-wide vector


;; $1: vector element type
;; $2-$5: 4 input 8-wide vectors
;; $6: output 32-wide vector


;; $1: vector element type
;; $2-$5: 4 input 16-wide vectors
;; $6: output 64-wide vector



;; $1: vector element type
;; $2-$9: 8 input 16-wide vectors
;; $10: output 64-wide vector



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helper macro for calling various SSE instructions for scalar values
;; but where the instruction takes a vector parameter.
;; $1 : name of variable to put the final value in
;; $2 : vector width of the target
;; $3 : scalar type of the operand
;; $4 : SSE intrinsic name
;; $5 : variable name that has the scalar value
;; For example, the following call causes the variable %ret to have
;; the result of a call to sqrtss with the scalar value in %0
;;  sse_unary_scalar(ret, 4, float, @llvm.x86.sse.sqrt.ss, %0)



;; Similar to sse_unary_scalar, this helper macro is for calling binary
;; SSE instructions with scalar values, 
;; $1: name of variable to put the result in
;; $2: vector width of the target
;; $3: scalar type of the operand
;; $4 : SSE intrinsic name
;; $5 : variable name that has the first scalar operand
;; $6 : variable name that has the second scalar operand



;; Do a reduction over a 4-wide vector
;; $1: type of final scalar result
;; $2: 4-wide function that takes 2 4-wide operands and returns the
;;     element-wise reduction
;; $3: scalar function that takes two scalar operands and returns
;;     the final reduction



;; Similar to reduce4, do a reduction over an 8-wide vector
;; $1: type of final scalar result
;; $2: 8-wide function that takes 2 8-wide operands and returns the
;;     element-wise reduction
;; $3: scalar function that takes two scalar operands and returns
;;     the final reduction



;; Do a reduction over an 16-wide vector
;; $1: type of final scalar result
;; $2: 16-wide function that takes 2 16-wide operands and returns the
;;     element-wise reduction
;; $3: scalar function that takes two scalar operands and returns
;;     the final reduction



;; Do a reduction over an 32-wide vector
;; $1: type of final scalar result
;; $2: 32-wide function that takes 2 32-wide operands and returns the
;;     element-wise reduction
;; $3: scalar function that takes two scalar operands and returns
;;     the final reduction



;; Do a reduction over an 64-wide vector
;; $1: type of final scalar result
;; $2: 64-wide function that takes 2 64-wide operands and returns the
;;     element-wise reduction
;; $3: scalar function that takes two scalar operands and returns
;;     the final reduction




;; Do an reduction over an 8-wide vector, using a vector reduction function
;; that only takes 4-wide vectors
;; $1: type of final scalar result
;; $2: 4-wide function that takes 2 4-wide operands and returns the 
;;     element-wise reduction
;; $3: scalar function that takes two scalar operands and returns
;;     the final reduction




;; Apply a unary function to the 4-vector in %0, return the vector result.
;; $1: scalar type of result
;; $2: name of scalar function to call





;; Given a unary function that takes a 2-wide vector and a 4-wide vector
;; that we'd like to apply it to, extract 2 2-wide vectors from the 4-wide
;; vector, apply it, and return the corresponding 4-wide vector result
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 2-wide unary vector function to apply
;; $4: 4-wide operand value



;; Similar to unary2to4, this applies a 2-wide binary function to two 4-wide
;; vector operands
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 2-wide binary vector function to apply
;; $4: First 4-wide operand value
;; $5: Second 4-wide operand value



;; Similar to unary2to4, this maps a 4-wide unary function to an 8-wide 
;; vector operand
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 4-wide unary vector function to apply
;; $4: 8-wide operand value



;; $1: name of variable into which the final result should go
;; $2: scalar type of the input vector elements
;; $3: scalar type of the result vector elements
;; $4: 4-wide unary vector function to apply
;; $5: 8-wide operand value







;; And so forth...
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 8-wide unary vector function to apply
;; $4: 16-wide operand value



;; And along the lines of binary2to4, this maps a 4-wide binary function to
;; two 8-wide vector operands
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 4-wide unary vector function to apply
;; $4: First 8-wide operand value
;; $5: Second 8-wide operand value







;; Maps a 2-wide unary function to an 8-wide vector operand, returning an 
;; 8-wide vector result
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 2-wide unary vector function to apply
;; $4: 8-wide operand value





;; Maps an 2-wide binary function to two 8-wide vector operands
;; $1: name of variable into which the final result should go
;; $2: scalar type of the vector elements
;; $3: 2-wide unary vector function to apply
;; $4: First 8-wide operand value
;; $5: Second 8-wide operand value





;; The unary SSE round intrinsic takes a second argument that encodes the
;; rounding mode.  This macro makes it easier to apply the 4-wide roundps
;; to 8-wide vector operands
;; $1: value to be rounded
;; $2: integer encoding of rounding mode
;; FIXME: this just has a ret statement at the end to return the result,
;; which is inconsistent with the macros above 









; and similarly for doubles...









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; forloop macro


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stdlib_core
;;
;; This macro defines a bunch of helper routines that depend on the
;; target's vector width
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global_atomic_associative
;; More efficient implementation for atomics that are associative (e.g.,
;; add, and, ...).  If a basic implementation would do sometihng like:
;; result0 = atomic_op(ptr, val0)
;; result1 = atomic_op(ptr, val1)
;; ..
;; Then instead we can do:
;; tmp = (val0 op val1 op ...)
;; result0 = atomic_op(ptr, tmp)
;; result1 = (result0 op val0)
;; ..
;; And more efficiently compute the same result
;;
;; Takes five parameters:
;; $1: vector width of the target
;; $2: operation being performed (w.r.t. LLVM atomic intrinsic names)
;;     (add, sub...)
;; $3: return type of the LLVM atomic (e.g. i32)
;; $4: return type of the LLVM atomic type, in ispc naming paralance (e.g. int32)
;; $5: identity value for the operator (e.g. 0 for add, -1 for AND, ...)




define internal <16 x i8> @convertmask_i1_i8_16(<16 x i1>) {
  %r = sext <16 x i1> %0 to <16 x i8>
  ret <16 x i8> %r
}
define internal <16 x i16> @convertmask_i1_i16_16(<16 x i1>) {
  %r = sext <16 x i1> %0 to <16 x i16>
  ret <16 x i16> %r
}
define internal <16 x i32> @convertmask_i1_i32_16(<16 x i1>) {
  %r = sext <16 x i1> %0 to <16 x i32>
  ret <16 x i32> %r
}
define internal <16 x i64> @convertmask_i1_i64_16(<16 x i1>) {
  %r = sext <16 x i1> %0 to <16 x i64>
  ret <16 x i64> %r
}

define internal <16 x i8> @convertmask_i8_i8_16(<16 x i8>) {
  ret <16 x i8> %0
}
define internal <16 x i16> @convertmask_i8_i86_16(<16 x i8>) {
  %r = sext <16 x i8> %0 to <16 x i16>
  ret <16 x i16> %r
}
define internal <16 x i32> @convertmask_i8_i32_16(<16 x i8>) {
  %r = sext <16 x i8> %0 to <16 x i32>
  ret <16 x i32> %r
}
define internal <16 x i64> @convertmask_i8_i64_16(<16 x i8>) {
  %r = sext <16 x i8> %0 to <16 x i64>
  ret <16 x i64> %r
}

define internal <16 x i8> @convertmask_i16_i8_16(<16 x i16>) {
  %r = trunc <16 x i16> %0 to <16 x i8>
  ret <16 x i8> %r
}
define internal <16 x i16> @convertmask_i16_i16_16(<16 x i16>) {
  ret <16 x i16> %0
}
define internal <16 x i32> @convertmask_i16_i32_16(<16 x i16>) {
  %r = sext <16 x i16> %0 to <16 x i32>
  ret <16 x i32> %r
}
define internal <16 x i64> @convertmask_i16_i64_16(<16 x i16>) {
  %r = sext <16 x i16> %0 to <16 x i64>
  ret <16 x i64> %r
}

define internal <16 x i8> @convertmask_i32_i8_16(<16 x i32>) {
  %r = trunc <16 x i32> %0 to <16 x i8>
  ret <16 x i8> %r
}
define internal <16 x i16> @convertmask_i32_i16_16(<16 x i32>) {
  %r = trunc <16 x i32> %0 to <16 x i16>
  ret <16 x i16> %r
}
define internal <16 x i32> @convertmask_i32_i32_16(<16 x i32>) {
  ret <16 x i32> %0
}
define internal <16 x i64> @convertmask_i32_i64_16(<16 x i32>) {
  %r = sext <16 x i32> %0 to <16 x i64>
  ret <16 x i64> %r
}

define internal <16 x i8> @convertmask_i64_i8_16(<16 x i64>) {
  %r = trunc <16 x i64> %0 to <16 x i8>
  ret <16 x i8> %r
}
define internal <16 x i16> @convertmask_i64_i16_16(<16 x i64>) {
  %r = trunc <16 x i64> %0 to <16 x i16>
  ret <16 x i16> %r
}
define internal <16 x i32> @convertmask_i64_i32_16(<16 x i64>) {
  %r = trunc <16 x i64> %0 to <16 x i32>
  ret <16 x i32> %r
}
define internal <16 x i64> @convertmask_i64_i64_16(<16 x i64>) {
  ret <16 x i64> %0
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global_atomic_uniform
;; Defines the implementation of a function that handles the mapping from
;; an ispc atomic function to the underlying LLVM intrinsics.  This variant
;; just calls the atomic once, for the given uniform value
;;
;; Takes four parameters:
;; $1: vector width of the target
;; $2: operation being performed (w.r.t. LLVM atomic intrinsic names)
;;     (add, sub...)
;; $3: return type of the LLVM atomic (e.g. i32)
;; $4: return type of the LLVM atomic type, in ispc naming paralance (e.g. int32)



;; Macro to declare the function that implements the swap atomic.  
;; Takes three parameters:
;; $1: vector width of the target
;; $2: llvm type of the vector elements (e.g. i32)
;; $3: ispc type of the elements (e.g. int32)




;; Similarly, macro to declare the function that implements the compare/exchange
;; atomic.  Takes three parameters:
;; $1: vector width of the target
;; $2: llvm type of the vector elements (e.g. i32)
;; $3: ispc type of the elements (e.g. int32)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; count trailing zeros



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; population count



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prefetching



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AOS/SOA conversion primitives

;; take 4 4-wide vectors laid out like <r0 g0 b0 a0> <r1 g1 b1 a1> ...
;; and reorder them to <r0 r1 r2 r3> <g0 g1 g2 g3> ...



;; 8-wide
;; These functions implement the 8-wide variants of the AOS/SOA conversion
;; routines above.  These implementations are all built on top of the 4-wide
;; vector versions.



;; 16-wide



;; 32 wide version



;; 64 wide version



;; versions to be called from stdlib


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 64-bit integer min and max functions

;; utility function used by int64minmax below.  This shouldn't be called by
;; target .ll files directly.
;; $1: target vector width
;; $2: {min,max} (used in constructing function names)
;; $3: {int64,uint64} (used in constructing function names)
;; $4: {slt,sgt} comparison operator to used



;; this is the function that target .ll files should call; it just takes the target
;; vector width as a parameter



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emit general-purpose code to do a masked load for targets that dont have
;; an instruction to do that.  Parameters:
;; $1: element type for which to emit the function (i32, i64, ...) (and suffix for function name)
;; $2: alignment for elements of type $1 (4, 8, ...)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; streaming stores














  
  
define void @__streaming_store_varying_float(float* nocapture, <16 x float>) nounwind alwaysinline {
  %ptr = bitcast float* %0 to <16 x float>*
  store <16 x float> %1, <16 x float>* %ptr , !nontemporal !1
  ret void
}

  
define void @__streaming_store_varying_double(double* nocapture, <16 x double>) nounwind alwaysinline {
  %ptr = bitcast double* %0 to <16 x double>*
  store <16 x double> %1, <16 x double>* %ptr , !nontemporal !1
  ret void
}

  
define void @__streaming_store_varying_i8(i8* nocapture, <16 x i8>) nounwind alwaysinline {
  %ptr = bitcast i8* %0 to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %ptr , !nontemporal !1
  ret void
}

  
define void @__streaming_store_varying_i16(i16* nocapture, <16 x i16>) nounwind alwaysinline {
  %ptr = bitcast i16* %0 to <16 x i16>*
  store <16 x i16> %1, <16 x i16>* %ptr , !nontemporal !1
  ret void
}

  
define void @__streaming_store_varying_i32(i32* nocapture, <16 x i32>) nounwind alwaysinline {
  %ptr = bitcast i32* %0 to <16 x i32>*
  store <16 x i32> %1, <16 x i32>* %ptr , !nontemporal !1
  ret void
}

  
define void @__streaming_store_varying_i64(i64* nocapture, <16 x i64>) nounwind alwaysinline {
  %ptr = bitcast i64* %0 to <16 x i64>*
  store <16 x i64> %1, <16 x i64>* %ptr , !nontemporal !1
  ret void
}


  
  
define void @__streaming_store_uniform_float(float* nocapture, float) nounwind alwaysinline {
  store float %1, float * %0 , !nontemporal !1
  ret void
}

  
define void @__streaming_store_uniform_double(double* nocapture, double) nounwind alwaysinline {
  store double %1, double * %0 , !nontemporal !1
  ret void
}

  
define void @__streaming_store_uniform_i8(i8* nocapture, i8) nounwind alwaysinline {
  store i8 %1, i8 * %0 , !nontemporal !1
  ret void
}

  
define void @__streaming_store_uniform_i16(i16* nocapture, i16) nounwind alwaysinline {
  store i16 %1, i16 * %0 , !nontemporal !1
  ret void
}

  
define void @__streaming_store_uniform_i32(i32* nocapture, i32) nounwind alwaysinline {
  store i32 %1, i32 * %0 , !nontemporal !1
  ret void
}

  
define void @__streaming_store_uniform_i64(i64* nocapture, i64) nounwind alwaysinline {
  store i64 %1, i64 * %0 , !nontemporal !1
  ret void
}


  
  !1 = !{i32 1}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; streaming loads












  
  
  define <16 x float> @__streaming_load_varying_float(float* nocapture) nounwind alwaysinline {
  %ptr = bitcast float* %0 to <16 x float>*
  %loadval = load <16 x float> , <16 x float> *
 %ptr , !nontemporal !1
  ret <16 x float> %loadval
}

  
  define <16 x double> @__streaming_load_varying_double(double* nocapture) nounwind alwaysinline {
  %ptr = bitcast double* %0 to <16 x double>*
  %loadval = load <16 x double> , <16 x double> *
 %ptr , !nontemporal !1
  ret <16 x double> %loadval
}

  
  define <16 x i8> @__streaming_load_varying_i8(i8* nocapture) nounwind alwaysinline {
  %ptr = bitcast i8* %0 to <16 x i8>*
  %loadval = load <16 x i8> , <16 x i8> *
 %ptr , !nontemporal !1
  ret <16 x i8> %loadval
}

  
  define <16 x i16> @__streaming_load_varying_i16(i16* nocapture) nounwind alwaysinline {
  %ptr = bitcast i16* %0 to <16 x i16>*
  %loadval = load <16 x i16> , <16 x i16> *
 %ptr , !nontemporal !1
  ret <16 x i16> %loadval
}

  
  define <16 x i32> @__streaming_load_varying_i32(i32* nocapture) nounwind alwaysinline {
  %ptr = bitcast i32* %0 to <16 x i32>*
  %loadval = load <16 x i32> , <16 x i32> *
 %ptr , !nontemporal !1
  ret <16 x i32> %loadval
}

  
  define <16 x i64> @__streaming_load_varying_i64(i64* nocapture) nounwind alwaysinline {
  %ptr = bitcast i64* %0 to <16 x i64>*
  %loadval = load <16 x i64> , <16 x i64> *
 %ptr , !nontemporal !1
  ret <16 x i64> %loadval
}


  
  
define float @__streaming_load_uniform_float(float* nocapture) nounwind alwaysinline {
  %loadval = load float , float *
 %0 , !nontemporal !1
  ret float %loadval
}

  
define double @__streaming_load_uniform_double(double* nocapture) nounwind alwaysinline {
  %loadval = load double , double *
 %0 , !nontemporal !1
  ret double %loadval
}

  
define i8 @__streaming_load_uniform_i8(i8* nocapture) nounwind alwaysinline {
  %loadval = load i8 , i8 *
 %0 , !nontemporal !1
  ret i8 %loadval
}

  
define i16 @__streaming_load_uniform_i16(i16* nocapture) nounwind alwaysinline {
  %loadval = load i16 , i16 *
 %0 , !nontemporal !1
  ret i16 %loadval
}

  
define i32 @__streaming_load_uniform_i32(i32* nocapture) nounwind alwaysinline {
  %loadval = load i32 , i32 *
 %0 , !nontemporal !1
  ret i32 %loadval
}

  
define i64 @__streaming_load_uniform_i64(i64* nocapture) nounwind alwaysinline {
  %loadval = load i64 , i64 *
 %0 , !nontemporal !1
  ret i64 %loadval
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; masked store
;; emit code to do masked store as a set of per-lane scalar stores
;; parameters:
;; $1: llvm type of elements (and suffix for function name)












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; packed load and store helper functions
;;
;; Implementations for different 16.
;; Cannot have a generic implementation because calculating atcive lanes require 16.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; packed load and store helper
;;
;; Decides definition to be used for calculating active lanes based on 16.
;; Implement valid version of 'packed_store_active2' based on requirement.
;;
;; $1: Integer type for which function is to be created.
;; $2: 'TRUE' if LLVM compressstore/expandload intrinsics should be used for implementation of '__packed_store_active2'.
;;     This is the case for the targets with native support of these intrinsics (AVX512).
;;     For other targets branchless emulation sequence should be used (triggered by 'FALSE').
;; $3: Alignment for store.
;;
;; FIXME: use the per_lane macro, defined below, to implement these!



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; packed load and store functions
;;
;; These define functions to emulate those nice packed load and packed store
;; instructions.  For packed store, given a pointer to destination array and
;; a varying value, for each lane where the mask is on, the
;; corresponding value for that lane is stored into packed locations in the
;; destination array.  For packed load, each lane that has an active mask
;; loads a sequential value from the array.
;;
;; $1: 'TRUE' if LLVM compressstore/expandload intrinsics should be used for implementation of '__packed_store_active2'.
;;     This is the case for the targets with native support of these intrinsics (AVX512).
;;     For other targets branchless emulation sequence should be used (triggered by 'FALSE').


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; reduce_equal

;; count leading/trailing zeros
;; Macros declares set of count-trailing and count-leading zeros.
;; Macros behaves as a static functon - it works only at first invokation
;; to avoid redifinition.






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prefix sum stuff

; $1: vector width (e.g. 4)
; $2: vector element type (e.g. float)
; $3: bit width of vector element type (e.g. 32)
; $4: operator to apply (e.g. fadd)
; $5: identity element value (e.g. 0)
; $6: suffix for function (e.g. add_float)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; per_lane
;;
;; The scary macro below encapsulates the 'scalarization' idiom--i.e. we have
;; some operation that we'd like to perform only for the lanes where the
;; mask is on
;; $1: vector width of the target
;; $2: variable that holds the mask
;; $3: block of code to run for each lane that is on
;;       Inside this code, any instances of the text "LANE" are replaced
;;       with an i32 value that represents the current lane number

; num lanes, mask, code block to do per lane


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gather
;;
;; $1: scalar type for which to generate functions to do gathers



; vec width, type


; vec width, type



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gen_scatter
;; Emit a function declaration for a scalarized scatter.
;;
;; $1: scalar type for which we want to generate code to scatter



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rdrand 





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; int8/int16 builtins


































declare <16 x i32> @__atomic_compare_exchange_varying_int32_global(<16 x i64> %ptr, <16 x i32> %cmp, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_compare_exchange_varying_int64_global(<16 x i64> %ptr, <16 x i64> %cmp, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x float> @__atomic_compare_exchange_varying_float_global(<16 x i64> %ptr, <16 x float> %cmp, <16 x float> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x double> @__atomic_compare_exchange_varying_double_global(<16 x i64> %ptr, <16 x double> %cmp, <16 x double> %val, <16 x i8> %maskv) nounwind alwaysinline



declare <16 x i32> @__atomic_swap_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_swap_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x float> @__atomic_swap_varying_float_global(<16 x i64> %ptr, <16 x float> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x double> @__atomic_swap_varying_double_global(<16 x i64> %ptr, <16 x double> %val, <16 x i8> %maskv) nounwind alwaysinline



declare <16 x i32> @__atomic_add_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_sub_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_and_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_or_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_xor_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_min_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_max_varying_int32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_umin_varying_uint32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i32> @__atomic_umax_varying_uint32_global(<16 x i64> %ptr, <16 x i32> %val, <16 x i8> %maskv) nounwind alwaysinline



declare <16 x i64> @__atomic_add_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_sub_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_and_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_or_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_xor_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_min_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_max_varying_int64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_umin_varying_uint64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline


declare <16 x i64> @__atomic_umax_varying_uint64_global(<16 x i64> %ptr, <16 x i64> %val, <16 x i8> %maskv) nounwind alwaysinline










declare i32 @__fast_masked_vload()

declare i8* @ISPCAlloc(i8**, i64, i32) nounwind
declare void @ISPCLaunch(i8**, i8*, i8*, i32, i32, i32) nounwind
declare void @ISPCSync(i8*) nounwind
declare void @ISPCInstrument(i8*, i8*, i32, i64) nounwind


declare i32 @__task_index0()  nounwind readnone alwaysinline
declare i32 @__task_index1()  nounwind readnone alwaysinline
declare i32 @__task_index2()  nounwind readnone alwaysinline
declare i32 @__task_index()  nounwind readnone alwaysinline
declare i32 @__task_count0()  nounwind readnone alwaysinline
declare i32 @__task_count1()  nounwind readnone alwaysinline
declare i32 @__task_count2()  nounwind readnone alwaysinline
declare i32 @__task_count()  nounwind readnone alwaysinline

declare <16 x i8> @__idiv_int8(<16 x i8>, <16 x i8>) nounwind readnone
declare <16 x i16> @__idiv_int16(<16 x i16>, <16 x i16>) nounwind readnone
declare <16 x i32> @__idiv_int32(<16 x i32>, <16 x i32>) nounwind readnone
declare <16 x i8> @__idiv_uint8(<16 x i8>, <16 x i8>) nounwind readnone
declare <16 x i16> @__idiv_uint16(<16 x i16>, <16 x i16>) nounwind readnone
declare <16 x i32> @__idiv_uint32(<16 x i32>, <16 x i32>) nounwind readnone


declare i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
declare i1 @__is_compile_time_constant_uniform_int32(i32)
declare i1 @__is_compile_time_constant_varying_int32(<16 x i32>)

; This function declares placeholder masked store functions for the
;  front-end to use.
;
;  void __pseudo_masked_store_i8 (uniform int8 *ptr, varying int8 values, mask)
;  void __pseudo_masked_store_i16(uniform int16 *ptr, varying int16 values, mask)
;  void __pseudo_masked_store_i32(uniform int32 *ptr, varying int32 values, mask)
;  void __pseudo_masked_store_float(uniform float *ptr, varying float values, mask)
;  void __pseudo_masked_store_i64(uniform int64 *ptr, varying int64 values, mask)
;  void __pseudo_masked_store_double(uniform double *ptr, varying double values, mask)
;
;  These in turn are converted to native masked stores or to regular
;  stores (if the mask is all on) by the MaskedStoreOptPass optimization
;  pass.

declare void @__pseudo_masked_store_i8(<16 x i8> * nocapture, <16 x i8>, <16 x i8>)
declare void @__pseudo_masked_store_i16(<16 x i16> * nocapture, <16 x i16>, <16 x i8>)
declare void @__pseudo_masked_store_i32(<16 x i32> * nocapture, <16 x i32>, <16 x i8>)
declare void @__pseudo_masked_store_float(<16 x float> * nocapture, <16 x float>, <16 x i8>)
declare void @__pseudo_masked_store_i64(<16 x i64> * nocapture, <16 x i64>, <16 x i8>)
declare void @__pseudo_masked_store_double(<16 x double> * nocapture, <16 x double>, <16 x i8>)

; Declare the pseudo-gather functions.  When the ispc front-end needs
; to perform a gather, it generates a call to one of these functions,
; which ideally have these signatures:
;    
; varying int8  __pseudo_gather_i8(varying int8 *, mask)
; varying int16 __pseudo_gather_i16(varying int16 *, mask)
; varying int32 __pseudo_gather_i32(varying int32 *, mask)
; varying float __pseudo_gather_float(varying float *, mask)
; varying int64 __pseudo_gather_i64(varying int64 *, mask)
; varying double __pseudo_gather_double(varying double *, mask)
;
; However, vectors of pointers weren not legal in LLVM until recently, so
; instead, it emits calls to functions that either take vectors of int32s
; or int64s, depending on the compilation target.

declare <16 x i8>  @__pseudo_gather32_i8(<16 x i32>, <16 x i8>) nounwind readonly
declare <16 x i16> @__pseudo_gather32_i16(<16 x i32>, <16 x i8>) nounwind readonly
declare <16 x i32> @__pseudo_gather32_i32(<16 x i32>, <16 x i8>) nounwind readonly
declare <16 x float> @__pseudo_gather32_float(<16 x i32>, <16 x i8>) nounwind readonly
declare <16 x i64> @__pseudo_gather32_i64(<16 x i32>, <16 x i8>) nounwind readonly
declare <16 x double> @__pseudo_gather32_double(<16 x i32>, <16 x i8>) nounwind readonly

declare <16 x i8>  @__pseudo_gather64_i8(<16 x i64>, <16 x i8>) nounwind readonly
declare <16 x i16> @__pseudo_gather64_i16(<16 x i64>, <16 x i8>) nounwind readonly
declare <16 x i32> @__pseudo_gather64_i32(<16 x i64>, <16 x i8>) nounwind readonly
declare <16 x float> @__pseudo_gather64_float(<16 x i64>, <16 x i8>) nounwind readonly
declare <16 x i64> @__pseudo_gather64_i64(<16 x i64>, <16 x i8>) nounwind readonly
declare <16 x double> @__pseudo_gather64_double(<16 x i64>, <16 x i8>) nounwind readonly

; The ImproveMemoryOps optimization pass finds these calls and then 
; tries to convert them to be calls to gather functions that take a uniform
; base pointer and then a varying integer offset, when possible.
;
; For targets without a native gather instruction, it is best to factor the
; integer offsets like "{1/2/4/8} * varying_offset + constant_offset",
; where varying_offset includes non-compile time constant values, and
; constant_offset includes compile-time constant values.  (The scalar loads
; generated in turn can then take advantage of the free offsetting and scale by
; 1/2/4/8 that is offered by the x86 addresisng modes.)
;
; varying int{8,16,32,float,64,double}
; __pseudo_gather_factored_base_offsets{32,64}_{i8,i16,i32,float,i64,double}(uniform int8 *base,
;                                    int{32,64} offsets, uniform int32 offset_scale, 
;                                    int{32,64} offset_delta, mask)
;
; For targets with a gather instruction, it is better to just factor them into
; a gather from a uniform base pointer and then "{1/2/4/8} * offsets", where the
; offsets are int32/64 vectors.
;
; varying int{8,16,32,float,64,double}
; __pseudo_gather_base_offsets{32,64}_{i8,i16,i32,float,i64,double}(uniform int8 *base,
;                                    uniform int32 offset_scale, int{32,64} offsets, mask)


declare <16 x i8>
@__pseudo_gather_factored_base_offsets32_i8(i8 *, <16 x i32>, i32, <16 x i32>,
                                            <16 x i8>) nounwind readonly
declare <16 x i16>
@__pseudo_gather_factored_base_offsets32_i16(i8 *, <16 x i32>, i32, <16 x i32>,
                                             <16 x i8>) nounwind readonly
declare <16 x i32>
@__pseudo_gather_factored_base_offsets32_i32(i8 *, <16 x i32>, i32, <16 x i32>,
                                             <16 x i8>) nounwind readonly
declare <16 x float>
@__pseudo_gather_factored_base_offsets32_float(i8 *, <16 x i32>, i32, <16 x i32>,
                                               <16 x i8>) nounwind readonly
declare <16 x i64>
@__pseudo_gather_factored_base_offsets32_i64(i8 *, <16 x i32>, i32, <16 x i32>,
                                             <16 x i8>) nounwind readonly
declare <16 x double>
@__pseudo_gather_factored_base_offsets32_double(i8 *, <16 x i32>, i32, <16 x i32>,
                                                <16 x i8>) nounwind readonly

declare <16 x i8>
@__pseudo_gather_factored_base_offsets64_i8(i8 *, <16 x i64>, i32, <16 x i64>,
                                            <16 x i8>) nounwind readonly
declare <16 x i16>
@__pseudo_gather_factored_base_offsets64_i16(i8 *, <16 x i64>, i32, <16 x i64>,
                                             <16 x i8>) nounwind readonly
declare <16 x i32>
@__pseudo_gather_factored_base_offsets64_i32(i8 *, <16 x i64>, i32, <16 x i64>,
                                             <16 x i8>) nounwind readonly
declare <16 x float>
@__pseudo_gather_factored_base_offsets64_float(i8 *, <16 x i64>, i32, <16 x i64>,
                                               <16 x i8>) nounwind readonly
declare <16 x i64>
@__pseudo_gather_factored_base_offsets64_i64(i8 *, <16 x i64>, i32, <16 x i64>,
                                             <16 x i8>) nounwind readonly
declare <16 x double>
@__pseudo_gather_factored_base_offsets64_double(i8 *, <16 x i64>, i32, <16 x i64>,
                                                <16 x i8>) nounwind readonly

declare <16 x i8>
@__pseudo_gather_base_offsets32_i8(i8 *, i32, <16 x i32>,
                                   <16 x i8>) nounwind readonly
declare <16 x i16>
@__pseudo_gather_base_offsets32_i16(i8 *, i32, <16 x i32>,
                                    <16 x i8>) nounwind readonly
declare <16 x i32>
@__pseudo_gather_base_offsets32_i32(i8 *, i32, <16 x i32>,
                                    <16 x i8>) nounwind readonly
declare <16 x float>
@__pseudo_gather_base_offsets32_float(i8 *, i32, <16 x i32>,
                                      <16 x i8>) nounwind readonly
declare <16 x i64>
@__pseudo_gather_base_offsets32_i64(i8 *, i32, <16 x i32>,
                                    <16 x i8>) nounwind readonly
declare <16 x double>
@__pseudo_gather_base_offsets32_double(i8 *, i32, <16 x i32>,
                                       <16 x i8>) nounwind readonly

declare <16 x i8>
@__pseudo_gather_base_offsets64_i8(i8 *, i32, <16 x i64>,
                                   <16 x i8>) nounwind readonly
declare <16 x i16>
@__pseudo_gather_base_offsets64_i16(i8 *, i32, <16 x i64>,
                                    <16 x i8>) nounwind readonly
declare <16 x i32>
@__pseudo_gather_base_offsets64_i32(i8 *, i32, <16 x i64>,
                                    <16 x i8>) nounwind readonly
declare <16 x float>
@__pseudo_gather_base_offsets64_float(i8 *, i32, <16 x i64>,
                                      <16 x i8>) nounwind readonly
declare <16 x i64>
@__pseudo_gather_base_offsets64_i64(i8 *, i32, <16 x i64>,
                                    <16 x i8>) nounwind readonly
declare <16 x double>
@__pseudo_gather_base_offsets64_double(i8 *, i32, <16 x i64>,
                                       <16 x i8>) nounwind readonly

; Similarly to the pseudo-gathers defined above, we also declare undefined
; pseudo-scatter instructions with signatures:
;
; void __pseudo_scatter_i8 (varying int8 *, varying int8 values, mask)
; void __pseudo_scatter_i16(varying int16 *, varying int16 values, mask)
; void __pseudo_scatter_i32(varying int32 *, varying int32 values, mask)
; void __pseudo_scatter_float(varying float *, varying float values, mask)
; void __pseudo_scatter_i64(varying int64 *, varying int64 values, mask)
; void __pseudo_scatter_double(varying double *, varying double values, mask)
;

declare void @__pseudo_scatter32_i8(<16 x i32>, <16 x i8>, <16 x i8>) nounwind
declare void @__pseudo_scatter32_i16(<16 x i32>, <16 x i16>, <16 x i8>) nounwind
declare void @__pseudo_scatter32_i32(<16 x i32>, <16 x i32>, <16 x i8>) nounwind
declare void @__pseudo_scatter32_float(<16 x i32>, <16 x float>, <16 x i8>) nounwind
declare void @__pseudo_scatter32_i64(<16 x i32>, <16 x i64>, <16 x i8>) nounwind
declare void @__pseudo_scatter32_double(<16 x i32>, <16 x double>, <16 x i8>) nounwind

declare void @__pseudo_scatter64_i8(<16 x i64>, <16 x i8>, <16 x i8>) nounwind
declare void @__pseudo_scatter64_i16(<16 x i64>, <16 x i16>, <16 x i8>) nounwind
declare void @__pseudo_scatter64_i32(<16 x i64>, <16 x i32>, <16 x i8>) nounwind
declare void @__pseudo_scatter64_float(<16 x i64>, <16 x float>, <16 x i8>) nounwind
declare void @__pseudo_scatter64_i64(<16 x i64>, <16 x i64>, <16 x i8>) nounwind
declare void @__pseudo_scatter64_double(<16 x i64>, <16 x double>, <16 x i8>) nounwind

; And the ImproveMemoryOps optimization pass also finds these and
; either transforms them to scatters like:
;
; void __pseudo_scatter_factored_base_offsets{32,64}_i8(uniform int8 *base, 
;             varying int32 offsets, uniform int32 offset_scale, 
;             varying int{32,64} offset_delta, varying int8 values, mask)
; (and similarly for 16/32/64 bit values)
;
; Or, if the target has a native scatter instruction:
;
; void __pseudo_scatter_base_offsets{32,64}_i8(uniform int8 *base, 
;             uniform int32 offset_scale, varying int{32,64} offsets,
;             varying int8 values, mask)
; (and similarly for 16/32/64 bit values)

declare void
@__pseudo_scatter_factored_base_offsets32_i8(i8 * nocapture, <16 x i32>, i32, <16 x i32>,
                                             <16 x i8>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets32_i16(i8 * nocapture, <16 x i32>, i32, <16 x i32>,
                                              <16 x i16>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets32_i32(i8 * nocapture, <16 x i32>, i32, <16 x i32>,
                                              <16 x i32>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets32_float(i8 * nocapture, <16 x i32>, i32, <16 x i32>,
                                                <16 x float>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets32_i64(i8 * nocapture, <16 x i32>, i32, <16 x i32>,
                                              <16 x i64>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets32_double(i8 * nocapture, <16 x i32>, i32, <16 x i32>,
                                                 <16 x double>, <16 x i8>) nounwind

declare void
@__pseudo_scatter_factored_base_offsets64_i8(i8 * nocapture, <16 x i64>, i32, <16 x i64>,
                                             <16 x i8>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets64_i16(i8 * nocapture, <16 x i64>, i32, <16 x i64>,
                                              <16 x i16>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets64_i32(i8 * nocapture, <16 x i64>, i32, <16 x i64>,
                                              <16 x i32>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets64_float(i8 * nocapture, <16 x i64>, i32, <16 x i64>,
                                                <16 x float>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets64_i64(i8 * nocapture, <16 x i64>, i32, <16 x i64>,
                                              <16 x i64>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_factored_base_offsets64_double(i8 * nocapture, <16 x i64>, i32, <16 x i64>,
                                                 <16 x double>, <16 x i8>) nounwind

declare void
@__pseudo_scatter_base_offsets32_i8(i8 * nocapture, i32, <16 x i32>,
                                    <16 x i8>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets32_i16(i8 * nocapture, i32, <16 x i32>,
                                     <16 x i16>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets32_i32(i8 * nocapture, i32, <16 x i32>,
                                     <16 x i32>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets32_float(i8 * nocapture, i32, <16 x i32>,
                                       <16 x float>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets32_i64(i8 * nocapture, i32, <16 x i32>,
                                     <16 x i64>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets32_double(i8 * nocapture, i32, <16 x i32>,
                                        <16 x double>, <16 x i8>) nounwind

declare void
@__pseudo_scatter_base_offsets64_i8(i8 * nocapture, i32, <16 x i64>,
                                    <16 x i8>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets64_i16(i8 * nocapture, i32, <16 x i64>,
                                     <16 x i16>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets64_i32(i8 * nocapture, i32, <16 x i64>,
                                     <16 x i32>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets64_float(i8 * nocapture, i32, <16 x i64>,
                                       <16 x float>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets64_i64(i8 * nocapture, i32, <16 x i64>,
                                     <16 x i64>, <16 x i8>) nounwind
declare void
@__pseudo_scatter_base_offsets64_double(i8 * nocapture, i32, <16 x i64>,
                                        <16 x double>, <16 x i8>) nounwind


declare void @__pseudo_prefetch_read_varying_1(<16 x i64>, <16 x i8>) nounwind

declare void
@__pseudo_prefetch_read_varying_1_native(i8 *, i32, <16 x i32>,
                                         <16 x i8>) nounwind

declare void @__pseudo_prefetch_read_varying_2(<16 x i64>, <16 x i8>) nounwind

declare void
@__pseudo_prefetch_read_varying_2_native(i8 *, i32, <16 x i32>,
                                         <16 x i8>) nounwind

declare void @__pseudo_prefetch_read_varying_3(<16 x i64>, <16 x i8>) nounwind

declare void
@__pseudo_prefetch_read_varying_3_native(i8 *, i32, <16 x i32>,
                                         <16 x i8>) nounwind

declare void @__pseudo_prefetch_read_varying_nt(<16 x i64>, <16 x i8>) nounwind

declare void
@__pseudo_prefetch_read_varying_nt_native(i8 *, i32, <16 x i32>,
                                         <16 x i8>) nounwind

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

declare void @__use8(<16 x i8>)
declare void @__use16(<16 x i16>)
declare void @__use32(<16 x i32>)
declare void @__usefloat(<16 x float>)
declare void @__use64(<16 x i64>)
declare void @__usedouble(<16 x double>)

;; This is a temporary function that will be removed at the end of
;; compilation--the idea is that it calls out to all of the various
;; functions / pseudo-function declarations that we need to keep around
;; so that they are available to the various optimization passes.  This
;; then prevents those functions from being removed as dead code when
;; we do early DCE...

define void @__keep_funcs_live(i8 * %ptr, <16 x i8> %v8, <16 x i16> %v16,
                               <16 x i32> %v32, <16 x i64> %v64,
                               <16 x i8> %mask) noinline optnone {
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; loads
  %ml8  = call <16 x i8>  @__masked_load_i8(i8 * %ptr, <16 x i8> %mask)
  call void @__use8(<16 x i8> %ml8)
  %ml16 = call <16 x i16> @__masked_load_i16(i8 * %ptr, <16 x i8> %mask)
  call void @__use16(<16 x i16> %ml16)
  %ml32 = call <16 x i32> @__masked_load_i32(i8 * %ptr, <16 x i8> %mask)
  call void @__use32(<16 x i32> %ml32)
  %mlf = call <16 x float> @__masked_load_float(i8 * %ptr, <16 x i8> %mask)
  call void @__usefloat(<16 x float> %mlf)
  %ml64 = call <16 x i64> @__masked_load_i64(i8 * %ptr, <16 x i8> %mask)
  call void @__use64(<16 x i64> %ml64)
  %mld = call <16 x double> @__masked_load_double(i8 * %ptr, <16 x i8> %mask)
  call void @__usedouble(<16 x double> %mld)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; stores
  %pv8 = bitcast i8 * %ptr to <16 x i8> *
  call void @__pseudo_masked_store_i8(<16 x i8> * %pv8, <16 x i8> %v8,
                                      <16 x i8> %mask)
  %pv16 = bitcast i8 * %ptr to <16 x i16> *
  call void @__pseudo_masked_store_i16(<16 x i16> * %pv16, <16 x i16> %v16,
                                       <16 x i8> %mask)
  %pv32 = bitcast i8 * %ptr to <16 x i32> *
  call void @__pseudo_masked_store_i32(<16 x i32> * %pv32, <16 x i32> %v32,
                                       <16 x i8> %mask)
  %vf = bitcast <16 x i32> %v32 to <16 x float>
  %pvf = bitcast i8 * %ptr to <16 x float> *
  call void @__pseudo_masked_store_float(<16 x float> * %pvf, <16 x float> %vf,
                                         <16 x i8> %mask)
  %pv64 = bitcast i8 * %ptr to <16 x i64> *
  call void @__pseudo_masked_store_i64(<16 x i64> * %pv64, <16 x i64> %v64,
                                       <16 x i8> %mask)
  %vd = bitcast <16 x i64> %v64 to <16 x double>
  %pvd = bitcast i8 * %ptr to <16 x double> *
  call void @__pseudo_masked_store_double(<16 x double> * %pvd, <16 x double> %vd,
                                         <16 x i8> %mask)

  call void @__masked_store_i8(<16 x i8> * %pv8, <16 x i8> %v8, <16 x i8> %mask)
  call void @__masked_store_i16(<16 x i16> * %pv16, <16 x i16> %v16, <16 x i8> %mask)
  call void @__masked_store_i32(<16 x i32> * %pv32, <16 x i32> %v32, <16 x i8> %mask)
  call void @__masked_store_float(<16 x float> * %pvf, <16 x float> %vf, <16 x i8> %mask)
  call void @__masked_store_i64(<16 x i64> * %pv64, <16 x i64> %v64, <16 x i8> %mask)
  call void @__masked_store_double(<16 x double> * %pvd, <16 x double> %vd, <16 x i8> %mask)

  call void @__masked_store_blend_i8(<16 x i8> * %pv8, <16 x i8> %v8,
                                     <16 x i8> %mask)
  call void @__masked_store_blend_i16(<16 x i16> * %pv16, <16 x i16> %v16,
                                      <16 x i8> %mask)
  call void @__masked_store_blend_i32(<16 x i32> * %pv32, <16 x i32> %v32,
                                      <16 x i8> %mask)
  call void @__masked_store_blend_float(<16 x float> * %pvf, <16 x float> %vf,
                                        <16 x i8> %mask)
  call void @__masked_store_blend_i64(<16 x i64> * %pv64, <16 x i64> %v64,
                                      <16 x i8> %mask)
  call void @__masked_store_blend_double(<16 x double> * %pvd, <16 x double> %vd,
                                         <16 x i8> %mask)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; gathers

  %pg32_8 = call <16 x i8>  @__pseudo_gather32_i8(<16 x i32> %v32,
                                                     <16 x i8> %mask)
  call void @__use8(<16 x i8> %pg32_8)
  %pg32_16 = call <16 x i16>  @__pseudo_gather32_i16(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__use16(<16 x i16> %pg32_16)
  %pg32_32 = call <16 x i32>  @__pseudo_gather32_i32(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__use32(<16 x i32> %pg32_32)
  %pg32_f = call <16 x float>  @__pseudo_gather32_float(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__usefloat(<16 x float> %pg32_f)
  %pg32_64 = call <16 x i64>  @__pseudo_gather32_i64(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__use64(<16 x i64> %pg32_64)
  %pg32_d = call <16 x double>  @__pseudo_gather32_double(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__usedouble(<16 x double> %pg32_d)

  %pg64_8 = call <16 x i8>  @__pseudo_gather64_i8(<16 x i64> %v64,
                                                     <16 x i8> %mask)
  call void @__use8(<16 x i8> %pg64_8)
  %pg64_16 = call <16 x i16>  @__pseudo_gather64_i16(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__use16(<16 x i16> %pg64_16)
  %pg64_32 = call <16 x i32>  @__pseudo_gather64_i32(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__use32(<16 x i32> %pg64_32)
  %pg64_f = call <16 x float>  @__pseudo_gather64_float(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__usefloat(<16 x float> %pg64_f)
  %pg64_64 = call <16 x i64>  @__pseudo_gather64_i64(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__use64(<16 x i64> %pg64_64)
  %pg64_d = call <16 x double>  @__pseudo_gather64_double(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__usedouble(<16 x double> %pg64_d)

  %g32_8 = call <16 x i8>  @__gather32_i8(<16 x i32> %v32,
                                                     <16 x i8> %mask)
  call void @__use8(<16 x i8> %g32_8)
  %g32_16 = call <16 x i16>  @__gather32_i16(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__use16(<16 x i16> %g32_16)
  %g32_32 = call <16 x i32>  @__gather32_i32(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__use32(<16 x i32> %g32_32)
  %g32_f = call <16 x float>  @__gather32_float(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__usefloat(<16 x float> %g32_f)
  %g32_64 = call <16 x i64>  @__gather32_i64(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__use64(<16 x i64> %g32_64)
  %g32_d = call <16 x double>  @__gather32_double(<16 x i32> %v32,
                                                        <16 x i8> %mask)
  call void @__usedouble(<16 x double> %g32_d)

  %g64_8 = call <16 x i8>  @__gather64_i8(<16 x i64> %v64,
                                                     <16 x i8> %mask)
  call void @__use8(<16 x i8> %g64_8)
  %g64_16 = call <16 x i16>  @__gather64_i16(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__use16(<16 x i16> %g64_16)
  %g64_32 = call <16 x i32>  @__gather64_i32(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__use32(<16 x i32> %g64_32)
  %g64_f = call <16 x float>  @__gather64_float(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__usefloat(<16 x float> %g64_f)
  %g64_64 = call <16 x i64>  @__gather64_i64(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__use64(<16 x i64> %g64_64)
  %g64_d = call <16 x double>  @__gather64_double(<16 x i64> %v64,
                                                        <16 x i8> %mask)
  call void @__usedouble(<16 x double> %g64_d)


  %pgbo32_8 = call <16 x i8>
       @__pseudo_gather_factored_base_offsets32_i8(i8 * %ptr, <16 x i32> %v32, i32 0,
                                          <16 x i32> %v32, <16 x i8> %mask)
  call void @__use8(<16 x i8> %pgbo32_8)
  %pgbo32_16 = call <16 x i16>
       @__pseudo_gather_factored_base_offsets32_i16(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__use16(<16 x i16> %pgbo32_16)
  %pgbo32_32 = call <16 x i32>
       @__pseudo_gather_factored_base_offsets32_i32(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__use32(<16 x i32> %pgbo32_32)
  %pgbo32_f = call <16 x float>
       @__pseudo_gather_factored_base_offsets32_float(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__usefloat(<16 x float> %pgbo32_f)
  %pgbo32_64 = call <16 x i64>
       @__pseudo_gather_factored_base_offsets32_i64(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__use64(<16 x i64> %pgbo32_64)
  %pgbo32_d = call <16 x double>
       @__pseudo_gather_factored_base_offsets32_double(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__usedouble(<16 x double> %pgbo32_d)

  %pgbo64_8 = call <16 x i8>
       @__pseudo_gather_factored_base_offsets64_i8(i8 * %ptr, <16 x i64> %v64, i32 0,
                                          <16 x i64> %v64, <16 x i8> %mask)
  call void @__use8(<16 x i8> %pgbo64_8)
  %pgbo64_16 = call <16 x i16>
       @__pseudo_gather_factored_base_offsets64_i16(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__use16(<16 x i16> %pgbo64_16)
  %pgbo64_32 = call <16 x i32>
       @__pseudo_gather_factored_base_offsets64_i32(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__use32(<16 x i32> %pgbo64_32)
  %pgbo64_f = call <16 x float>
       @__pseudo_gather_factored_base_offsets64_float(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__usefloat(<16 x float> %pgbo64_f)
  %pgbo64_64 = call <16 x i64>
       @__pseudo_gather_factored_base_offsets64_i64(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__use64(<16 x i64> %pgbo64_64)
  %pgbo64_d = call <16 x double>
       @__pseudo_gather_factored_base_offsets64_double(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__usedouble(<16 x double> %pgbo64_d)

  %gbo32_8 = call <16 x i8>
       @__gather_factored_base_offsets32_i8(i8 * %ptr, <16 x i32> %v32, i32 0,
                                          <16 x i32> %v32, <16 x i8> %mask)
  call void @__use8(<16 x i8> %gbo32_8)
  %gbo32_16 = call <16 x i16>
       @__gather_factored_base_offsets32_i16(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__use16(<16 x i16> %gbo32_16)
  %gbo32_32 = call <16 x i32>
       @__gather_factored_base_offsets32_i32(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__use32(<16 x i32> %gbo32_32)
  %gbo32_f = call <16 x float>
       @__gather_factored_base_offsets32_float(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__usefloat(<16 x float> %gbo32_f)
  %gbo32_64 = call <16 x i64>
       @__gather_factored_base_offsets32_i64(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__use64(<16 x i64> %gbo32_64)
  %gbo32_d = call <16 x double>
       @__gather_factored_base_offsets32_double(i8 * %ptr, <16 x i32> %v32, i32 0,
                                           <16 x i32> %v32, <16 x i8> %mask)
  call void @__usedouble(<16 x double> %gbo32_d)

  %gbo64_8 = call <16 x i8>
       @__gather_factored_base_offsets64_i8(i8 * %ptr, <16 x i64> %v64, i32 0,
                                          <16 x i64> %v64, <16 x i8> %mask)
  call void @__use8(<16 x i8> %gbo64_8)
  %gbo64_16 = call <16 x i16>
       @__gather_factored_base_offsets64_i16(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__use16(<16 x i16> %gbo64_16)
  %gbo64_32 = call <16 x i32>
       @__gather_factored_base_offsets64_i32(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__use32(<16 x i32> %gbo64_32)
  %gbo64_f = call <16 x float>
       @__gather_factored_base_offsets64_float(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__usefloat(<16 x float> %gbo64_f)
  %gbo64_64 = call <16 x i64>
       @__gather_factored_base_offsets64_i64(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__use64(<16 x i64> %gbo64_64)
  %gbo64_d = call <16 x double>
       @__gather_factored_base_offsets64_double(i8 * %ptr, <16 x i64> %v64, i32 0,
                                           <16 x i64> %v64, <16 x i8> %mask)
  call void @__usedouble(<16 x double> %pgbo64_d)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; scatters

  call void @__pseudo_scatter32_i8(<16 x i32> %v32, <16 x i8> %v8, <16 x i8> %mask)
  call void @__pseudo_scatter32_i16(<16 x i32> %v32, <16 x i16> %v16, <16 x i8> %mask)
  call void @__pseudo_scatter32_i32(<16 x i32> %v32, <16 x i32> %v32, <16 x i8> %mask)
  call void @__pseudo_scatter32_float(<16 x i32> %v32, <16 x float> %vf, <16 x i8> %mask)
  call void @__pseudo_scatter32_i64(<16 x i32> %v32, <16 x i64> %v64, <16 x i8> %mask)
  call void @__pseudo_scatter32_double(<16 x i32> %v32, <16 x double> %vd, <16 x i8> %mask)

  call void @__pseudo_scatter64_i8(<16 x i64> %v64, <16 x i8> %v8, <16 x i8> %mask)
  call void @__pseudo_scatter64_i16(<16 x i64> %v64, <16 x i16> %v16, <16 x i8> %mask)
  call void @__pseudo_scatter64_i32(<16 x i64> %v64, <16 x i32> %v32, <16 x i8> %mask)
  call void @__pseudo_scatter64_float(<16 x i64> %v64, <16 x float> %vf, <16 x i8> %mask)
  call void @__pseudo_scatter64_i64(<16 x i64> %v64, <16 x i64> %v64, <16 x i8> %mask)
  call void @__pseudo_scatter64_double(<16 x i64> %v64, <16 x double> %vd, <16 x i8> %mask)

  call void @__scatter32_i8(<16 x i32> %v32, <16 x i8> %v8, <16 x i8> %mask)
  call void @__scatter32_i16(<16 x i32> %v32, <16 x i16> %v16, <16 x i8> %mask)
  call void @__scatter32_i32(<16 x i32> %v32, <16 x i32> %v32, <16 x i8> %mask)
  call void @__scatter32_float(<16 x i32> %v32, <16 x float> %vf, <16 x i8> %mask)
  call void @__scatter32_i64(<16 x i32> %v32, <16 x i64> %v64, <16 x i8> %mask)
  call void @__scatter32_double(<16 x i32> %v32, <16 x double> %vd, <16 x i8> %mask)

  call void @__scatter64_i8(<16 x i64> %v64, <16 x i8> %v8, <16 x i8> %mask)
  call void @__scatter64_i16(<16 x i64> %v64, <16 x i16> %v16, <16 x i8> %mask)
  call void @__scatter64_i32(<16 x i64> %v64, <16 x i32> %v32, <16 x i8> %mask)
  call void @__scatter64_float(<16 x i64> %v64, <16 x float> %vf, <16 x i8> %mask)
  call void @__scatter64_i64(<16 x i64> %v64, <16 x i64> %v64, <16 x i8> %mask)
  call void @__scatter64_double(<16 x i64> %v64, <16 x double> %vd, <16 x i8> %mask)


  call void @__pseudo_scatter_factored_base_offsets32_i8(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                <16 x i8> %v8, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets32_i16(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x i16> %v16, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets32_i32(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x i32> %v32, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets32_float(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x float> %vf, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets32_i64(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x i64> %v64, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets32_double(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                    <16 x double> %vd, <16 x i8> %mask)

  call void @__pseudo_scatter_factored_base_offsets64_i8(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                <16 x i8> %v8, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets64_i16(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                 <16 x i16> %v16, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets64_i32(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                 <16 x i32> %v32, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets64_float(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                   <16 x float> %vf, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets64_i64(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                 <16 x i64> %v64, <16 x i8> %mask)
  call void @__pseudo_scatter_factored_base_offsets64_double(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                    <16 x double> %vd, <16 x i8> %mask)

  call void @__scatter_factored_base_offsets32_i8(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                <16 x i8> %v8, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets32_i16(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x i16> %v16, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets32_i32(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x i32> %v32, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets32_float(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x float> %vf, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets32_i64(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                 <16 x i64> %v64, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets32_double(i8 * %ptr, <16 x i32> %v32, i32 0, <16 x i32> %v32,
                                                    <16 x double> %vd, <16 x i8> %mask)

  call void @__scatter_factored_base_offsets64_i8(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                <16 x i8> %v8, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets64_i16(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                 <16 x i16> %v16, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets64_i32(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                 <16 x i32> %v32, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets64_float(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                   <16 x float> %vf, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets64_i64(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                 <16 x i64> %v64, <16 x i8> %mask)
  call void @__scatter_factored_base_offsets64_double(i8 * %ptr, <16 x i64> %v64, i32 0, <16 x i64> %v64,
                                                    <16 x double> %vd, <16 x i8> %mask)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; prefetchs

  call void @__pseudo_prefetch_read_varying_1(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_1_native(i8 * %ptr, i32 0,
                                                     <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_1_native(i8 * %ptr, i32 0,
                                              <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_1(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_2(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_2_native(i8 * %ptr, i32 0,
                                                     <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_2_native(i8 * %ptr, i32 0,
                                              <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_2(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_3(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_3_native(i8 * %ptr, i32 0,
                                                     <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_3_native(i8 * %ptr, i32 0,
                                              <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_3(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_nt(<16 x i64> %v64, <16 x i8> %mask)

  call void @__pseudo_prefetch_read_varying_nt_native(i8 * %ptr, i32 0,
                                                     <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_nt_native(i8 * %ptr, i32 0,
                                              <16 x i32> %v32, <16 x i8> %mask)
  call void @__prefetch_read_varying_nt(<16 x i64> %v64, <16 x i8> %mask)

  ret void
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vector ops

define i1 @__extract_bool(<16 x i8>, i32) nounwind readnone alwaysinline {
  %extract = extractelement <16 x i8> %0, i32 %1
  %extractBool = trunc i8 %extract to i1
  ret i1 %extractBool
}

define <16 x i8> @__insert_bool(<16 x i8>, i32, 
                                   i1) nounwind readnone alwaysinline {
  %insertVal = sext i1 %2 to i8
  %insert = insertelement <16 x i8> %0, i8 %insertVal, i32 %1
  ret <16 x i8> %insert
}

define i8 @__extract_int8(<16 x i8>, i32) nounwind readnone alwaysinline {
  %extract = extractelement <16 x i8> %0, i32 %1
  ret i8 %extract
}

define <16 x i8> @__insert_int8(<16 x i8>, i32, 
                                   i8) nounwind readnone alwaysinline {
  %insert = insertelement <16 x i8> %0, i8 %2, i32 %1
  ret <16 x i8> %insert
}

define i16 @__extract_int16(<16 x i16>, i32) nounwind readnone alwaysinline {
  %extract = extractelement <16 x i16> %0, i32 %1
  ret i16 %extract
}

define <16 x i16> @__insert_int16(<16 x i16>, i32, 
                                     i16) nounwind readnone alwaysinline {
  %insert = insertelement <16 x i16> %0, i16 %2, i32 %1
  ret <16 x i16> %insert
}

define i32 @__extract_int32(<16 x i32>, i32) nounwind readnone alwaysinline {
  %extract = extractelement <16 x i32> %0, i32 %1
  ret i32 %extract
}

define <16 x i32> @__insert_int32(<16 x i32>, i32, 
                                     i32) nounwind readnone alwaysinline {
  %insert = insertelement <16 x i32> %0, i32 %2, i32 %1
  ret <16 x i32> %insert
}

define i64 @__extract_int64(<16 x i64>, i32) nounwind readnone alwaysinline {
  %extract = extractelement <16 x i64> %0, i32 %1
  ret i64 %extract
}

define <16 x i64> @__insert_int64(<16 x i64>, i32, 
                                     i64) nounwind readnone alwaysinline {
  %insert = insertelement <16 x i64> %0, i64 %2, i32 %1
  ret <16 x i64> %insert
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; various bitcasts from one type to another

define <16 x i32> @__intbits_varying_float(<16 x float>) nounwind readnone alwaysinline {
  %float_to_int_bitcast = bitcast <16 x float> %0 to <16 x i32>
  ret <16 x i32> %float_to_int_bitcast
}

define i32 @__intbits_uniform_float(float) nounwind readnone alwaysinline {
  %float_to_int_bitcast = bitcast float %0 to i32
  ret i32 %float_to_int_bitcast
}

define <16 x i64> @__intbits_varying_double(<16 x double>) nounwind readnone alwaysinline {
  %double_to_int_bitcast = bitcast <16 x double> %0 to <16 x i64>
  ret <16 x i64> %double_to_int_bitcast
}

define i64 @__intbits_uniform_double(double) nounwind readnone alwaysinline {
  %double_to_int_bitcast = bitcast double %0 to i64
  ret i64 %double_to_int_bitcast
}

define <16 x float> @__floatbits_varying_int32(<16 x i32>) nounwind readnone alwaysinline {
  %int_to_float_bitcast = bitcast <16 x i32> %0 to <16 x float>
  ret <16 x float> %int_to_float_bitcast
}

define float @__floatbits_uniform_int32(i32) nounwind readnone alwaysinline {
  %int_to_float_bitcast = bitcast i32 %0 to float
  ret float %int_to_float_bitcast
}

define <16 x double> @__doublebits_varying_int64(<16 x i64>) nounwind readnone alwaysinline {
  %int_to_double_bitcast = bitcast <16 x i64> %0 to <16 x double>
  ret <16 x double> %int_to_double_bitcast
}

define double @__doublebits_uniform_int64(i64) nounwind readnone alwaysinline {
  %int_to_double_bitcast = bitcast i64 %0 to double
  ret double %int_to_double_bitcast
}

define <16 x float> @__undef_varying() nounwind readnone alwaysinline {
  ret <16 x float> undef
}

define float @__undef_uniform() nounwind readnone alwaysinline {
  ret float undef
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sign extension

define i32 @__sext_uniform_bool(i1) nounwind readnone alwaysinline {
  %r = sext i1 %0 to i32
  ret i32 %r
}

define <16 x i32> @__sext_varying_bool(<16 x i8>) nounwind readnone alwaysinline {
;;  ;; %se = sext <16 x i8> %0 to <16 x i32>
;; ret <16 x i32> %se
  %se = sext <16 x i8> %0 to <16 x i32>
  ret <16 x i32> %se
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memcpy/memmove/memset

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* %dest, i8* %src,
                                        i32 %len, i32 %align, i1 %isvolatile)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest, i8* %src,
                                        i64 %len, i32 %align, i1 %isvolatile)

define void @__memcpy32(i8 * %dst, i8 * %src, i32 %len) alwaysinline {
    call void @llvm.memcpy.p0i8.p0i8.i32(i8 * %dst, i8 * %src, i32 %len, i32 0, i1 0)
    ret void
}

define void @__memcpy64(i8 * %dst, i8 * %src, i64 %len) alwaysinline {
    call void @llvm.memcpy.p0i8.p0i8.i64(i8 * %dst, i8 * %src, i64 %len, i32 0, i1 0)
    ret void
}

declare void @llvm.memmove.p0i8.p0i8.i32(i8* %dest, i8* %src,
                                         i32 %len, i32 %align, i1 %isvolatile)
declare void @llvm.memmove.p0i8.p0i8.i64(i8* %dest, i8* %src,
                                         i64 %len, i32 %align, i1 %isvolatile)

define void @__memmove32(i8 * %dst, i8 * %src, i32 %len) alwaysinline {
    call void @llvm.memmove.p0i8.p0i8.i32(i8 * %dst, i8 * %src, i32 %len, i32 0, i1 0)
    ret void
}

define void @__memmove64(i8 * %dst, i8 * %src, i64 %len) alwaysinline {
    call void @llvm.memmove.p0i8.p0i8.i64(i8 * %dst, i8 * %src, i64 %len, i32 0, i1 0)
    ret void
}


declare void @llvm.memset.p0i8.i32(i8* %dest, i8 %val, i32 %len, i32 %align,
                                   i1 %isvolatile)
declare void @llvm.memset.p0i8.i64(i8* %dest, i8 %val, i64 %len, i32 %align,
                                   i1 %isvolatile)

define void @__memset32(i8 * %dst, i8 %val, i32 %len) alwaysinline {
    call void @llvm.memset.p0i8.i32(i8 * %dst, i8 %val, i32 %len, i32 0, i1 0)
    ret void
}

define void @__memset64(i8 * %dst, i8 %val, i64 %len) alwaysinline {
    call void @llvm.memset.p0i8.i64(i8 * %dst, i8 %val, i64 %len, i32 0, i1 0)
    ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; assert

declare i32 @puts(i8*)
declare void @abort() noreturn

define void @__do_assert_uniform(i8 *%str, i1 %test, <16 x i8> %mask) {
  br i1 %test, label %ok, label %fail

fail:
  %call = call i32 @puts(i8* %str)
  call void @abort() noreturn
  unreachable

ok:
  ret void
}


define void @__do_assert_varying(i8 *%str, <16 x i8> %test,
                                 <16 x i8> %mask) {
  %nottest = xor <16 x i8> %test,
                 < i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1,  i8 -1 >
  %nottest_and_mask = and <16 x i8> %nottest, %mask
  %mm = call i64 @__movmsk(<16 x i8> %nottest_and_mask)
  %all_ok = icmp eq i64 %mm, 0
  br i1 %all_ok, label %ok, label %fail

fail:
  %call = call i32 @puts(i8* %str)
  call void @abort() noreturn
  unreachable

ok:
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; new/delete

;; Set of functions for 32 bit runtime.
;; They are different for Windows and Unix (Linux/MacOS),
;; on Windows we have to use _aligned_malloc/_aligned_free,
;; while on Unix we use posix_memalign/free
;;
;; Note that this should be really two different libraries for 32 and 64
;; environment and it should happen sooner or later



@memory_alignment = internal constant i32 64





;; Unix 64 bit environment.
;; Use: posix_memalign and free
;; Define:
;; - __new_uniform_64rt
;; - __new_varying32_64rt
;; - __new_varying64_64rt
;; - __delete_uniform_64rt
;; - __delete_varying_64rt

declare i32 @posix_memalign(i8**, i64, i64)
declare void @free(i8 *)

define noalias i8 * @__new_uniform_64rt(i64 %size) {
  %ptr = alloca i8*
  %alignment = load i32 , i32 *
  @memory_alignment
  %alignment64 = sext i32 %alignment to i64
  %call1 = call i32 @posix_memalign(i8** %ptr, i64 %alignment64, i64 %size)
  %ptr_val = load i8* , i8* *
 %ptr
  ret i8* %ptr_val
}

define <16 x i64> @__new_varying32_64rt(<16 x i32> %size, <16 x i8> %mask) {
  %ret = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %ret
  %ret64 = bitcast <16 x i64> * %ret to i64 *
  %alignment = load i32 , i32 *
  @memory_alignment
  %alignment64 = sext i32 %alignment to i64

  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
    %sz_0_ID = extractelement <16 x i32> %size, i32 0
    %sz64_0_ID = zext i32 %sz_0_ID to i64
    %store_0_ID = getelementptr i64 , i64 *
 %ret64, i32 0
    %ptr_0_ID = bitcast i64* %store_0_ID to i8**
    %call_0_ID = call i32 @posix_memalign(i8** %ptr_0_ID, i64 %alignment64, i64 %sz64_0_ID)
    %sz_1_ID = extractelement <16 x i32> %size, i32 1
    %sz64_1_ID = zext i32 %sz_1_ID to i64
    %store_1_ID = getelementptr i64 , i64 *
 %ret64, i32 1
    %ptr_1_ID = bitcast i64* %store_1_ID to i8**
    %call_1_ID = call i32 @posix_memalign(i8** %ptr_1_ID, i64 %alignment64, i64 %sz64_1_ID)
    %sz_2_ID = extractelement <16 x i32> %size, i32 2
    %sz64_2_ID = zext i32 %sz_2_ID to i64
    %store_2_ID = getelementptr i64 , i64 *
 %ret64, i32 2
    %ptr_2_ID = bitcast i64* %store_2_ID to i8**
    %call_2_ID = call i32 @posix_memalign(i8** %ptr_2_ID, i64 %alignment64, i64 %sz64_2_ID)
    %sz_3_ID = extractelement <16 x i32> %size, i32 3
    %sz64_3_ID = zext i32 %sz_3_ID to i64
    %store_3_ID = getelementptr i64 , i64 *
 %ret64, i32 3
    %ptr_3_ID = bitcast i64* %store_3_ID to i8**
    %call_3_ID = call i32 @posix_memalign(i8** %ptr_3_ID, i64 %alignment64, i64 %sz64_3_ID)
    %sz_4_ID = extractelement <16 x i32> %size, i32 4
    %sz64_4_ID = zext i32 %sz_4_ID to i64
    %store_4_ID = getelementptr i64 , i64 *
 %ret64, i32 4
    %ptr_4_ID = bitcast i64* %store_4_ID to i8**
    %call_4_ID = call i32 @posix_memalign(i8** %ptr_4_ID, i64 %alignment64, i64 %sz64_4_ID)
    %sz_5_ID = extractelement <16 x i32> %size, i32 5
    %sz64_5_ID = zext i32 %sz_5_ID to i64
    %store_5_ID = getelementptr i64 , i64 *
 %ret64, i32 5
    %ptr_5_ID = bitcast i64* %store_5_ID to i8**
    %call_5_ID = call i32 @posix_memalign(i8** %ptr_5_ID, i64 %alignment64, i64 %sz64_5_ID)
    %sz_6_ID = extractelement <16 x i32> %size, i32 6
    %sz64_6_ID = zext i32 %sz_6_ID to i64
    %store_6_ID = getelementptr i64 , i64 *
 %ret64, i32 6
    %ptr_6_ID = bitcast i64* %store_6_ID to i8**
    %call_6_ID = call i32 @posix_memalign(i8** %ptr_6_ID, i64 %alignment64, i64 %sz64_6_ID)
    %sz_7_ID = extractelement <16 x i32> %size, i32 7
    %sz64_7_ID = zext i32 %sz_7_ID to i64
    %store_7_ID = getelementptr i64 , i64 *
 %ret64, i32 7
    %ptr_7_ID = bitcast i64* %store_7_ID to i8**
    %call_7_ID = call i32 @posix_memalign(i8** %ptr_7_ID, i64 %alignment64, i64 %sz64_7_ID)
    %sz_8_ID = extractelement <16 x i32> %size, i32 8
    %sz64_8_ID = zext i32 %sz_8_ID to i64
    %store_8_ID = getelementptr i64 , i64 *
 %ret64, i32 8
    %ptr_8_ID = bitcast i64* %store_8_ID to i8**
    %call_8_ID = call i32 @posix_memalign(i8** %ptr_8_ID, i64 %alignment64, i64 %sz64_8_ID)
    %sz_9_ID = extractelement <16 x i32> %size, i32 9
    %sz64_9_ID = zext i32 %sz_9_ID to i64
    %store_9_ID = getelementptr i64 , i64 *
 %ret64, i32 9
    %ptr_9_ID = bitcast i64* %store_9_ID to i8**
    %call_9_ID = call i32 @posix_memalign(i8** %ptr_9_ID, i64 %alignment64, i64 %sz64_9_ID)
    %sz_10_ID = extractelement <16 x i32> %size, i32 10
    %sz64_10_ID = zext i32 %sz_10_ID to i64
    %store_10_ID = getelementptr i64 , i64 *
 %ret64, i32 10
    %ptr_10_ID = bitcast i64* %store_10_ID to i8**
    %call_10_ID = call i32 @posix_memalign(i8** %ptr_10_ID, i64 %alignment64, i64 %sz64_10_ID)
    %sz_11_ID = extractelement <16 x i32> %size, i32 11
    %sz64_11_ID = zext i32 %sz_11_ID to i64
    %store_11_ID = getelementptr i64 , i64 *
 %ret64, i32 11
    %ptr_11_ID = bitcast i64* %store_11_ID to i8**
    %call_11_ID = call i32 @posix_memalign(i8** %ptr_11_ID, i64 %alignment64, i64 %sz64_11_ID)
    %sz_12_ID = extractelement <16 x i32> %size, i32 12
    %sz64_12_ID = zext i32 %sz_12_ID to i64
    %store_12_ID = getelementptr i64 , i64 *
 %ret64, i32 12
    %ptr_12_ID = bitcast i64* %store_12_ID to i8**
    %call_12_ID = call i32 @posix_memalign(i8** %ptr_12_ID, i64 %alignment64, i64 %sz64_12_ID)
    %sz_13_ID = extractelement <16 x i32> %size, i32 13
    %sz64_13_ID = zext i32 %sz_13_ID to i64
    %store_13_ID = getelementptr i64 , i64 *
 %ret64, i32 13
    %ptr_13_ID = bitcast i64* %store_13_ID to i8**
    %call_13_ID = call i32 @posix_memalign(i8** %ptr_13_ID, i64 %alignment64, i64 %sz64_13_ID)
    %sz_14_ID = extractelement <16 x i32> %size, i32 14
    %sz64_14_ID = zext i32 %sz_14_ID to i64
    %store_14_ID = getelementptr i64 , i64 *
 %ret64, i32 14
    %ptr_14_ID = bitcast i64* %store_14_ID to i8**
    %call_14_ID = call i32 @posix_memalign(i8** %ptr_14_ID, i64 %alignment64, i64 %sz64_14_ID)
    %sz_15_ID = extractelement <16 x i32> %size, i32 15
    %sz64_15_ID = zext i32 %sz_15_ID to i64
    %store_15_ID = getelementptr i64 , i64 *
 %ret64, i32 15
    %ptr_15_ID = bitcast i64* %store_15_ID to i8**
    %call_15_ID = call i32 @posix_memalign(i8** %ptr_15_ID, i64 %alignment64, i64 %sz64_15_ID)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
    %sz__id = extractelement <16 x i32> %size, i32 %pl_lane
    %sz64__id = zext i32 %sz__id to i64
    %store__id = getelementptr i64 , i64 *
 %ret64, i32 %pl_lane
    %ptr__id = bitcast i64* %store__id to i8**
    %call__id = call i32 @posix_memalign(i8** %ptr__id, i64 %alignment64, i64 %sz64__id)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %r = load <16 x i64>  , <16 x i64>  *
  %ret
  ret <16 x i64> %r
}

define <16 x i64> @__new_varying64_64rt(<16 x i64> %size, <16 x i8> %mask) {
  %ret = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %ret
  %ret64 = bitcast <16 x i64> * %ret to i64 *
  %alignment = load i32 , i32 *
  @memory_alignment
  %alignment64 = sext i32 %alignment to i64

  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
    %sz64_0_ID = extractelement <16 x i64> %size, i32 0
    %store_0_ID = getelementptr i64 , i64 *
 %ret64, i32 0
    %ptr_0_ID = bitcast i64* %store_0_ID to i8**
    %call_0_ID = call i32 @posix_memalign(i8** %ptr_0_ID, i64 %alignment64, i64 %sz64_0_ID)
    %sz64_1_ID = extractelement <16 x i64> %size, i32 1
    %store_1_ID = getelementptr i64 , i64 *
 %ret64, i32 1
    %ptr_1_ID = bitcast i64* %store_1_ID to i8**
    %call_1_ID = call i32 @posix_memalign(i8** %ptr_1_ID, i64 %alignment64, i64 %sz64_1_ID)
    %sz64_2_ID = extractelement <16 x i64> %size, i32 2
    %store_2_ID = getelementptr i64 , i64 *
 %ret64, i32 2
    %ptr_2_ID = bitcast i64* %store_2_ID to i8**
    %call_2_ID = call i32 @posix_memalign(i8** %ptr_2_ID, i64 %alignment64, i64 %sz64_2_ID)
    %sz64_3_ID = extractelement <16 x i64> %size, i32 3
    %store_3_ID = getelementptr i64 , i64 *
 %ret64, i32 3
    %ptr_3_ID = bitcast i64* %store_3_ID to i8**
    %call_3_ID = call i32 @posix_memalign(i8** %ptr_3_ID, i64 %alignment64, i64 %sz64_3_ID)
    %sz64_4_ID = extractelement <16 x i64> %size, i32 4
    %store_4_ID = getelementptr i64 , i64 *
 %ret64, i32 4
    %ptr_4_ID = bitcast i64* %store_4_ID to i8**
    %call_4_ID = call i32 @posix_memalign(i8** %ptr_4_ID, i64 %alignment64, i64 %sz64_4_ID)
    %sz64_5_ID = extractelement <16 x i64> %size, i32 5
    %store_5_ID = getelementptr i64 , i64 *
 %ret64, i32 5
    %ptr_5_ID = bitcast i64* %store_5_ID to i8**
    %call_5_ID = call i32 @posix_memalign(i8** %ptr_5_ID, i64 %alignment64, i64 %sz64_5_ID)
    %sz64_6_ID = extractelement <16 x i64> %size, i32 6
    %store_6_ID = getelementptr i64 , i64 *
 %ret64, i32 6
    %ptr_6_ID = bitcast i64* %store_6_ID to i8**
    %call_6_ID = call i32 @posix_memalign(i8** %ptr_6_ID, i64 %alignment64, i64 %sz64_6_ID)
    %sz64_7_ID = extractelement <16 x i64> %size, i32 7
    %store_7_ID = getelementptr i64 , i64 *
 %ret64, i32 7
    %ptr_7_ID = bitcast i64* %store_7_ID to i8**
    %call_7_ID = call i32 @posix_memalign(i8** %ptr_7_ID, i64 %alignment64, i64 %sz64_7_ID)
    %sz64_8_ID = extractelement <16 x i64> %size, i32 8
    %store_8_ID = getelementptr i64 , i64 *
 %ret64, i32 8
    %ptr_8_ID = bitcast i64* %store_8_ID to i8**
    %call_8_ID = call i32 @posix_memalign(i8** %ptr_8_ID, i64 %alignment64, i64 %sz64_8_ID)
    %sz64_9_ID = extractelement <16 x i64> %size, i32 9
    %store_9_ID = getelementptr i64 , i64 *
 %ret64, i32 9
    %ptr_9_ID = bitcast i64* %store_9_ID to i8**
    %call_9_ID = call i32 @posix_memalign(i8** %ptr_9_ID, i64 %alignment64, i64 %sz64_9_ID)
    %sz64_10_ID = extractelement <16 x i64> %size, i32 10
    %store_10_ID = getelementptr i64 , i64 *
 %ret64, i32 10
    %ptr_10_ID = bitcast i64* %store_10_ID to i8**
    %call_10_ID = call i32 @posix_memalign(i8** %ptr_10_ID, i64 %alignment64, i64 %sz64_10_ID)
    %sz64_11_ID = extractelement <16 x i64> %size, i32 11
    %store_11_ID = getelementptr i64 , i64 *
 %ret64, i32 11
    %ptr_11_ID = bitcast i64* %store_11_ID to i8**
    %call_11_ID = call i32 @posix_memalign(i8** %ptr_11_ID, i64 %alignment64, i64 %sz64_11_ID)
    %sz64_12_ID = extractelement <16 x i64> %size, i32 12
    %store_12_ID = getelementptr i64 , i64 *
 %ret64, i32 12
    %ptr_12_ID = bitcast i64* %store_12_ID to i8**
    %call_12_ID = call i32 @posix_memalign(i8** %ptr_12_ID, i64 %alignment64, i64 %sz64_12_ID)
    %sz64_13_ID = extractelement <16 x i64> %size, i32 13
    %store_13_ID = getelementptr i64 , i64 *
 %ret64, i32 13
    %ptr_13_ID = bitcast i64* %store_13_ID to i8**
    %call_13_ID = call i32 @posix_memalign(i8** %ptr_13_ID, i64 %alignment64, i64 %sz64_13_ID)
    %sz64_14_ID = extractelement <16 x i64> %size, i32 14
    %store_14_ID = getelementptr i64 , i64 *
 %ret64, i32 14
    %ptr_14_ID = bitcast i64* %store_14_ID to i8**
    %call_14_ID = call i32 @posix_memalign(i8** %ptr_14_ID, i64 %alignment64, i64 %sz64_14_ID)
    %sz64_15_ID = extractelement <16 x i64> %size, i32 15
    %store_15_ID = getelementptr i64 , i64 *
 %ret64, i32 15
    %ptr_15_ID = bitcast i64* %store_15_ID to i8**
    %call_15_ID = call i32 @posix_memalign(i8** %ptr_15_ID, i64 %alignment64, i64 %sz64_15_ID)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
    %sz64__id = extractelement <16 x i64> %size, i32 %pl_lane
    %store__id = getelementptr i64 , i64 *
 %ret64, i32 %pl_lane
    %ptr__id = bitcast i64* %store__id to i8**
    %call__id = call i32 @posix_memalign(i8** %ptr__id, i64 %alignment64, i64 %sz64__id)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %r = load <16 x i64>  , <16 x i64>  *
  %ret
  ret <16 x i64> %r
}

define void @__delete_uniform_64rt(i8 * %ptr) {
  call void @free(i8 * %ptr)
  ret void
}

define void @__delete_varying_64rt(<16 x i64> %ptr, <16 x i8> %mask) {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      %iptr_0_ID = extractelement <16 x i64> %ptr, i32 0
      %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8 *
      call void @free(i8 * %ptr_0_ID)
  
      %iptr_1_ID = extractelement <16 x i64> %ptr, i32 1
      %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8 *
      call void @free(i8 * %ptr_1_ID)
  
      %iptr_2_ID = extractelement <16 x i64> %ptr, i32 2
      %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8 *
      call void @free(i8 * %ptr_2_ID)
  
      %iptr_3_ID = extractelement <16 x i64> %ptr, i32 3
      %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8 *
      call void @free(i8 * %ptr_3_ID)
  
      %iptr_4_ID = extractelement <16 x i64> %ptr, i32 4
      %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8 *
      call void @free(i8 * %ptr_4_ID)
  
      %iptr_5_ID = extractelement <16 x i64> %ptr, i32 5
      %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8 *
      call void @free(i8 * %ptr_5_ID)
  
      %iptr_6_ID = extractelement <16 x i64> %ptr, i32 6
      %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8 *
      call void @free(i8 * %ptr_6_ID)
  
      %iptr_7_ID = extractelement <16 x i64> %ptr, i32 7
      %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8 *
      call void @free(i8 * %ptr_7_ID)
  
      %iptr_8_ID = extractelement <16 x i64> %ptr, i32 8
      %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8 *
      call void @free(i8 * %ptr_8_ID)
  
      %iptr_9_ID = extractelement <16 x i64> %ptr, i32 9
      %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8 *
      call void @free(i8 * %ptr_9_ID)
  
      %iptr_10_ID = extractelement <16 x i64> %ptr, i32 10
      %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8 *
      call void @free(i8 * %ptr_10_ID)
  
      %iptr_11_ID = extractelement <16 x i64> %ptr, i32 11
      %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8 *
      call void @free(i8 * %ptr_11_ID)
  
      %iptr_12_ID = extractelement <16 x i64> %ptr, i32 12
      %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8 *
      call void @free(i8 * %ptr_12_ID)
  
      %iptr_13_ID = extractelement <16 x i64> %ptr, i32 13
      %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8 *
      call void @free(i8 * %ptr_13_ID)
  
      %iptr_14_ID = extractelement <16 x i64> %ptr, i32 14
      %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8 *
      call void @free(i8 * %ptr_14_ID)
  
      %iptr_15_ID = extractelement <16 x i64> %ptr, i32 15
      %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8 *
      call void @free(i8 * %ptr_15_ID)
  
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      %iptr__id = extractelement <16 x i64> %ptr, i32 %pl_lane
      %ptr__id = inttoptr i64 %iptr__id to i8 *
      call void @free(i8 * %ptr__id)
  
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; read hw clock

declare i64 @llvm.readcyclecounter()


define i64 @__clock() nounwind {
  %r = call i64 @llvm.readcyclecounter()
  ret i64 %r
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stdlib transcendentals
;;
;; These functions provide entrypoints that call out to the libm 
;; implementations of the transcendental functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

declare float @sinf(float) nounwind readnone
declare float @cosf(float) nounwind readnone
declare void @sincosf(float, float *, float *) nounwind 
declare float @asinf(float) nounwind readnone
declare float @acosf(float) nounwind readnone
declare float @tanf(float) nounwind readnone
declare float @atanf(float) nounwind readnone
declare float @atan2f(float, float) nounwind readnone
declare float @expf(float) nounwind readnone
declare float @logf(float) nounwind readnone
declare float @powf(float, float) nounwind readnone

define float @__stdlib_sinf(float) nounwind readnone alwaysinline {
  %r = call float @sinf(float %0)
  ret float %r
}

define float @__stdlib_cosf(float) nounwind readnone alwaysinline {
  %r = call float @cosf(float %0)
  ret float %r
}

define void @__stdlib_sincosf(float, float *, float *) nounwind alwaysinline {
  call void @sincosf(float %0, float *%1, float *%2)
  ret void
}

define float @__stdlib_asinf(float) nounwind readnone alwaysinline {
  %r = call float @asinf(float %0)
  ret float %r
}

define float @__stdlib_acosf(float) nounwind readnone alwaysinline {
  %r = call float @acosf(float %0)
  ret float %r
}

define float @__stdlib_tanf(float) nounwind readnone alwaysinline {
  %r = call float @tanf(float %0)
  ret float %r
}

define float @__stdlib_atanf(float) nounwind readnone alwaysinline {
  %r = call float @atanf(float %0)
  ret float %r
}

define float @__stdlib_atan2f(float, float) nounwind readnone alwaysinline {
  %r = call float @atan2f(float %0, float %1)
  ret float %r
}

define float @__stdlib_logf(float) nounwind readnone alwaysinline {
  %r = call float @logf(float %0)
  ret float %r
}

define float @__stdlib_expf(float) nounwind readnone alwaysinline {
  %r = call float @expf(float %0)
  ret float %r
}

define float @__stdlib_powf(float, float) nounwind readnone alwaysinline {
  %r = call float @powf(float %0, float %1)
  ret float %r
}

declare double @sin(double) nounwind readnone
declare double @asin(double) nounwind readnone
declare double @cos(double) nounwind readnone
declare void @sincos(double, double *, double *) nounwind 
declare double @tan(double) nounwind readnone
declare double @atan(double) nounwind readnone
declare double @atan2(double, double) nounwind readnone
declare double @exp(double) nounwind readnone
declare double @log(double) nounwind readnone
declare double @pow(double, double) nounwind readnone

define double @__stdlib_sin(double) nounwind readnone alwaysinline {
  %r = call double @sin(double %0)
  ret double %r
}

define double @__stdlib_asin(double) nounwind readnone alwaysinline {
  %r = call double @asin(double %0)
  ret double %r
}

define double @__stdlib_cos(double) nounwind readnone alwaysinline {
  %r = call double @cos(double %0)
  ret double %r
}

define void @__stdlib_sincos(double, double *, double *) nounwind alwaysinline {
  call void @sincos(double %0, double *%1, double *%2)
  ret void
}

define double @__stdlib_tan(double) nounwind readnone alwaysinline {
  %r = call double @tan(double %0)
  ret double %r
}

define double @__stdlib_atan(double) nounwind readnone alwaysinline {
  %r = call double @atan(double %0)
  ret double %r
}

define double @__stdlib_atan2(double, double) nounwind readnone alwaysinline {
  %r = call double @atan2(double %0, double %1)
  ret double %r
}

define double @__stdlib_log(double) nounwind readnone alwaysinline {
  %r = call double @log(double %0)
  ret double %r
}

define double @__stdlib_exp(double) nounwind readnone alwaysinline {
  %r = call double @exp(double %0)
  ret double %r
}

define double @__stdlib_pow(double, double) nounwind readnone alwaysinline {
  %r = call double @pow(double %0, double %1)
  ret double %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; atomics and memory barriers

define void @__memory_barrier() nounwind readnone alwaysinline {
  ;; see http://llvm.org/bugs/show_bug.cgi?id=2829.  It seems like we
  ;; only get an MFENCE on x86 if "device" is true, but IMHO we should
  ;; in the case where the first 4 args are true but it is false.
  ;; So we just always set that to true...
  ;; LLVM.MEMORY.BARRIER was deprecated from version 3.0
  ;; Replacing it with relevant instruction
  fence seq_cst
  ret void
}



define <16 x i32> @__atomic_add_int32_global(i32 * %ptr, <16 x i32> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i32> @convertmask_i8_i32_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i32> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i32 0 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i32> %mask, < i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1,  i32 -1 >
  %idoff = and <16 x i32> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i32> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i32> %valp, i32 0
  %eltvec0 = insertelement <16 x i32> undef, i32 0, i32 0

  
  %elt1 = extractelement <16 x i32> %valp, i32 1
  %red1 = add i32 %red0, %elt1
  %eltvec1 = insertelement <16 x i32> %eltvec0, i32 %red0, i32 1
  %elt2 = extractelement <16 x i32> %valp, i32 2
  %red2 = add i32 %red1, %elt2
  %eltvec2 = insertelement <16 x i32> %eltvec1, i32 %red1, i32 2
  %elt3 = extractelement <16 x i32> %valp, i32 3
  %red3 = add i32 %red2, %elt3
  %eltvec3 = insertelement <16 x i32> %eltvec2, i32 %red2, i32 3
  %elt4 = extractelement <16 x i32> %valp, i32 4
  %red4 = add i32 %red3, %elt4
  %eltvec4 = insertelement <16 x i32> %eltvec3, i32 %red3, i32 4
  %elt5 = extractelement <16 x i32> %valp, i32 5
  %red5 = add i32 %red4, %elt5
  %eltvec5 = insertelement <16 x i32> %eltvec4, i32 %red4, i32 5
  %elt6 = extractelement <16 x i32> %valp, i32 6
  %red6 = add i32 %red5, %elt6
  %eltvec6 = insertelement <16 x i32> %eltvec5, i32 %red5, i32 6
  %elt7 = extractelement <16 x i32> %valp, i32 7
  %red7 = add i32 %red6, %elt7
  %eltvec7 = insertelement <16 x i32> %eltvec6, i32 %red6, i32 7
  %elt8 = extractelement <16 x i32> %valp, i32 8
  %red8 = add i32 %red7, %elt8
  %eltvec8 = insertelement <16 x i32> %eltvec7, i32 %red7, i32 8
  %elt9 = extractelement <16 x i32> %valp, i32 9
  %red9 = add i32 %red8, %elt9
  %eltvec9 = insertelement <16 x i32> %eltvec8, i32 %red8, i32 9
  %elt10 = extractelement <16 x i32> %valp, i32 10
  %red10 = add i32 %red9, %elt10
  %eltvec10 = insertelement <16 x i32> %eltvec9, i32 %red9, i32 10
  %elt11 = extractelement <16 x i32> %valp, i32 11
  %red11 = add i32 %red10, %elt11
  %eltvec11 = insertelement <16 x i32> %eltvec10, i32 %red10, i32 11
  %elt12 = extractelement <16 x i32> %valp, i32 12
  %red12 = add i32 %red11, %elt12
  %eltvec12 = insertelement <16 x i32> %eltvec11, i32 %red11, i32 12
  %elt13 = extractelement <16 x i32> %valp, i32 13
  %red13 = add i32 %red12, %elt13
  %eltvec13 = insertelement <16 x i32> %eltvec12, i32 %red12, i32 13
  %elt14 = extractelement <16 x i32> %valp, i32 14
  %red14 = add i32 %red13, %elt14
  %eltvec14 = insertelement <16 x i32> %eltvec13, i32 %red13, i32 14
  %elt15 = extractelement <16 x i32> %valp, i32 15
  %red15 = add i32 %red14, %elt15
  %eltvec15 = insertelement <16 x i32> %eltvec14, i32 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw add i32 * %ptr, i32 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i32 %final0 to <1 x i32>
  %final_base = shufflevector <1 x i32> %finalv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = add <16 x i32> %final_base, %eltvec15

  ret <16 x i32> %r
}



define <16 x i32> @__atomic_sub_int32_global(i32 * %ptr, <16 x i32> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i32> @convertmask_i8_i32_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i32> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i32 0 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i32> %mask, < i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1,  i32 -1 >
  %idoff = and <16 x i32> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i32> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i32> %valp, i32 0
  %eltvec0 = insertelement <16 x i32> undef, i32 0, i32 0

  
  %elt1 = extractelement <16 x i32> %valp, i32 1
  %red1 = sub i32 %red0, %elt1
  %eltvec1 = insertelement <16 x i32> %eltvec0, i32 %red0, i32 1
  %elt2 = extractelement <16 x i32> %valp, i32 2
  %red2 = sub i32 %red1, %elt2
  %eltvec2 = insertelement <16 x i32> %eltvec1, i32 %red1, i32 2
  %elt3 = extractelement <16 x i32> %valp, i32 3
  %red3 = sub i32 %red2, %elt3
  %eltvec3 = insertelement <16 x i32> %eltvec2, i32 %red2, i32 3
  %elt4 = extractelement <16 x i32> %valp, i32 4
  %red4 = sub i32 %red3, %elt4
  %eltvec4 = insertelement <16 x i32> %eltvec3, i32 %red3, i32 4
  %elt5 = extractelement <16 x i32> %valp, i32 5
  %red5 = sub i32 %red4, %elt5
  %eltvec5 = insertelement <16 x i32> %eltvec4, i32 %red4, i32 5
  %elt6 = extractelement <16 x i32> %valp, i32 6
  %red6 = sub i32 %red5, %elt6
  %eltvec6 = insertelement <16 x i32> %eltvec5, i32 %red5, i32 6
  %elt7 = extractelement <16 x i32> %valp, i32 7
  %red7 = sub i32 %red6, %elt7
  %eltvec7 = insertelement <16 x i32> %eltvec6, i32 %red6, i32 7
  %elt8 = extractelement <16 x i32> %valp, i32 8
  %red8 = sub i32 %red7, %elt8
  %eltvec8 = insertelement <16 x i32> %eltvec7, i32 %red7, i32 8
  %elt9 = extractelement <16 x i32> %valp, i32 9
  %red9 = sub i32 %red8, %elt9
  %eltvec9 = insertelement <16 x i32> %eltvec8, i32 %red8, i32 9
  %elt10 = extractelement <16 x i32> %valp, i32 10
  %red10 = sub i32 %red9, %elt10
  %eltvec10 = insertelement <16 x i32> %eltvec9, i32 %red9, i32 10
  %elt11 = extractelement <16 x i32> %valp, i32 11
  %red11 = sub i32 %red10, %elt11
  %eltvec11 = insertelement <16 x i32> %eltvec10, i32 %red10, i32 11
  %elt12 = extractelement <16 x i32> %valp, i32 12
  %red12 = sub i32 %red11, %elt12
  %eltvec12 = insertelement <16 x i32> %eltvec11, i32 %red11, i32 12
  %elt13 = extractelement <16 x i32> %valp, i32 13
  %red13 = sub i32 %red12, %elt13
  %eltvec13 = insertelement <16 x i32> %eltvec12, i32 %red12, i32 13
  %elt14 = extractelement <16 x i32> %valp, i32 14
  %red14 = sub i32 %red13, %elt14
  %eltvec14 = insertelement <16 x i32> %eltvec13, i32 %red13, i32 14
  %elt15 = extractelement <16 x i32> %valp, i32 15
  %red15 = sub i32 %red14, %elt15
  %eltvec15 = insertelement <16 x i32> %eltvec14, i32 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw sub i32 * %ptr, i32 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i32 %final0 to <1 x i32>
  %final_base = shufflevector <1 x i32> %finalv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = sub <16 x i32> %final_base, %eltvec15

  ret <16 x i32> %r
}



define <16 x i32> @__atomic_and_int32_global(i32 * %ptr, <16 x i32> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i32> @convertmask_i8_i32_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i32> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i32 -1 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i32> %mask, < i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1,  i32 -1 >
  %idoff = and <16 x i32> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i32> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i32> %valp, i32 0
  %eltvec0 = insertelement <16 x i32> undef, i32 -1, i32 0

  
  %elt1 = extractelement <16 x i32> %valp, i32 1
  %red1 = and i32 %red0, %elt1
  %eltvec1 = insertelement <16 x i32> %eltvec0, i32 %red0, i32 1
  %elt2 = extractelement <16 x i32> %valp, i32 2
  %red2 = and i32 %red1, %elt2
  %eltvec2 = insertelement <16 x i32> %eltvec1, i32 %red1, i32 2
  %elt3 = extractelement <16 x i32> %valp, i32 3
  %red3 = and i32 %red2, %elt3
  %eltvec3 = insertelement <16 x i32> %eltvec2, i32 %red2, i32 3
  %elt4 = extractelement <16 x i32> %valp, i32 4
  %red4 = and i32 %red3, %elt4
  %eltvec4 = insertelement <16 x i32> %eltvec3, i32 %red3, i32 4
  %elt5 = extractelement <16 x i32> %valp, i32 5
  %red5 = and i32 %red4, %elt5
  %eltvec5 = insertelement <16 x i32> %eltvec4, i32 %red4, i32 5
  %elt6 = extractelement <16 x i32> %valp, i32 6
  %red6 = and i32 %red5, %elt6
  %eltvec6 = insertelement <16 x i32> %eltvec5, i32 %red5, i32 6
  %elt7 = extractelement <16 x i32> %valp, i32 7
  %red7 = and i32 %red6, %elt7
  %eltvec7 = insertelement <16 x i32> %eltvec6, i32 %red6, i32 7
  %elt8 = extractelement <16 x i32> %valp, i32 8
  %red8 = and i32 %red7, %elt8
  %eltvec8 = insertelement <16 x i32> %eltvec7, i32 %red7, i32 8
  %elt9 = extractelement <16 x i32> %valp, i32 9
  %red9 = and i32 %red8, %elt9
  %eltvec9 = insertelement <16 x i32> %eltvec8, i32 %red8, i32 9
  %elt10 = extractelement <16 x i32> %valp, i32 10
  %red10 = and i32 %red9, %elt10
  %eltvec10 = insertelement <16 x i32> %eltvec9, i32 %red9, i32 10
  %elt11 = extractelement <16 x i32> %valp, i32 11
  %red11 = and i32 %red10, %elt11
  %eltvec11 = insertelement <16 x i32> %eltvec10, i32 %red10, i32 11
  %elt12 = extractelement <16 x i32> %valp, i32 12
  %red12 = and i32 %red11, %elt12
  %eltvec12 = insertelement <16 x i32> %eltvec11, i32 %red11, i32 12
  %elt13 = extractelement <16 x i32> %valp, i32 13
  %red13 = and i32 %red12, %elt13
  %eltvec13 = insertelement <16 x i32> %eltvec12, i32 %red12, i32 13
  %elt14 = extractelement <16 x i32> %valp, i32 14
  %red14 = and i32 %red13, %elt14
  %eltvec14 = insertelement <16 x i32> %eltvec13, i32 %red13, i32 14
  %elt15 = extractelement <16 x i32> %valp, i32 15
  %red15 = and i32 %red14, %elt15
  %eltvec15 = insertelement <16 x i32> %eltvec14, i32 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw and i32 * %ptr, i32 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i32 %final0 to <1 x i32>
  %final_base = shufflevector <1 x i32> %finalv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = and <16 x i32> %final_base, %eltvec15

  ret <16 x i32> %r
}



define <16 x i32> @__atomic_or_int32_global(i32 * %ptr, <16 x i32> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i32> @convertmask_i8_i32_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i32> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i32 0 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i32> %mask, < i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1,  i32 -1 >
  %idoff = and <16 x i32> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i32> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i32> %valp, i32 0
  %eltvec0 = insertelement <16 x i32> undef, i32 0, i32 0

  
  %elt1 = extractelement <16 x i32> %valp, i32 1
  %red1 = or i32 %red0, %elt1
  %eltvec1 = insertelement <16 x i32> %eltvec0, i32 %red0, i32 1
  %elt2 = extractelement <16 x i32> %valp, i32 2
  %red2 = or i32 %red1, %elt2
  %eltvec2 = insertelement <16 x i32> %eltvec1, i32 %red1, i32 2
  %elt3 = extractelement <16 x i32> %valp, i32 3
  %red3 = or i32 %red2, %elt3
  %eltvec3 = insertelement <16 x i32> %eltvec2, i32 %red2, i32 3
  %elt4 = extractelement <16 x i32> %valp, i32 4
  %red4 = or i32 %red3, %elt4
  %eltvec4 = insertelement <16 x i32> %eltvec3, i32 %red3, i32 4
  %elt5 = extractelement <16 x i32> %valp, i32 5
  %red5 = or i32 %red4, %elt5
  %eltvec5 = insertelement <16 x i32> %eltvec4, i32 %red4, i32 5
  %elt6 = extractelement <16 x i32> %valp, i32 6
  %red6 = or i32 %red5, %elt6
  %eltvec6 = insertelement <16 x i32> %eltvec5, i32 %red5, i32 6
  %elt7 = extractelement <16 x i32> %valp, i32 7
  %red7 = or i32 %red6, %elt7
  %eltvec7 = insertelement <16 x i32> %eltvec6, i32 %red6, i32 7
  %elt8 = extractelement <16 x i32> %valp, i32 8
  %red8 = or i32 %red7, %elt8
  %eltvec8 = insertelement <16 x i32> %eltvec7, i32 %red7, i32 8
  %elt9 = extractelement <16 x i32> %valp, i32 9
  %red9 = or i32 %red8, %elt9
  %eltvec9 = insertelement <16 x i32> %eltvec8, i32 %red8, i32 9
  %elt10 = extractelement <16 x i32> %valp, i32 10
  %red10 = or i32 %red9, %elt10
  %eltvec10 = insertelement <16 x i32> %eltvec9, i32 %red9, i32 10
  %elt11 = extractelement <16 x i32> %valp, i32 11
  %red11 = or i32 %red10, %elt11
  %eltvec11 = insertelement <16 x i32> %eltvec10, i32 %red10, i32 11
  %elt12 = extractelement <16 x i32> %valp, i32 12
  %red12 = or i32 %red11, %elt12
  %eltvec12 = insertelement <16 x i32> %eltvec11, i32 %red11, i32 12
  %elt13 = extractelement <16 x i32> %valp, i32 13
  %red13 = or i32 %red12, %elt13
  %eltvec13 = insertelement <16 x i32> %eltvec12, i32 %red12, i32 13
  %elt14 = extractelement <16 x i32> %valp, i32 14
  %red14 = or i32 %red13, %elt14
  %eltvec14 = insertelement <16 x i32> %eltvec13, i32 %red13, i32 14
  %elt15 = extractelement <16 x i32> %valp, i32 15
  %red15 = or i32 %red14, %elt15
  %eltvec15 = insertelement <16 x i32> %eltvec14, i32 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw or i32 * %ptr, i32 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i32 %final0 to <1 x i32>
  %final_base = shufflevector <1 x i32> %finalv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = or <16 x i32> %final_base, %eltvec15

  ret <16 x i32> %r
}



define <16 x i32> @__atomic_xor_int32_global(i32 * %ptr, <16 x i32> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i32> @convertmask_i8_i32_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i32> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i32 0 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i32> %mask, < i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1,  i32 -1 >
  %idoff = and <16 x i32> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i32> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i32> %valp, i32 0
  %eltvec0 = insertelement <16 x i32> undef, i32 0, i32 0

  
  %elt1 = extractelement <16 x i32> %valp, i32 1
  %red1 = xor i32 %red0, %elt1
  %eltvec1 = insertelement <16 x i32> %eltvec0, i32 %red0, i32 1
  %elt2 = extractelement <16 x i32> %valp, i32 2
  %red2 = xor i32 %red1, %elt2
  %eltvec2 = insertelement <16 x i32> %eltvec1, i32 %red1, i32 2
  %elt3 = extractelement <16 x i32> %valp, i32 3
  %red3 = xor i32 %red2, %elt3
  %eltvec3 = insertelement <16 x i32> %eltvec2, i32 %red2, i32 3
  %elt4 = extractelement <16 x i32> %valp, i32 4
  %red4 = xor i32 %red3, %elt4
  %eltvec4 = insertelement <16 x i32> %eltvec3, i32 %red3, i32 4
  %elt5 = extractelement <16 x i32> %valp, i32 5
  %red5 = xor i32 %red4, %elt5
  %eltvec5 = insertelement <16 x i32> %eltvec4, i32 %red4, i32 5
  %elt6 = extractelement <16 x i32> %valp, i32 6
  %red6 = xor i32 %red5, %elt6
  %eltvec6 = insertelement <16 x i32> %eltvec5, i32 %red5, i32 6
  %elt7 = extractelement <16 x i32> %valp, i32 7
  %red7 = xor i32 %red6, %elt7
  %eltvec7 = insertelement <16 x i32> %eltvec6, i32 %red6, i32 7
  %elt8 = extractelement <16 x i32> %valp, i32 8
  %red8 = xor i32 %red7, %elt8
  %eltvec8 = insertelement <16 x i32> %eltvec7, i32 %red7, i32 8
  %elt9 = extractelement <16 x i32> %valp, i32 9
  %red9 = xor i32 %red8, %elt9
  %eltvec9 = insertelement <16 x i32> %eltvec8, i32 %red8, i32 9
  %elt10 = extractelement <16 x i32> %valp, i32 10
  %red10 = xor i32 %red9, %elt10
  %eltvec10 = insertelement <16 x i32> %eltvec9, i32 %red9, i32 10
  %elt11 = extractelement <16 x i32> %valp, i32 11
  %red11 = xor i32 %red10, %elt11
  %eltvec11 = insertelement <16 x i32> %eltvec10, i32 %red10, i32 11
  %elt12 = extractelement <16 x i32> %valp, i32 12
  %red12 = xor i32 %red11, %elt12
  %eltvec12 = insertelement <16 x i32> %eltvec11, i32 %red11, i32 12
  %elt13 = extractelement <16 x i32> %valp, i32 13
  %red13 = xor i32 %red12, %elt13
  %eltvec13 = insertelement <16 x i32> %eltvec12, i32 %red12, i32 13
  %elt14 = extractelement <16 x i32> %valp, i32 14
  %red14 = xor i32 %red13, %elt14
  %eltvec14 = insertelement <16 x i32> %eltvec13, i32 %red13, i32 14
  %elt15 = extractelement <16 x i32> %valp, i32 15
  %red15 = xor i32 %red14, %elt15
  %eltvec15 = insertelement <16 x i32> %eltvec14, i32 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw xor i32 * %ptr, i32 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i32 %final0 to <1 x i32>
  %final_base = shufflevector <1 x i32> %finalv1, <1 x i32> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = xor <16 x i32> %final_base, %eltvec15

  ret <16 x i32> %r
}


define i32 @__atomic_add_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw add i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_sub_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw sub i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_and_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw and i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_or_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw or i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_xor_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw xor i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_min_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw min i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_max_uniform_int32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw max i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_umin_uniform_uint32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw umin i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}


define i32 @__atomic_umax_uniform_uint32_global(i32 * %ptr, i32 %val) nounwind alwaysinline {
  %r = atomicrmw umax i32 * %ptr, i32 %val seq_cst
  ret i32 %r
}




define <16 x i64> @__atomic_add_int64_global(i64 * %ptr, <16 x i64> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i64> @convertmask_i8_i64_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i64> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i64 0 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i64> %mask, < i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1,  i64 -1 >
  %idoff = and <16 x i64> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i64> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i64> %valp, i32 0
  %eltvec0 = insertelement <16 x i64> undef, i64 0, i32 0

  
  %elt1 = extractelement <16 x i64> %valp, i32 1
  %red1 = add i64 %red0, %elt1
  %eltvec1 = insertelement <16 x i64> %eltvec0, i64 %red0, i32 1
  %elt2 = extractelement <16 x i64> %valp, i32 2
  %red2 = add i64 %red1, %elt2
  %eltvec2 = insertelement <16 x i64> %eltvec1, i64 %red1, i32 2
  %elt3 = extractelement <16 x i64> %valp, i32 3
  %red3 = add i64 %red2, %elt3
  %eltvec3 = insertelement <16 x i64> %eltvec2, i64 %red2, i32 3
  %elt4 = extractelement <16 x i64> %valp, i32 4
  %red4 = add i64 %red3, %elt4
  %eltvec4 = insertelement <16 x i64> %eltvec3, i64 %red3, i32 4
  %elt5 = extractelement <16 x i64> %valp, i32 5
  %red5 = add i64 %red4, %elt5
  %eltvec5 = insertelement <16 x i64> %eltvec4, i64 %red4, i32 5
  %elt6 = extractelement <16 x i64> %valp, i32 6
  %red6 = add i64 %red5, %elt6
  %eltvec6 = insertelement <16 x i64> %eltvec5, i64 %red5, i32 6
  %elt7 = extractelement <16 x i64> %valp, i32 7
  %red7 = add i64 %red6, %elt7
  %eltvec7 = insertelement <16 x i64> %eltvec6, i64 %red6, i32 7
  %elt8 = extractelement <16 x i64> %valp, i32 8
  %red8 = add i64 %red7, %elt8
  %eltvec8 = insertelement <16 x i64> %eltvec7, i64 %red7, i32 8
  %elt9 = extractelement <16 x i64> %valp, i32 9
  %red9 = add i64 %red8, %elt9
  %eltvec9 = insertelement <16 x i64> %eltvec8, i64 %red8, i32 9
  %elt10 = extractelement <16 x i64> %valp, i32 10
  %red10 = add i64 %red9, %elt10
  %eltvec10 = insertelement <16 x i64> %eltvec9, i64 %red9, i32 10
  %elt11 = extractelement <16 x i64> %valp, i32 11
  %red11 = add i64 %red10, %elt11
  %eltvec11 = insertelement <16 x i64> %eltvec10, i64 %red10, i32 11
  %elt12 = extractelement <16 x i64> %valp, i32 12
  %red12 = add i64 %red11, %elt12
  %eltvec12 = insertelement <16 x i64> %eltvec11, i64 %red11, i32 12
  %elt13 = extractelement <16 x i64> %valp, i32 13
  %red13 = add i64 %red12, %elt13
  %eltvec13 = insertelement <16 x i64> %eltvec12, i64 %red12, i32 13
  %elt14 = extractelement <16 x i64> %valp, i32 14
  %red14 = add i64 %red13, %elt14
  %eltvec14 = insertelement <16 x i64> %eltvec13, i64 %red13, i32 14
  %elt15 = extractelement <16 x i64> %valp, i32 15
  %red15 = add i64 %red14, %elt15
  %eltvec15 = insertelement <16 x i64> %eltvec14, i64 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw add i64 * %ptr, i64 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i64 %final0 to <1 x i64>
  %final_base = shufflevector <1 x i64> %finalv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = add <16 x i64> %final_base, %eltvec15

  ret <16 x i64> %r
}



define <16 x i64> @__atomic_sub_int64_global(i64 * %ptr, <16 x i64> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i64> @convertmask_i8_i64_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i64> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i64 0 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i64> %mask, < i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1,  i64 -1 >
  %idoff = and <16 x i64> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i64> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i64> %valp, i32 0
  %eltvec0 = insertelement <16 x i64> undef, i64 0, i32 0

  
  %elt1 = extractelement <16 x i64> %valp, i32 1
  %red1 = sub i64 %red0, %elt1
  %eltvec1 = insertelement <16 x i64> %eltvec0, i64 %red0, i32 1
  %elt2 = extractelement <16 x i64> %valp, i32 2
  %red2 = sub i64 %red1, %elt2
  %eltvec2 = insertelement <16 x i64> %eltvec1, i64 %red1, i32 2
  %elt3 = extractelement <16 x i64> %valp, i32 3
  %red3 = sub i64 %red2, %elt3
  %eltvec3 = insertelement <16 x i64> %eltvec2, i64 %red2, i32 3
  %elt4 = extractelement <16 x i64> %valp, i32 4
  %red4 = sub i64 %red3, %elt4
  %eltvec4 = insertelement <16 x i64> %eltvec3, i64 %red3, i32 4
  %elt5 = extractelement <16 x i64> %valp, i32 5
  %red5 = sub i64 %red4, %elt5
  %eltvec5 = insertelement <16 x i64> %eltvec4, i64 %red4, i32 5
  %elt6 = extractelement <16 x i64> %valp, i32 6
  %red6 = sub i64 %red5, %elt6
  %eltvec6 = insertelement <16 x i64> %eltvec5, i64 %red5, i32 6
  %elt7 = extractelement <16 x i64> %valp, i32 7
  %red7 = sub i64 %red6, %elt7
  %eltvec7 = insertelement <16 x i64> %eltvec6, i64 %red6, i32 7
  %elt8 = extractelement <16 x i64> %valp, i32 8
  %red8 = sub i64 %red7, %elt8
  %eltvec8 = insertelement <16 x i64> %eltvec7, i64 %red7, i32 8
  %elt9 = extractelement <16 x i64> %valp, i32 9
  %red9 = sub i64 %red8, %elt9
  %eltvec9 = insertelement <16 x i64> %eltvec8, i64 %red8, i32 9
  %elt10 = extractelement <16 x i64> %valp, i32 10
  %red10 = sub i64 %red9, %elt10
  %eltvec10 = insertelement <16 x i64> %eltvec9, i64 %red9, i32 10
  %elt11 = extractelement <16 x i64> %valp, i32 11
  %red11 = sub i64 %red10, %elt11
  %eltvec11 = insertelement <16 x i64> %eltvec10, i64 %red10, i32 11
  %elt12 = extractelement <16 x i64> %valp, i32 12
  %red12 = sub i64 %red11, %elt12
  %eltvec12 = insertelement <16 x i64> %eltvec11, i64 %red11, i32 12
  %elt13 = extractelement <16 x i64> %valp, i32 13
  %red13 = sub i64 %red12, %elt13
  %eltvec13 = insertelement <16 x i64> %eltvec12, i64 %red12, i32 13
  %elt14 = extractelement <16 x i64> %valp, i32 14
  %red14 = sub i64 %red13, %elt14
  %eltvec14 = insertelement <16 x i64> %eltvec13, i64 %red13, i32 14
  %elt15 = extractelement <16 x i64> %valp, i32 15
  %red15 = sub i64 %red14, %elt15
  %eltvec15 = insertelement <16 x i64> %eltvec14, i64 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw sub i64 * %ptr, i64 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i64 %final0 to <1 x i64>
  %final_base = shufflevector <1 x i64> %finalv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = sub <16 x i64> %final_base, %eltvec15

  ret <16 x i64> %r
}



define <16 x i64> @__atomic_and_int64_global(i64 * %ptr, <16 x i64> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i64> @convertmask_i8_i64_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i64> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i64 -1 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i64> %mask, < i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1,  i64 -1 >
  %idoff = and <16 x i64> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i64> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i64> %valp, i32 0
  %eltvec0 = insertelement <16 x i64> undef, i64 -1, i32 0

  
  %elt1 = extractelement <16 x i64> %valp, i32 1
  %red1 = and i64 %red0, %elt1
  %eltvec1 = insertelement <16 x i64> %eltvec0, i64 %red0, i32 1
  %elt2 = extractelement <16 x i64> %valp, i32 2
  %red2 = and i64 %red1, %elt2
  %eltvec2 = insertelement <16 x i64> %eltvec1, i64 %red1, i32 2
  %elt3 = extractelement <16 x i64> %valp, i32 3
  %red3 = and i64 %red2, %elt3
  %eltvec3 = insertelement <16 x i64> %eltvec2, i64 %red2, i32 3
  %elt4 = extractelement <16 x i64> %valp, i32 4
  %red4 = and i64 %red3, %elt4
  %eltvec4 = insertelement <16 x i64> %eltvec3, i64 %red3, i32 4
  %elt5 = extractelement <16 x i64> %valp, i32 5
  %red5 = and i64 %red4, %elt5
  %eltvec5 = insertelement <16 x i64> %eltvec4, i64 %red4, i32 5
  %elt6 = extractelement <16 x i64> %valp, i32 6
  %red6 = and i64 %red5, %elt6
  %eltvec6 = insertelement <16 x i64> %eltvec5, i64 %red5, i32 6
  %elt7 = extractelement <16 x i64> %valp, i32 7
  %red7 = and i64 %red6, %elt7
  %eltvec7 = insertelement <16 x i64> %eltvec6, i64 %red6, i32 7
  %elt8 = extractelement <16 x i64> %valp, i32 8
  %red8 = and i64 %red7, %elt8
  %eltvec8 = insertelement <16 x i64> %eltvec7, i64 %red7, i32 8
  %elt9 = extractelement <16 x i64> %valp, i32 9
  %red9 = and i64 %red8, %elt9
  %eltvec9 = insertelement <16 x i64> %eltvec8, i64 %red8, i32 9
  %elt10 = extractelement <16 x i64> %valp, i32 10
  %red10 = and i64 %red9, %elt10
  %eltvec10 = insertelement <16 x i64> %eltvec9, i64 %red9, i32 10
  %elt11 = extractelement <16 x i64> %valp, i32 11
  %red11 = and i64 %red10, %elt11
  %eltvec11 = insertelement <16 x i64> %eltvec10, i64 %red10, i32 11
  %elt12 = extractelement <16 x i64> %valp, i32 12
  %red12 = and i64 %red11, %elt12
  %eltvec12 = insertelement <16 x i64> %eltvec11, i64 %red11, i32 12
  %elt13 = extractelement <16 x i64> %valp, i32 13
  %red13 = and i64 %red12, %elt13
  %eltvec13 = insertelement <16 x i64> %eltvec12, i64 %red12, i32 13
  %elt14 = extractelement <16 x i64> %valp, i32 14
  %red14 = and i64 %red13, %elt14
  %eltvec14 = insertelement <16 x i64> %eltvec13, i64 %red13, i32 14
  %elt15 = extractelement <16 x i64> %valp, i32 15
  %red15 = and i64 %red14, %elt15
  %eltvec15 = insertelement <16 x i64> %eltvec14, i64 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw and i64 * %ptr, i64 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i64 %final0 to <1 x i64>
  %final_base = shufflevector <1 x i64> %finalv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = and <16 x i64> %final_base, %eltvec15

  ret <16 x i64> %r
}



define <16 x i64> @__atomic_or_int64_global(i64 * %ptr, <16 x i64> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i64> @convertmask_i8_i64_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i64> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i64 0 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i64> %mask, < i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1,  i64 -1 >
  %idoff = and <16 x i64> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i64> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i64> %valp, i32 0
  %eltvec0 = insertelement <16 x i64> undef, i64 0, i32 0

  
  %elt1 = extractelement <16 x i64> %valp, i32 1
  %red1 = or i64 %red0, %elt1
  %eltvec1 = insertelement <16 x i64> %eltvec0, i64 %red0, i32 1
  %elt2 = extractelement <16 x i64> %valp, i32 2
  %red2 = or i64 %red1, %elt2
  %eltvec2 = insertelement <16 x i64> %eltvec1, i64 %red1, i32 2
  %elt3 = extractelement <16 x i64> %valp, i32 3
  %red3 = or i64 %red2, %elt3
  %eltvec3 = insertelement <16 x i64> %eltvec2, i64 %red2, i32 3
  %elt4 = extractelement <16 x i64> %valp, i32 4
  %red4 = or i64 %red3, %elt4
  %eltvec4 = insertelement <16 x i64> %eltvec3, i64 %red3, i32 4
  %elt5 = extractelement <16 x i64> %valp, i32 5
  %red5 = or i64 %red4, %elt5
  %eltvec5 = insertelement <16 x i64> %eltvec4, i64 %red4, i32 5
  %elt6 = extractelement <16 x i64> %valp, i32 6
  %red6 = or i64 %red5, %elt6
  %eltvec6 = insertelement <16 x i64> %eltvec5, i64 %red5, i32 6
  %elt7 = extractelement <16 x i64> %valp, i32 7
  %red7 = or i64 %red6, %elt7
  %eltvec7 = insertelement <16 x i64> %eltvec6, i64 %red6, i32 7
  %elt8 = extractelement <16 x i64> %valp, i32 8
  %red8 = or i64 %red7, %elt8
  %eltvec8 = insertelement <16 x i64> %eltvec7, i64 %red7, i32 8
  %elt9 = extractelement <16 x i64> %valp, i32 9
  %red9 = or i64 %red8, %elt9
  %eltvec9 = insertelement <16 x i64> %eltvec8, i64 %red8, i32 9
  %elt10 = extractelement <16 x i64> %valp, i32 10
  %red10 = or i64 %red9, %elt10
  %eltvec10 = insertelement <16 x i64> %eltvec9, i64 %red9, i32 10
  %elt11 = extractelement <16 x i64> %valp, i32 11
  %red11 = or i64 %red10, %elt11
  %eltvec11 = insertelement <16 x i64> %eltvec10, i64 %red10, i32 11
  %elt12 = extractelement <16 x i64> %valp, i32 12
  %red12 = or i64 %red11, %elt12
  %eltvec12 = insertelement <16 x i64> %eltvec11, i64 %red11, i32 12
  %elt13 = extractelement <16 x i64> %valp, i32 13
  %red13 = or i64 %red12, %elt13
  %eltvec13 = insertelement <16 x i64> %eltvec12, i64 %red12, i32 13
  %elt14 = extractelement <16 x i64> %valp, i32 14
  %red14 = or i64 %red13, %elt14
  %eltvec14 = insertelement <16 x i64> %eltvec13, i64 %red13, i32 14
  %elt15 = extractelement <16 x i64> %valp, i32 15
  %red15 = or i64 %red14, %elt15
  %eltvec15 = insertelement <16 x i64> %eltvec14, i64 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw or i64 * %ptr, i64 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i64 %final0 to <1 x i64>
  %final_base = shufflevector <1 x i64> %finalv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = or <16 x i64> %final_base, %eltvec15

  ret <16 x i64> %r
}



define <16 x i64> @__atomic_xor_int64_global(i64 * %ptr, <16 x i64> %val,
                                        <16 x i8> %m) nounwind alwaysinline {
  ; first, for any lanes where the mask is off, compute a vector where those lanes
  ; hold the identity value..

  ; for the bit tricks below, we need the mask to have the
  ; the same element size as the element type.
  %mask = call <16 x i64> @convertmask_i8_i64_16(<16 x i8> %m)

  ; zero out any lanes that are off
  %valoff = and <16 x i64> %val, %mask

  ; compute an identity vector that is zero in on lanes and has the identiy value
  ; in the off lanes
  %idv1 = bitcast i64 0 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %notmask = xor <16 x i64> %mask, < i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1,  i64 -1 >
  %idoff = and <16 x i64> %idvec, %notmask

  ; and comptue the merged vector that holds the identity in the off lanes
  %valp = or <16 x i64> %valoff, %idoff

  ; now compute the local reduction (val0 op val1 op ... )--initialize
  ; %eltvec so that the 0th element is the identity, the first is val0,
  ; the second is (val0 op val1), ..
  %red0 = extractelement <16 x i64> %valp, i32 0
  %eltvec0 = insertelement <16 x i64> undef, i64 0, i32 0

  
  %elt1 = extractelement <16 x i64> %valp, i32 1
  %red1 = xor i64 %red0, %elt1
  %eltvec1 = insertelement <16 x i64> %eltvec0, i64 %red0, i32 1
  %elt2 = extractelement <16 x i64> %valp, i32 2
  %red2 = xor i64 %red1, %elt2
  %eltvec2 = insertelement <16 x i64> %eltvec1, i64 %red1, i32 2
  %elt3 = extractelement <16 x i64> %valp, i32 3
  %red3 = xor i64 %red2, %elt3
  %eltvec3 = insertelement <16 x i64> %eltvec2, i64 %red2, i32 3
  %elt4 = extractelement <16 x i64> %valp, i32 4
  %red4 = xor i64 %red3, %elt4
  %eltvec4 = insertelement <16 x i64> %eltvec3, i64 %red3, i32 4
  %elt5 = extractelement <16 x i64> %valp, i32 5
  %red5 = xor i64 %red4, %elt5
  %eltvec5 = insertelement <16 x i64> %eltvec4, i64 %red4, i32 5
  %elt6 = extractelement <16 x i64> %valp, i32 6
  %red6 = xor i64 %red5, %elt6
  %eltvec6 = insertelement <16 x i64> %eltvec5, i64 %red5, i32 6
  %elt7 = extractelement <16 x i64> %valp, i32 7
  %red7 = xor i64 %red6, %elt7
  %eltvec7 = insertelement <16 x i64> %eltvec6, i64 %red6, i32 7
  %elt8 = extractelement <16 x i64> %valp, i32 8
  %red8 = xor i64 %red7, %elt8
  %eltvec8 = insertelement <16 x i64> %eltvec7, i64 %red7, i32 8
  %elt9 = extractelement <16 x i64> %valp, i32 9
  %red9 = xor i64 %red8, %elt9
  %eltvec9 = insertelement <16 x i64> %eltvec8, i64 %red8, i32 9
  %elt10 = extractelement <16 x i64> %valp, i32 10
  %red10 = xor i64 %red9, %elt10
  %eltvec10 = insertelement <16 x i64> %eltvec9, i64 %red9, i32 10
  %elt11 = extractelement <16 x i64> %valp, i32 11
  %red11 = xor i64 %red10, %elt11
  %eltvec11 = insertelement <16 x i64> %eltvec10, i64 %red10, i32 11
  %elt12 = extractelement <16 x i64> %valp, i32 12
  %red12 = xor i64 %red11, %elt12
  %eltvec12 = insertelement <16 x i64> %eltvec11, i64 %red11, i32 12
  %elt13 = extractelement <16 x i64> %valp, i32 13
  %red13 = xor i64 %red12, %elt13
  %eltvec13 = insertelement <16 x i64> %eltvec12, i64 %red12, i32 13
  %elt14 = extractelement <16 x i64> %valp, i32 14
  %red14 = xor i64 %red13, %elt14
  %eltvec14 = insertelement <16 x i64> %eltvec13, i64 %red13, i32 14
  %elt15 = extractelement <16 x i64> %valp, i32 15
  %red15 = xor i64 %red14, %elt15
  %eltvec15 = insertelement <16 x i64> %eltvec14, i64 %red14, i32 15

  ; make the atomic call, passing it the final reduced value
  %final0 = atomicrmw xor i64 * %ptr, i64 %red15 seq_cst

  ; now go back and compute the values to be returned for each program 
  ; instance--this just involves smearing the old value returned from the
  ; actual atomic call across the vector and applying the vector op to the
  ; %eltvec vector computed above..
  %finalv1 = bitcast i64 %final0 to <1 x i64>
  %final_base = shufflevector <1 x i64> %finalv1, <1 x i64> undef,
     <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  %r = xor <16 x i64> %final_base, %eltvec15

  ret <16 x i64> %r
}


define i64 @__atomic_add_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw add i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_sub_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw sub i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_and_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw and i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_or_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw or i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_xor_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw xor i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_min_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw min i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_max_uniform_int64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw max i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_umin_uniform_uint64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw umin i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}


define i64 @__atomic_umax_uniform_uint64_global(i64 * %ptr, i64 %val) nounwind alwaysinline {
  %r = atomicrmw umax i64 * %ptr, i64 %val seq_cst
  ret i64 %r
}



define i32 @__atomic_swap_uniform_int32_global(i32* %ptr, i32 %val) nounwind alwaysinline {
 %r = atomicrmw xchg i32 * %ptr, i32 %val seq_cst
 ret i32 %r
}


define i64 @__atomic_swap_uniform_int64_global(i64* %ptr, i64 %val) nounwind alwaysinline {
 %r = atomicrmw xchg i64 * %ptr, i64 %val seq_cst
 ret i64 %r
}


define float @__atomic_swap_uniform_float_global(float * %ptr, float %val) nounwind alwaysinline {
  %iptr = bitcast float * %ptr to i32 *
  %ival = bitcast float %val to i32
  %iret = call i32 @__atomic_swap_uniform_int32_global(i32 * %iptr, i32 %ival)
  %ret = bitcast i32 %iret to float
  ret float %ret
}

define double @__atomic_swap_uniform_double_global(double * %ptr, double %val) nounwind alwaysinline {
  %iptr = bitcast double * %ptr to i64 *
  %ival = bitcast double %val to i64
  %iret = call i64 @__atomic_swap_uniform_int64_global(i64 * %iptr, i64 %ival)
  %ret = bitcast i64 %iret to double
  ret double %ret
}



define <16 x i32> @__atomic_compare_exchange_int32_global(i32* %ptr, <16 x i32> %cmp,
                               <16 x i32> %val, <16 x i8> %mask) nounwind alwaysinline {
  %rptr = alloca <16 x i32>
  %rptr32 = bitcast <16 x i32> * %rptr to i32 *

  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
   %cmp_0_ID = extractelement <16 x i32> %cmp, i32 0
   %val_0_ID = extractelement <16 x i32> %val, i32 0
   %r_0_ID_t = cmpxchg i32 * %ptr, i32 %cmp_0_ID, i32 %val_0_ID seq_cst seq_cst
   %r_0_ID = extractvalue { i32, i1 } %r_0_ID_t, 0
   %rp_0_ID = getelementptr i32 , i32 *
 %rptr32, i32 0
   store i32 %r_0_ID, i32 * %rp_0_ID
   %cmp_1_ID = extractelement <16 x i32> %cmp, i32 1
   %val_1_ID = extractelement <16 x i32> %val, i32 1
   %r_1_ID_t = cmpxchg i32 * %ptr, i32 %cmp_1_ID, i32 %val_1_ID seq_cst seq_cst
   %r_1_ID = extractvalue { i32, i1 } %r_1_ID_t, 0
   %rp_1_ID = getelementptr i32 , i32 *
 %rptr32, i32 1
   store i32 %r_1_ID, i32 * %rp_1_ID
   %cmp_2_ID = extractelement <16 x i32> %cmp, i32 2
   %val_2_ID = extractelement <16 x i32> %val, i32 2
   %r_2_ID_t = cmpxchg i32 * %ptr, i32 %cmp_2_ID, i32 %val_2_ID seq_cst seq_cst
   %r_2_ID = extractvalue { i32, i1 } %r_2_ID_t, 0
   %rp_2_ID = getelementptr i32 , i32 *
 %rptr32, i32 2
   store i32 %r_2_ID, i32 * %rp_2_ID
   %cmp_3_ID = extractelement <16 x i32> %cmp, i32 3
   %val_3_ID = extractelement <16 x i32> %val, i32 3
   %r_3_ID_t = cmpxchg i32 * %ptr, i32 %cmp_3_ID, i32 %val_3_ID seq_cst seq_cst
   %r_3_ID = extractvalue { i32, i1 } %r_3_ID_t, 0
   %rp_3_ID = getelementptr i32 , i32 *
 %rptr32, i32 3
   store i32 %r_3_ID, i32 * %rp_3_ID
   %cmp_4_ID = extractelement <16 x i32> %cmp, i32 4
   %val_4_ID = extractelement <16 x i32> %val, i32 4
   %r_4_ID_t = cmpxchg i32 * %ptr, i32 %cmp_4_ID, i32 %val_4_ID seq_cst seq_cst
   %r_4_ID = extractvalue { i32, i1 } %r_4_ID_t, 0
   %rp_4_ID = getelementptr i32 , i32 *
 %rptr32, i32 4
   store i32 %r_4_ID, i32 * %rp_4_ID
   %cmp_5_ID = extractelement <16 x i32> %cmp, i32 5
   %val_5_ID = extractelement <16 x i32> %val, i32 5
   %r_5_ID_t = cmpxchg i32 * %ptr, i32 %cmp_5_ID, i32 %val_5_ID seq_cst seq_cst
   %r_5_ID = extractvalue { i32, i1 } %r_5_ID_t, 0
   %rp_5_ID = getelementptr i32 , i32 *
 %rptr32, i32 5
   store i32 %r_5_ID, i32 * %rp_5_ID
   %cmp_6_ID = extractelement <16 x i32> %cmp, i32 6
   %val_6_ID = extractelement <16 x i32> %val, i32 6
   %r_6_ID_t = cmpxchg i32 * %ptr, i32 %cmp_6_ID, i32 %val_6_ID seq_cst seq_cst
   %r_6_ID = extractvalue { i32, i1 } %r_6_ID_t, 0
   %rp_6_ID = getelementptr i32 , i32 *
 %rptr32, i32 6
   store i32 %r_6_ID, i32 * %rp_6_ID
   %cmp_7_ID = extractelement <16 x i32> %cmp, i32 7
   %val_7_ID = extractelement <16 x i32> %val, i32 7
   %r_7_ID_t = cmpxchg i32 * %ptr, i32 %cmp_7_ID, i32 %val_7_ID seq_cst seq_cst
   %r_7_ID = extractvalue { i32, i1 } %r_7_ID_t, 0
   %rp_7_ID = getelementptr i32 , i32 *
 %rptr32, i32 7
   store i32 %r_7_ID, i32 * %rp_7_ID
   %cmp_8_ID = extractelement <16 x i32> %cmp, i32 8
   %val_8_ID = extractelement <16 x i32> %val, i32 8
   %r_8_ID_t = cmpxchg i32 * %ptr, i32 %cmp_8_ID, i32 %val_8_ID seq_cst seq_cst
   %r_8_ID = extractvalue { i32, i1 } %r_8_ID_t, 0
   %rp_8_ID = getelementptr i32 , i32 *
 %rptr32, i32 8
   store i32 %r_8_ID, i32 * %rp_8_ID
   %cmp_9_ID = extractelement <16 x i32> %cmp, i32 9
   %val_9_ID = extractelement <16 x i32> %val, i32 9
   %r_9_ID_t = cmpxchg i32 * %ptr, i32 %cmp_9_ID, i32 %val_9_ID seq_cst seq_cst
   %r_9_ID = extractvalue { i32, i1 } %r_9_ID_t, 0
   %rp_9_ID = getelementptr i32 , i32 *
 %rptr32, i32 9
   store i32 %r_9_ID, i32 * %rp_9_ID
   %cmp_10_ID = extractelement <16 x i32> %cmp, i32 10
   %val_10_ID = extractelement <16 x i32> %val, i32 10
   %r_10_ID_t = cmpxchg i32 * %ptr, i32 %cmp_10_ID, i32 %val_10_ID seq_cst seq_cst
   %r_10_ID = extractvalue { i32, i1 } %r_10_ID_t, 0
   %rp_10_ID = getelementptr i32 , i32 *
 %rptr32, i32 10
   store i32 %r_10_ID, i32 * %rp_10_ID
   %cmp_11_ID = extractelement <16 x i32> %cmp, i32 11
   %val_11_ID = extractelement <16 x i32> %val, i32 11
   %r_11_ID_t = cmpxchg i32 * %ptr, i32 %cmp_11_ID, i32 %val_11_ID seq_cst seq_cst
   %r_11_ID = extractvalue { i32, i1 } %r_11_ID_t, 0
   %rp_11_ID = getelementptr i32 , i32 *
 %rptr32, i32 11
   store i32 %r_11_ID, i32 * %rp_11_ID
   %cmp_12_ID = extractelement <16 x i32> %cmp, i32 12
   %val_12_ID = extractelement <16 x i32> %val, i32 12
   %r_12_ID_t = cmpxchg i32 * %ptr, i32 %cmp_12_ID, i32 %val_12_ID seq_cst seq_cst
   %r_12_ID = extractvalue { i32, i1 } %r_12_ID_t, 0
   %rp_12_ID = getelementptr i32 , i32 *
 %rptr32, i32 12
   store i32 %r_12_ID, i32 * %rp_12_ID
   %cmp_13_ID = extractelement <16 x i32> %cmp, i32 13
   %val_13_ID = extractelement <16 x i32> %val, i32 13
   %r_13_ID_t = cmpxchg i32 * %ptr, i32 %cmp_13_ID, i32 %val_13_ID seq_cst seq_cst
   %r_13_ID = extractvalue { i32, i1 } %r_13_ID_t, 0
   %rp_13_ID = getelementptr i32 , i32 *
 %rptr32, i32 13
   store i32 %r_13_ID, i32 * %rp_13_ID
   %cmp_14_ID = extractelement <16 x i32> %cmp, i32 14
   %val_14_ID = extractelement <16 x i32> %val, i32 14
   %r_14_ID_t = cmpxchg i32 * %ptr, i32 %cmp_14_ID, i32 %val_14_ID seq_cst seq_cst
   %r_14_ID = extractvalue { i32, i1 } %r_14_ID_t, 0
   %rp_14_ID = getelementptr i32 , i32 *
 %rptr32, i32 14
   store i32 %r_14_ID, i32 * %rp_14_ID
   %cmp_15_ID = extractelement <16 x i32> %cmp, i32 15
   %val_15_ID = extractelement <16 x i32> %val, i32 15
   %r_15_ID_t = cmpxchg i32 * %ptr, i32 %cmp_15_ID, i32 %val_15_ID seq_cst seq_cst
   %r_15_ID = extractvalue { i32, i1 } %r_15_ID_t, 0
   %rp_15_ID = getelementptr i32 , i32 *
 %rptr32, i32 15
   store i32 %r_15_ID, i32 * %rp_15_ID
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
   %cmp__id = extractelement <16 x i32> %cmp, i32 %pl_lane
   %val__id = extractelement <16 x i32> %val, i32 %pl_lane
   %r__id_t = cmpxchg i32 * %ptr, i32 %cmp__id, i32 %val__id seq_cst seq_cst
   %r__id = extractvalue { i32, i1 } %r__id_t, 0
   %rp__id = getelementptr i32 , i32 *
 %rptr32, i32 %pl_lane
   store i32 %r__id, i32 * %rp__id
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

   %r = load <16 x i32>  , <16 x i32>  *
  %rptr
   ret <16 x i32> %r
}

define i32 @__atomic_compare_exchange_uniform_int32_global(i32* %ptr, i32 %cmp,
                                                       i32 %val) nounwind alwaysinline {                                                           
   %r_t = cmpxchg i32 * %ptr, i32 %cmp, i32 %val seq_cst seq_cst
   %r = extractvalue { i32, i1 } %r_t, 0
   ret i32 %r
}



define <16 x i64> @__atomic_compare_exchange_int64_global(i64* %ptr, <16 x i64> %cmp,
                               <16 x i64> %val, <16 x i8> %mask) nounwind alwaysinline {
  %rptr = alloca <16 x i64>
  %rptr32 = bitcast <16 x i64> * %rptr to i64 *

  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
   %cmp_0_ID = extractelement <16 x i64> %cmp, i32 0
   %val_0_ID = extractelement <16 x i64> %val, i32 0
   %r_0_ID_t = cmpxchg i64 * %ptr, i64 %cmp_0_ID, i64 %val_0_ID seq_cst seq_cst
   %r_0_ID = extractvalue { i64, i1 } %r_0_ID_t, 0
   %rp_0_ID = getelementptr i64 , i64 *
 %rptr32, i32 0
   store i64 %r_0_ID, i64 * %rp_0_ID
   %cmp_1_ID = extractelement <16 x i64> %cmp, i32 1
   %val_1_ID = extractelement <16 x i64> %val, i32 1
   %r_1_ID_t = cmpxchg i64 * %ptr, i64 %cmp_1_ID, i64 %val_1_ID seq_cst seq_cst
   %r_1_ID = extractvalue { i64, i1 } %r_1_ID_t, 0
   %rp_1_ID = getelementptr i64 , i64 *
 %rptr32, i32 1
   store i64 %r_1_ID, i64 * %rp_1_ID
   %cmp_2_ID = extractelement <16 x i64> %cmp, i32 2
   %val_2_ID = extractelement <16 x i64> %val, i32 2
   %r_2_ID_t = cmpxchg i64 * %ptr, i64 %cmp_2_ID, i64 %val_2_ID seq_cst seq_cst
   %r_2_ID = extractvalue { i64, i1 } %r_2_ID_t, 0
   %rp_2_ID = getelementptr i64 , i64 *
 %rptr32, i32 2
   store i64 %r_2_ID, i64 * %rp_2_ID
   %cmp_3_ID = extractelement <16 x i64> %cmp, i32 3
   %val_3_ID = extractelement <16 x i64> %val, i32 3
   %r_3_ID_t = cmpxchg i64 * %ptr, i64 %cmp_3_ID, i64 %val_3_ID seq_cst seq_cst
   %r_3_ID = extractvalue { i64, i1 } %r_3_ID_t, 0
   %rp_3_ID = getelementptr i64 , i64 *
 %rptr32, i32 3
   store i64 %r_3_ID, i64 * %rp_3_ID
   %cmp_4_ID = extractelement <16 x i64> %cmp, i32 4
   %val_4_ID = extractelement <16 x i64> %val, i32 4
   %r_4_ID_t = cmpxchg i64 * %ptr, i64 %cmp_4_ID, i64 %val_4_ID seq_cst seq_cst
   %r_4_ID = extractvalue { i64, i1 } %r_4_ID_t, 0
   %rp_4_ID = getelementptr i64 , i64 *
 %rptr32, i32 4
   store i64 %r_4_ID, i64 * %rp_4_ID
   %cmp_5_ID = extractelement <16 x i64> %cmp, i32 5
   %val_5_ID = extractelement <16 x i64> %val, i32 5
   %r_5_ID_t = cmpxchg i64 * %ptr, i64 %cmp_5_ID, i64 %val_5_ID seq_cst seq_cst
   %r_5_ID = extractvalue { i64, i1 } %r_5_ID_t, 0
   %rp_5_ID = getelementptr i64 , i64 *
 %rptr32, i32 5
   store i64 %r_5_ID, i64 * %rp_5_ID
   %cmp_6_ID = extractelement <16 x i64> %cmp, i32 6
   %val_6_ID = extractelement <16 x i64> %val, i32 6
   %r_6_ID_t = cmpxchg i64 * %ptr, i64 %cmp_6_ID, i64 %val_6_ID seq_cst seq_cst
   %r_6_ID = extractvalue { i64, i1 } %r_6_ID_t, 0
   %rp_6_ID = getelementptr i64 , i64 *
 %rptr32, i32 6
   store i64 %r_6_ID, i64 * %rp_6_ID
   %cmp_7_ID = extractelement <16 x i64> %cmp, i32 7
   %val_7_ID = extractelement <16 x i64> %val, i32 7
   %r_7_ID_t = cmpxchg i64 * %ptr, i64 %cmp_7_ID, i64 %val_7_ID seq_cst seq_cst
   %r_7_ID = extractvalue { i64, i1 } %r_7_ID_t, 0
   %rp_7_ID = getelementptr i64 , i64 *
 %rptr32, i32 7
   store i64 %r_7_ID, i64 * %rp_7_ID
   %cmp_8_ID = extractelement <16 x i64> %cmp, i32 8
   %val_8_ID = extractelement <16 x i64> %val, i32 8
   %r_8_ID_t = cmpxchg i64 * %ptr, i64 %cmp_8_ID, i64 %val_8_ID seq_cst seq_cst
   %r_8_ID = extractvalue { i64, i1 } %r_8_ID_t, 0
   %rp_8_ID = getelementptr i64 , i64 *
 %rptr32, i32 8
   store i64 %r_8_ID, i64 * %rp_8_ID
   %cmp_9_ID = extractelement <16 x i64> %cmp, i32 9
   %val_9_ID = extractelement <16 x i64> %val, i32 9
   %r_9_ID_t = cmpxchg i64 * %ptr, i64 %cmp_9_ID, i64 %val_9_ID seq_cst seq_cst
   %r_9_ID = extractvalue { i64, i1 } %r_9_ID_t, 0
   %rp_9_ID = getelementptr i64 , i64 *
 %rptr32, i32 9
   store i64 %r_9_ID, i64 * %rp_9_ID
   %cmp_10_ID = extractelement <16 x i64> %cmp, i32 10
   %val_10_ID = extractelement <16 x i64> %val, i32 10
   %r_10_ID_t = cmpxchg i64 * %ptr, i64 %cmp_10_ID, i64 %val_10_ID seq_cst seq_cst
   %r_10_ID = extractvalue { i64, i1 } %r_10_ID_t, 0
   %rp_10_ID = getelementptr i64 , i64 *
 %rptr32, i32 10
   store i64 %r_10_ID, i64 * %rp_10_ID
   %cmp_11_ID = extractelement <16 x i64> %cmp, i32 11
   %val_11_ID = extractelement <16 x i64> %val, i32 11
   %r_11_ID_t = cmpxchg i64 * %ptr, i64 %cmp_11_ID, i64 %val_11_ID seq_cst seq_cst
   %r_11_ID = extractvalue { i64, i1 } %r_11_ID_t, 0
   %rp_11_ID = getelementptr i64 , i64 *
 %rptr32, i32 11
   store i64 %r_11_ID, i64 * %rp_11_ID
   %cmp_12_ID = extractelement <16 x i64> %cmp, i32 12
   %val_12_ID = extractelement <16 x i64> %val, i32 12
   %r_12_ID_t = cmpxchg i64 * %ptr, i64 %cmp_12_ID, i64 %val_12_ID seq_cst seq_cst
   %r_12_ID = extractvalue { i64, i1 } %r_12_ID_t, 0
   %rp_12_ID = getelementptr i64 , i64 *
 %rptr32, i32 12
   store i64 %r_12_ID, i64 * %rp_12_ID
   %cmp_13_ID = extractelement <16 x i64> %cmp, i32 13
   %val_13_ID = extractelement <16 x i64> %val, i32 13
   %r_13_ID_t = cmpxchg i64 * %ptr, i64 %cmp_13_ID, i64 %val_13_ID seq_cst seq_cst
   %r_13_ID = extractvalue { i64, i1 } %r_13_ID_t, 0
   %rp_13_ID = getelementptr i64 , i64 *
 %rptr32, i32 13
   store i64 %r_13_ID, i64 * %rp_13_ID
   %cmp_14_ID = extractelement <16 x i64> %cmp, i32 14
   %val_14_ID = extractelement <16 x i64> %val, i32 14
   %r_14_ID_t = cmpxchg i64 * %ptr, i64 %cmp_14_ID, i64 %val_14_ID seq_cst seq_cst
   %r_14_ID = extractvalue { i64, i1 } %r_14_ID_t, 0
   %rp_14_ID = getelementptr i64 , i64 *
 %rptr32, i32 14
   store i64 %r_14_ID, i64 * %rp_14_ID
   %cmp_15_ID = extractelement <16 x i64> %cmp, i32 15
   %val_15_ID = extractelement <16 x i64> %val, i32 15
   %r_15_ID_t = cmpxchg i64 * %ptr, i64 %cmp_15_ID, i64 %val_15_ID seq_cst seq_cst
   %r_15_ID = extractvalue { i64, i1 } %r_15_ID_t, 0
   %rp_15_ID = getelementptr i64 , i64 *
 %rptr32, i32 15
   store i64 %r_15_ID, i64 * %rp_15_ID
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
   %cmp__id = extractelement <16 x i64> %cmp, i32 %pl_lane
   %val__id = extractelement <16 x i64> %val, i32 %pl_lane
   %r__id_t = cmpxchg i64 * %ptr, i64 %cmp__id, i64 %val__id seq_cst seq_cst
   %r__id = extractvalue { i64, i1 } %r__id_t, 0
   %rp__id = getelementptr i64 , i64 *
 %rptr32, i32 %pl_lane
   store i64 %r__id, i64 * %rp__id
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

   %r = load <16 x i64>  , <16 x i64>  *
  %rptr
   ret <16 x i64> %r
}

define i64 @__atomic_compare_exchange_uniform_int64_global(i64* %ptr, i64 %cmp,
                                                       i64 %val) nounwind alwaysinline {                                                           
   %r_t = cmpxchg i64 * %ptr, i64 %cmp, i64 %val seq_cst seq_cst
   %r = extractvalue { i64, i1 } %r_t, 0
   ret i64 %r
}


define <16 x float> @__atomic_compare_exchange_float_global(float * %ptr,
                      <16 x float> %cmp, <16 x float> %val, <16 x i8> %mask) nounwind alwaysinline {
  %iptr = bitcast float * %ptr to i32 *
  %icmp = bitcast <16 x float> %cmp to <16 x i32>
  %ival = bitcast <16 x float> %val to <16 x i32>
  %iret = call <16 x i32> @__atomic_compare_exchange_int32_global(i32 * %iptr, <16 x i32> %icmp,
                                                                  <16 x i32> %ival, <16 x i8> %mask)
  %ret = bitcast <16 x i32> %iret to <16 x float>
  ret <16 x float> %ret
}

define <16 x double> @__atomic_compare_exchange_double_global(double * %ptr,
                      <16 x double> %cmp, <16 x double> %val, <16 x i8> %mask) nounwind alwaysinline {
  %iptr = bitcast double * %ptr to i64 *
  %icmp = bitcast <16 x double> %cmp to <16 x i64>
  %ival = bitcast <16 x double> %val to <16 x i64>
  %iret = call <16 x i64> @__atomic_compare_exchange_int64_global(i64 * %iptr, <16 x i64> %icmp,
                                                                  <16 x i64> %ival, <16 x i8> %mask)
  %ret = bitcast <16 x i64> %iret to <16 x double>
  ret <16 x double> %ret
}

define float @__atomic_compare_exchange_uniform_float_global(float * %ptr, float %cmp,
                                                             float %val) nounwind alwaysinline {
  %iptr = bitcast float * %ptr to i32 *
  %icmp = bitcast float %cmp to i32
  %ival = bitcast float %val to i32
  %iret = call i32 @__atomic_compare_exchange_uniform_int32_global(i32 * %iptr, i32 %icmp,
                                                                   i32 %ival)
  %ret = bitcast i32 %iret to float
  ret float %ret
}

define double @__atomic_compare_exchange_uniform_double_global(double * %ptr, double %cmp,
                                                               double %val) nounwind alwaysinline {
  %iptr = bitcast double * %ptr to i64 *
  %icmp = bitcast double %cmp to i64
  %ival = bitcast double %val to i64
  %iret = call i64 @__atomic_compare_exchange_uniform_int64_global(i64 * %iptr, i64 %icmp, i64 %ival)
  %ret = bitcast i64 %iret to double
  ret double %ret
}



  

declare <16 x i32> @llvm.masked.expandload.vWIDTHi32 (i32*, <16 x i1>, <16 x i32>)
declare void @llvm.masked.store.vWIDTHi32.p0vWIDTHi32(<16 x i32>, <16 x i32>*, i32, <16 x i1>)
define i32 @__packed_load_activei32(i32 * %startptr, <16 x i32> * %val_ptr,
                                 <16 x i8> %full_mask) nounwind alwaysinline {
  %i1mask = icmp ne <16 x i8> %full_mask, zeroinitializer
  %data = load <16 x i32>  , <16 x i32>  *
 %val_ptr
  %vec_load = call <16 x i32> @llvm.masked.expandload.vWIDTHi32(i32* %startptr, <16 x i1> %i1mask, <16 x i32> %data)
  store <16 x i32> %vec_load, <16 x i32>* %val_ptr, align 4


  %i16mask = bitcast <16 x i1> %i1mask to i16
  %i32mask = zext i16 %i16mask to i32
  %ret = call i32 @llvm.ctpop.i32(i32 %i32mask)
  

   ret i32 %ret
}

declare void @llvm.masked.compressstore.vWIDTHi32(<16  x i32>, i32* , <16  x i1> )
define i32 @__packed_store_activei32(i32* %startptr, <16 x i32> %vals,
                                   <16 x i8> %full_mask) nounwind alwaysinline {
  %i1mask = icmp ne <16 x i8> %full_mask, zeroinitializer
  call void @llvm.masked.compressstore.vWIDTHi32(<16 x i32> %vals, i32* %startptr, <16 x i1> %i1mask)


  %i16mask = bitcast <16 x i1> %i1mask to i16
  %i32mask = zext i16 %i16mask to i32
  %ret = call i32 @llvm.ctpop.i32(i32 %i32mask)
  

  ret i32 %ret
}




;; TODO: function needs to return i32, but not i8 type.
define i8 @__packed_store_active2i32(i32 * %startptr, <16 x i32> %vals,
                                   <16 x i8> %full_mask) nounwind alwaysinline {
entry:
  %mask = call i64 @__movmsk(<16 x i8> %full_mask)
  %mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %full_mask)
  br i1 %mask_known, label %known_mask, label %unknown_mask

known_mask:
  %allon = icmp eq i64 %mask, 65535
  br i1 %allon, label %all_on, label %unknown_mask
 
all_on:
  %vecptr = bitcast i32 *%startptr to <16 x i32> *
  store <16 x i32> %vals, <16 x i32> * %vecptr, align 4
  ret i8 16
 
unknown_mask:
  br label %loop
 
loop:
  %offset = phi i8 [ 0, %unknown_mask ], [ %ch_offset, %loop ]
  %i = phi i32 [ 0, %unknown_mask ], [ %ch_i, %loop ]
  %storeval = extractelement <16 x i32> %vals, i32 %i

;; Offset has value in range from 0 to 16-1. So it does not matter if we
;; zero or sign extending it, while zero extend is free. Also do nothing for
;; i64 i8, as we need i64 value.
 %offset1 = zext i8 %offset to i64
  %storeptr = getelementptr i32 , i32 *
 %startptr, i64 %offset1
  store i32 %storeval, i32 *%storeptr

  %mull_mask = extractelement <16 x i8> %full_mask, i32 %i
  %ch_offset = sub i8 %offset, %mull_mask
 
  ; are we done yet?
  %ch_i = add i32 %i, 1
  %test = icmp ne i32 %ch_i, 16
  br i1 %test, label %loop, label %done
 
done:
  ret i8 %ch_offset
}




  

declare <16 x i64> @llvm.masked.expandload.vWIDTHi64 (i64*, <16 x i1>, <16 x i64>)
declare void @llvm.masked.store.vWIDTHi64.p0vWIDTHi64(<16 x i64>, <16 x i64>*, i32, <16 x i1>)
define i32 @__packed_load_activei64(i64 * %startptr, <16 x i64> * %val_ptr,
                                 <16 x i8> %full_mask) nounwind alwaysinline {
  %i1mask = icmp ne <16 x i8> %full_mask, zeroinitializer
  %data = load <16 x i64>  , <16 x i64>  *
 %val_ptr
  %vec_load = call <16 x i64> @llvm.masked.expandload.vWIDTHi64(i64* %startptr, <16 x i1> %i1mask, <16 x i64> %data)
  store <16 x i64> %vec_load, <16 x i64>* %val_ptr, align 8


  %i16mask = bitcast <16 x i1> %i1mask to i16
  %i32mask = zext i16 %i16mask to i32
  %ret = call i32 @llvm.ctpop.i32(i32 %i32mask)
  

   ret i32 %ret
}

declare void @llvm.masked.compressstore.vWIDTHi64(<16  x i64>, i64* , <16  x i1> )
define i32 @__packed_store_activei64(i64* %startptr, <16 x i64> %vals,
                                   <16 x i8> %full_mask) nounwind alwaysinline {
  %i1mask = icmp ne <16 x i8> %full_mask, zeroinitializer
  call void @llvm.masked.compressstore.vWIDTHi64(<16 x i64> %vals, i64* %startptr, <16 x i1> %i1mask)


  %i16mask = bitcast <16 x i1> %i1mask to i16
  %i32mask = zext i16 %i16mask to i32
  %ret = call i32 @llvm.ctpop.i32(i32 %i32mask)
  

  ret i32 %ret
}




;; TODO: function needs to return i32, but not i8 type.
define i8 @__packed_store_active2i64(i64 * %startptr, <16 x i64> %vals,
                                   <16 x i8> %full_mask) nounwind alwaysinline {
entry:
  %mask = call i64 @__movmsk(<16 x i8> %full_mask)
  %mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %full_mask)
  br i1 %mask_known, label %known_mask, label %unknown_mask

known_mask:
  %allon = icmp eq i64 %mask, 65535
  br i1 %allon, label %all_on, label %unknown_mask
 
all_on:
  %vecptr = bitcast i64 *%startptr to <16 x i64> *
  store <16 x i64> %vals, <16 x i64> * %vecptr, align 4
  ret i8 16
 
unknown_mask:
  br label %loop
 
loop:
  %offset = phi i8 [ 0, %unknown_mask ], [ %ch_offset, %loop ]
  %i = phi i32 [ 0, %unknown_mask ], [ %ch_i, %loop ]
  %storeval = extractelement <16 x i64> %vals, i32 %i

;; Offset has value in range from 0 to 16-1. So it does not matter if we
;; zero or sign extending it, while zero extend is free. Also do nothing for
;; i64 i8, as we need i64 value.
 %offset1 = zext i8 %offset to i64
  %storeptr = getelementptr i64 , i64 *
 %startptr, i64 %offset1
  store i64 %storeval, i64 *%storeptr

  %mull_mask = extractelement <16 x i8> %full_mask, i32 %i
  %ch_offset = sub i8 %offset, %mull_mask
 
  ; are we done yet?
  %ch_i = add i32 %i, 1
  %test = icmp ne i32 %ch_i, 16
  br i1 %test, label %loop, label %done
 
done:
  ret i8 %ch_offset
}







define <16 x i32> @__exclusive_scan_add_i32(<16 x i32> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x i32>
  %idvec1 = bitcast i32 0 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idvec1, <1 x i32> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x i32> %idvec, <16 x i32> * %ptr
  %ptr32 = bitcast <16 x i32> * %ptr to <16 x i32> *
  %vi = bitcast <16 x i32> %v to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %ptr32, <16 x i32> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x i32>  , <16 x i32>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x i32> %v_id, i32 0
  %v1 = extractelement <16 x i32> %v_id, i32 1
  %v2 = extractelement <16 x i32> %v_id, i32 2
  %v3 = extractelement <16 x i32> %v_id, i32 3
  %v4 = extractelement <16 x i32> %v_id, i32 4
  %v5 = extractelement <16 x i32> %v_id, i32 5
  %v6 = extractelement <16 x i32> %v_id, i32 6
  %v7 = extractelement <16 x i32> %v_id, i32 7
  %v8 = extractelement <16 x i32> %v_id, i32 8
  %v9 = extractelement <16 x i32> %v_id, i32 9
  %v10 = extractelement <16 x i32> %v_id, i32 10
  %v11 = extractelement <16 x i32> %v_id, i32 11
  %v12 = extractelement <16 x i32> %v_id, i32 12
  %v13 = extractelement <16 x i32> %v_id, i32 13
  %v14 = extractelement <16 x i32> %v_id, i32 14
  %v15 = extractelement <16 x i32> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = add i32 0, %v0
  
  %s2 = add i32 %s1, %v1
  %s3 = add i32 %s2, %v2
  %s4 = add i32 %s3, %v3
  %s5 = add i32 %s4, %v4
  %s6 = add i32 %s5, %v5
  %s7 = add i32 %s6, %v6
  %s8 = add i32 %s7, %v7
  %s9 = add i32 %s8, %v8
  %s10 = add i32 %s9, %v9
  %s11 = add i32 %s10, %v10
  %s12 = add i32 %s11, %v11
  %s13 = add i32 %s12, %v12
  %s14 = add i32 %s13, %v13
  %s15 = add i32 %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x i32> undef, i32 0, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x i32> %r0, i32 %s1, i32 1
  %r2 = insertelement <16 x i32> %r1, i32 %s2, i32 2
  %r3 = insertelement <16 x i32> %r2, i32 %s3, i32 3
  %r4 = insertelement <16 x i32> %r3, i32 %s4, i32 4
  %r5 = insertelement <16 x i32> %r4, i32 %s5, i32 5
  %r6 = insertelement <16 x i32> %r5, i32 %s6, i32 6
  %r7 = insertelement <16 x i32> %r6, i32 %s7, i32 7
  %r8 = insertelement <16 x i32> %r7, i32 %s8, i32 8
  %r9 = insertelement <16 x i32> %r8, i32 %s9, i32 9
  %r10 = insertelement <16 x i32> %r9, i32 %s10, i32 10
  %r11 = insertelement <16 x i32> %r10, i32 %s11, i32 11
  %r12 = insertelement <16 x i32> %r11, i32 %s12, i32 12
  %r13 = insertelement <16 x i32> %r12, i32 %s13, i32 13
  %r14 = insertelement <16 x i32> %r13, i32 %s14, i32 14
  %r15 = insertelement <16 x i32> %r14, i32 %s15, i32 15

  ret <16 x i32> %r15
}


define <16 x float> @__exclusive_scan_add_float(<16 x float> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x float>
  %idvec1 = bitcast float zeroinitializer to <1 x float>
  %idvec = shufflevector <1 x float> %idvec1, <1 x float> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x float> %idvec, <16 x float> * %ptr
  %ptr32 = bitcast <16 x float> * %ptr to <16 x i32> *
  %vi = bitcast <16 x float> %v to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %ptr32, <16 x i32> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x float>  , <16 x float>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x float> %v_id, i32 0
  %v1 = extractelement <16 x float> %v_id, i32 1
  %v2 = extractelement <16 x float> %v_id, i32 2
  %v3 = extractelement <16 x float> %v_id, i32 3
  %v4 = extractelement <16 x float> %v_id, i32 4
  %v5 = extractelement <16 x float> %v_id, i32 5
  %v6 = extractelement <16 x float> %v_id, i32 6
  %v7 = extractelement <16 x float> %v_id, i32 7
  %v8 = extractelement <16 x float> %v_id, i32 8
  %v9 = extractelement <16 x float> %v_id, i32 9
  %v10 = extractelement <16 x float> %v_id, i32 10
  %v11 = extractelement <16 x float> %v_id, i32 11
  %v12 = extractelement <16 x float> %v_id, i32 12
  %v13 = extractelement <16 x float> %v_id, i32 13
  %v14 = extractelement <16 x float> %v_id, i32 14
  %v15 = extractelement <16 x float> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = fadd float zeroinitializer, %v0
  
  %s2 = fadd float %s1, %v1
  %s3 = fadd float %s2, %v2
  %s4 = fadd float %s3, %v3
  %s5 = fadd float %s4, %v4
  %s6 = fadd float %s5, %v5
  %s7 = fadd float %s6, %v6
  %s8 = fadd float %s7, %v7
  %s9 = fadd float %s8, %v8
  %s10 = fadd float %s9, %v9
  %s11 = fadd float %s10, %v10
  %s12 = fadd float %s11, %v11
  %s13 = fadd float %s12, %v12
  %s14 = fadd float %s13, %v13
  %s15 = fadd float %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x float> undef, float zeroinitializer, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x float> %r0, float %s1, i32 1
  %r2 = insertelement <16 x float> %r1, float %s2, i32 2
  %r3 = insertelement <16 x float> %r2, float %s3, i32 3
  %r4 = insertelement <16 x float> %r3, float %s4, i32 4
  %r5 = insertelement <16 x float> %r4, float %s5, i32 5
  %r6 = insertelement <16 x float> %r5, float %s6, i32 6
  %r7 = insertelement <16 x float> %r6, float %s7, i32 7
  %r8 = insertelement <16 x float> %r7, float %s8, i32 8
  %r9 = insertelement <16 x float> %r8, float %s9, i32 9
  %r10 = insertelement <16 x float> %r9, float %s10, i32 10
  %r11 = insertelement <16 x float> %r10, float %s11, i32 11
  %r12 = insertelement <16 x float> %r11, float %s12, i32 12
  %r13 = insertelement <16 x float> %r12, float %s13, i32 13
  %r14 = insertelement <16 x float> %r13, float %s14, i32 14
  %r15 = insertelement <16 x float> %r14, float %s15, i32 15

  ret <16 x float> %r15
}


define <16 x i64> @__exclusive_scan_add_i64(<16 x i64> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x i64>
  %idvec1 = bitcast i64 0 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idvec1, <1 x i64> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x i64> %idvec, <16 x i64> * %ptr
  %ptr64 = bitcast <16 x i64> * %ptr to <16 x i64> *
  %vi = bitcast <16 x i64> %v to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %ptr64, <16 x i64> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x i64>  , <16 x i64>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x i64> %v_id, i32 0
  %v1 = extractelement <16 x i64> %v_id, i32 1
  %v2 = extractelement <16 x i64> %v_id, i32 2
  %v3 = extractelement <16 x i64> %v_id, i32 3
  %v4 = extractelement <16 x i64> %v_id, i32 4
  %v5 = extractelement <16 x i64> %v_id, i32 5
  %v6 = extractelement <16 x i64> %v_id, i32 6
  %v7 = extractelement <16 x i64> %v_id, i32 7
  %v8 = extractelement <16 x i64> %v_id, i32 8
  %v9 = extractelement <16 x i64> %v_id, i32 9
  %v10 = extractelement <16 x i64> %v_id, i32 10
  %v11 = extractelement <16 x i64> %v_id, i32 11
  %v12 = extractelement <16 x i64> %v_id, i32 12
  %v13 = extractelement <16 x i64> %v_id, i32 13
  %v14 = extractelement <16 x i64> %v_id, i32 14
  %v15 = extractelement <16 x i64> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = add i64 0, %v0
  
  %s2 = add i64 %s1, %v1
  %s3 = add i64 %s2, %v2
  %s4 = add i64 %s3, %v3
  %s5 = add i64 %s4, %v4
  %s6 = add i64 %s5, %v5
  %s7 = add i64 %s6, %v6
  %s8 = add i64 %s7, %v7
  %s9 = add i64 %s8, %v8
  %s10 = add i64 %s9, %v9
  %s11 = add i64 %s10, %v10
  %s12 = add i64 %s11, %v11
  %s13 = add i64 %s12, %v12
  %s14 = add i64 %s13, %v13
  %s15 = add i64 %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x i64> undef, i64 0, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x i64> %r0, i64 %s1, i32 1
  %r2 = insertelement <16 x i64> %r1, i64 %s2, i32 2
  %r3 = insertelement <16 x i64> %r2, i64 %s3, i32 3
  %r4 = insertelement <16 x i64> %r3, i64 %s4, i32 4
  %r5 = insertelement <16 x i64> %r4, i64 %s5, i32 5
  %r6 = insertelement <16 x i64> %r5, i64 %s6, i32 6
  %r7 = insertelement <16 x i64> %r6, i64 %s7, i32 7
  %r8 = insertelement <16 x i64> %r7, i64 %s8, i32 8
  %r9 = insertelement <16 x i64> %r8, i64 %s9, i32 9
  %r10 = insertelement <16 x i64> %r9, i64 %s10, i32 10
  %r11 = insertelement <16 x i64> %r10, i64 %s11, i32 11
  %r12 = insertelement <16 x i64> %r11, i64 %s12, i32 12
  %r13 = insertelement <16 x i64> %r12, i64 %s13, i32 13
  %r14 = insertelement <16 x i64> %r13, i64 %s14, i32 14
  %r15 = insertelement <16 x i64> %r14, i64 %s15, i32 15

  ret <16 x i64> %r15
}


define <16 x double> @__exclusive_scan_add_double(<16 x double> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x double>
  %idvec1 = bitcast double zeroinitializer to <1 x double>
  %idvec = shufflevector <1 x double> %idvec1, <1 x double> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x double> %idvec, <16 x double> * %ptr
  %ptr64 = bitcast <16 x double> * %ptr to <16 x i64> *
  %vi = bitcast <16 x double> %v to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %ptr64, <16 x i64> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x double>  , <16 x double>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x double> %v_id, i32 0
  %v1 = extractelement <16 x double> %v_id, i32 1
  %v2 = extractelement <16 x double> %v_id, i32 2
  %v3 = extractelement <16 x double> %v_id, i32 3
  %v4 = extractelement <16 x double> %v_id, i32 4
  %v5 = extractelement <16 x double> %v_id, i32 5
  %v6 = extractelement <16 x double> %v_id, i32 6
  %v7 = extractelement <16 x double> %v_id, i32 7
  %v8 = extractelement <16 x double> %v_id, i32 8
  %v9 = extractelement <16 x double> %v_id, i32 9
  %v10 = extractelement <16 x double> %v_id, i32 10
  %v11 = extractelement <16 x double> %v_id, i32 11
  %v12 = extractelement <16 x double> %v_id, i32 12
  %v13 = extractelement <16 x double> %v_id, i32 13
  %v14 = extractelement <16 x double> %v_id, i32 14
  %v15 = extractelement <16 x double> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = fadd double zeroinitializer, %v0
  
  %s2 = fadd double %s1, %v1
  %s3 = fadd double %s2, %v2
  %s4 = fadd double %s3, %v3
  %s5 = fadd double %s4, %v4
  %s6 = fadd double %s5, %v5
  %s7 = fadd double %s6, %v6
  %s8 = fadd double %s7, %v7
  %s9 = fadd double %s8, %v8
  %s10 = fadd double %s9, %v9
  %s11 = fadd double %s10, %v10
  %s12 = fadd double %s11, %v11
  %s13 = fadd double %s12, %v12
  %s14 = fadd double %s13, %v13
  %s15 = fadd double %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x double> undef, double zeroinitializer, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x double> %r0, double %s1, i32 1
  %r2 = insertelement <16 x double> %r1, double %s2, i32 2
  %r3 = insertelement <16 x double> %r2, double %s3, i32 3
  %r4 = insertelement <16 x double> %r3, double %s4, i32 4
  %r5 = insertelement <16 x double> %r4, double %s5, i32 5
  %r6 = insertelement <16 x double> %r5, double %s6, i32 6
  %r7 = insertelement <16 x double> %r6, double %s7, i32 7
  %r8 = insertelement <16 x double> %r7, double %s8, i32 8
  %r9 = insertelement <16 x double> %r8, double %s9, i32 9
  %r10 = insertelement <16 x double> %r9, double %s10, i32 10
  %r11 = insertelement <16 x double> %r10, double %s11, i32 11
  %r12 = insertelement <16 x double> %r11, double %s12, i32 12
  %r13 = insertelement <16 x double> %r12, double %s13, i32 13
  %r14 = insertelement <16 x double> %r13, double %s14, i32 14
  %r15 = insertelement <16 x double> %r14, double %s15, i32 15

  ret <16 x double> %r15
}



define <16 x i32> @__exclusive_scan_and_i32(<16 x i32> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x i32>
  %idvec1 = bitcast i32 -1 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idvec1, <1 x i32> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x i32> %idvec, <16 x i32> * %ptr
  %ptr32 = bitcast <16 x i32> * %ptr to <16 x i32> *
  %vi = bitcast <16 x i32> %v to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %ptr32, <16 x i32> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x i32>  , <16 x i32>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x i32> %v_id, i32 0
  %v1 = extractelement <16 x i32> %v_id, i32 1
  %v2 = extractelement <16 x i32> %v_id, i32 2
  %v3 = extractelement <16 x i32> %v_id, i32 3
  %v4 = extractelement <16 x i32> %v_id, i32 4
  %v5 = extractelement <16 x i32> %v_id, i32 5
  %v6 = extractelement <16 x i32> %v_id, i32 6
  %v7 = extractelement <16 x i32> %v_id, i32 7
  %v8 = extractelement <16 x i32> %v_id, i32 8
  %v9 = extractelement <16 x i32> %v_id, i32 9
  %v10 = extractelement <16 x i32> %v_id, i32 10
  %v11 = extractelement <16 x i32> %v_id, i32 11
  %v12 = extractelement <16 x i32> %v_id, i32 12
  %v13 = extractelement <16 x i32> %v_id, i32 13
  %v14 = extractelement <16 x i32> %v_id, i32 14
  %v15 = extractelement <16 x i32> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = and i32 -1, %v0
  
  %s2 = and i32 %s1, %v1
  %s3 = and i32 %s2, %v2
  %s4 = and i32 %s3, %v3
  %s5 = and i32 %s4, %v4
  %s6 = and i32 %s5, %v5
  %s7 = and i32 %s6, %v6
  %s8 = and i32 %s7, %v7
  %s9 = and i32 %s8, %v8
  %s10 = and i32 %s9, %v9
  %s11 = and i32 %s10, %v10
  %s12 = and i32 %s11, %v11
  %s13 = and i32 %s12, %v12
  %s14 = and i32 %s13, %v13
  %s15 = and i32 %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x i32> undef, i32 -1, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x i32> %r0, i32 %s1, i32 1
  %r2 = insertelement <16 x i32> %r1, i32 %s2, i32 2
  %r3 = insertelement <16 x i32> %r2, i32 %s3, i32 3
  %r4 = insertelement <16 x i32> %r3, i32 %s4, i32 4
  %r5 = insertelement <16 x i32> %r4, i32 %s5, i32 5
  %r6 = insertelement <16 x i32> %r5, i32 %s6, i32 6
  %r7 = insertelement <16 x i32> %r6, i32 %s7, i32 7
  %r8 = insertelement <16 x i32> %r7, i32 %s8, i32 8
  %r9 = insertelement <16 x i32> %r8, i32 %s9, i32 9
  %r10 = insertelement <16 x i32> %r9, i32 %s10, i32 10
  %r11 = insertelement <16 x i32> %r10, i32 %s11, i32 11
  %r12 = insertelement <16 x i32> %r11, i32 %s12, i32 12
  %r13 = insertelement <16 x i32> %r12, i32 %s13, i32 13
  %r14 = insertelement <16 x i32> %r13, i32 %s14, i32 14
  %r15 = insertelement <16 x i32> %r14, i32 %s15, i32 15

  ret <16 x i32> %r15
}


define <16 x i64> @__exclusive_scan_and_i64(<16 x i64> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x i64>
  %idvec1 = bitcast i64 -1 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idvec1, <1 x i64> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x i64> %idvec, <16 x i64> * %ptr
  %ptr64 = bitcast <16 x i64> * %ptr to <16 x i64> *
  %vi = bitcast <16 x i64> %v to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %ptr64, <16 x i64> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x i64>  , <16 x i64>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x i64> %v_id, i32 0
  %v1 = extractelement <16 x i64> %v_id, i32 1
  %v2 = extractelement <16 x i64> %v_id, i32 2
  %v3 = extractelement <16 x i64> %v_id, i32 3
  %v4 = extractelement <16 x i64> %v_id, i32 4
  %v5 = extractelement <16 x i64> %v_id, i32 5
  %v6 = extractelement <16 x i64> %v_id, i32 6
  %v7 = extractelement <16 x i64> %v_id, i32 7
  %v8 = extractelement <16 x i64> %v_id, i32 8
  %v9 = extractelement <16 x i64> %v_id, i32 9
  %v10 = extractelement <16 x i64> %v_id, i32 10
  %v11 = extractelement <16 x i64> %v_id, i32 11
  %v12 = extractelement <16 x i64> %v_id, i32 12
  %v13 = extractelement <16 x i64> %v_id, i32 13
  %v14 = extractelement <16 x i64> %v_id, i32 14
  %v15 = extractelement <16 x i64> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = and i64 -1, %v0
  
  %s2 = and i64 %s1, %v1
  %s3 = and i64 %s2, %v2
  %s4 = and i64 %s3, %v3
  %s5 = and i64 %s4, %v4
  %s6 = and i64 %s5, %v5
  %s7 = and i64 %s6, %v6
  %s8 = and i64 %s7, %v7
  %s9 = and i64 %s8, %v8
  %s10 = and i64 %s9, %v9
  %s11 = and i64 %s10, %v10
  %s12 = and i64 %s11, %v11
  %s13 = and i64 %s12, %v12
  %s14 = and i64 %s13, %v13
  %s15 = and i64 %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x i64> undef, i64 -1, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x i64> %r0, i64 %s1, i32 1
  %r2 = insertelement <16 x i64> %r1, i64 %s2, i32 2
  %r3 = insertelement <16 x i64> %r2, i64 %s3, i32 3
  %r4 = insertelement <16 x i64> %r3, i64 %s4, i32 4
  %r5 = insertelement <16 x i64> %r4, i64 %s5, i32 5
  %r6 = insertelement <16 x i64> %r5, i64 %s6, i32 6
  %r7 = insertelement <16 x i64> %r6, i64 %s7, i32 7
  %r8 = insertelement <16 x i64> %r7, i64 %s8, i32 8
  %r9 = insertelement <16 x i64> %r8, i64 %s9, i32 9
  %r10 = insertelement <16 x i64> %r9, i64 %s10, i32 10
  %r11 = insertelement <16 x i64> %r10, i64 %s11, i32 11
  %r12 = insertelement <16 x i64> %r11, i64 %s12, i32 12
  %r13 = insertelement <16 x i64> %r12, i64 %s13, i32 13
  %r14 = insertelement <16 x i64> %r13, i64 %s14, i32 14
  %r15 = insertelement <16 x i64> %r14, i64 %s15, i32 15

  ret <16 x i64> %r15
}



define <16 x i32> @__exclusive_scan_or_i32(<16 x i32> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x i32>
  %idvec1 = bitcast i32 0 to <1 x i32>
  %idvec = shufflevector <1 x i32> %idvec1, <1 x i32> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x i32> %idvec, <16 x i32> * %ptr
  %ptr32 = bitcast <16 x i32> * %ptr to <16 x i32> *
  %vi = bitcast <16 x i32> %v to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %ptr32, <16 x i32> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x i32>  , <16 x i32>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x i32> %v_id, i32 0
  %v1 = extractelement <16 x i32> %v_id, i32 1
  %v2 = extractelement <16 x i32> %v_id, i32 2
  %v3 = extractelement <16 x i32> %v_id, i32 3
  %v4 = extractelement <16 x i32> %v_id, i32 4
  %v5 = extractelement <16 x i32> %v_id, i32 5
  %v6 = extractelement <16 x i32> %v_id, i32 6
  %v7 = extractelement <16 x i32> %v_id, i32 7
  %v8 = extractelement <16 x i32> %v_id, i32 8
  %v9 = extractelement <16 x i32> %v_id, i32 9
  %v10 = extractelement <16 x i32> %v_id, i32 10
  %v11 = extractelement <16 x i32> %v_id, i32 11
  %v12 = extractelement <16 x i32> %v_id, i32 12
  %v13 = extractelement <16 x i32> %v_id, i32 13
  %v14 = extractelement <16 x i32> %v_id, i32 14
  %v15 = extractelement <16 x i32> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = or i32 0, %v0
  
  %s2 = or i32 %s1, %v1
  %s3 = or i32 %s2, %v2
  %s4 = or i32 %s3, %v3
  %s5 = or i32 %s4, %v4
  %s6 = or i32 %s5, %v5
  %s7 = or i32 %s6, %v6
  %s8 = or i32 %s7, %v7
  %s9 = or i32 %s8, %v8
  %s10 = or i32 %s9, %v9
  %s11 = or i32 %s10, %v10
  %s12 = or i32 %s11, %v11
  %s13 = or i32 %s12, %v12
  %s14 = or i32 %s13, %v13
  %s15 = or i32 %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x i32> undef, i32 0, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x i32> %r0, i32 %s1, i32 1
  %r2 = insertelement <16 x i32> %r1, i32 %s2, i32 2
  %r3 = insertelement <16 x i32> %r2, i32 %s3, i32 3
  %r4 = insertelement <16 x i32> %r3, i32 %s4, i32 4
  %r5 = insertelement <16 x i32> %r4, i32 %s5, i32 5
  %r6 = insertelement <16 x i32> %r5, i32 %s6, i32 6
  %r7 = insertelement <16 x i32> %r6, i32 %s7, i32 7
  %r8 = insertelement <16 x i32> %r7, i32 %s8, i32 8
  %r9 = insertelement <16 x i32> %r8, i32 %s9, i32 9
  %r10 = insertelement <16 x i32> %r9, i32 %s10, i32 10
  %r11 = insertelement <16 x i32> %r10, i32 %s11, i32 11
  %r12 = insertelement <16 x i32> %r11, i32 %s12, i32 12
  %r13 = insertelement <16 x i32> %r12, i32 %s13, i32 13
  %r14 = insertelement <16 x i32> %r13, i32 %s14, i32 14
  %r15 = insertelement <16 x i32> %r14, i32 %s15, i32 15

  ret <16 x i32> %r15
}


define <16 x i64> @__exclusive_scan_or_i64(<16 x i64> %v,
                                  <16 x i8> %mask) nounwind alwaysinline {
  ; first, set the value of any off lanes to the identity value
  %ptr = alloca <16 x i64>
  %idvec1 = bitcast i64 0 to <1 x i64>
  %idvec = shufflevector <1 x i64> %idvec1, <1 x i64> undef,
      <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >
  store <16 x i64> %idvec, <16 x i64> * %ptr
  %ptr64 = bitcast <16 x i64> * %ptr to <16 x i64> *
  %vi = bitcast <16 x i64> %v to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %ptr64, <16 x i64> %vi,
                                      <16 x i8> %mask)
  %v_id = load <16 x i64>  , <16 x i64>  *
  %ptr

  ; extract elements of the vector to use in computing the scan
  
  %v0 = extractelement <16 x i64> %v_id, i32 0
  %v1 = extractelement <16 x i64> %v_id, i32 1
  %v2 = extractelement <16 x i64> %v_id, i32 2
  %v3 = extractelement <16 x i64> %v_id, i32 3
  %v4 = extractelement <16 x i64> %v_id, i32 4
  %v5 = extractelement <16 x i64> %v_id, i32 5
  %v6 = extractelement <16 x i64> %v_id, i32 6
  %v7 = extractelement <16 x i64> %v_id, i32 7
  %v8 = extractelement <16 x i64> %v_id, i32 8
  %v9 = extractelement <16 x i64> %v_id, i32 9
  %v10 = extractelement <16 x i64> %v_id, i32 10
  %v11 = extractelement <16 x i64> %v_id, i32 11
  %v12 = extractelement <16 x i64> %v_id, i32 12
  %v13 = extractelement <16 x i64> %v_id, i32 13
  %v14 = extractelement <16 x i64> %v_id, i32 14
  %v15 = extractelement <16 x i64> %v_id, i32 15

  ; and just compute the scan directly.
  ; 0th element is the identity (so nothing to do here),
  ; 1st element is identity (op) the 0th element of the original vector,
  ; each successive element is the previous element (op) the previous element
  ;  of the original vector
  %s1 = or i64 0, %v0
  
  %s2 = or i64 %s1, %v1
  %s3 = or i64 %s2, %v2
  %s4 = or i64 %s3, %v3
  %s5 = or i64 %s4, %v4
  %s6 = or i64 %s5, %v5
  %s7 = or i64 %s6, %v6
  %s8 = or i64 %s7, %v7
  %s9 = or i64 %s8, %v8
  %s10 = or i64 %s9, %v9
  %s11 = or i64 %s10, %v10
  %s12 = or i64 %s11, %v11
  %s13 = or i64 %s12, %v12
  %s14 = or i64 %s13, %v13
  %s15 = or i64 %s14, %v14

  ; and fill in the result vector
  %r0 = insertelement <16 x i64> undef, i64 0, i32 0  ; 0th element gets identity
  
  %r1 = insertelement <16 x i64> %r0, i64 %s1, i32 1
  %r2 = insertelement <16 x i64> %r1, i64 %s2, i32 2
  %r3 = insertelement <16 x i64> %r2, i64 %s3, i32 3
  %r4 = insertelement <16 x i64> %r3, i64 %s4, i32 4
  %r5 = insertelement <16 x i64> %r4, i64 %s5, i32 5
  %r6 = insertelement <16 x i64> %r5, i64 %s6, i32 6
  %r7 = insertelement <16 x i64> %r6, i64 %s7, i32 7
  %r8 = insertelement <16 x i64> %r7, i64 %s8, i32 8
  %r9 = insertelement <16 x i64> %r8, i64 %s9, i32 9
  %r10 = insertelement <16 x i64> %r9, i64 %s10, i32 10
  %r11 = insertelement <16 x i64> %r10, i64 %s11, i32 11
  %r12 = insertelement <16 x i64> %r11, i64 %s12, i32 12
  %r13 = insertelement <16 x i64> %r12, i64 %s13, i32 13
  %r14 = insertelement <16 x i64> %r13, i64 %s14, i32 14
  %r15 = insertelement <16 x i64> %r14, i64 %s15, i32 15

  ret <16 x i64> %r15
}




define i64 @__min_uniform_int64(i64, i64) nounwind alwaysinline readnone {
  %c = icmp slt i64 %0, %1
  %r = select i1 %c, i64 %0, i64 %1
  ret i64 %r
}

define <16 x i64> @__min_varying_int64(<16 x i64>, <16 x i64>) nounwind alwaysinline readnone {
  %rptr = alloca <16 x i64>
  %r64ptr = bitcast <16 x i64> * %rptr to i64 *

  
  %v0_0 = extractelement <16 x i64> %0, i32 0
  %v1_0 = extractelement <16 x i64> %1, i32 0
  %c_0 = icmp slt i64 %v0_0, %v1_0
  %v_0 = select i1 %c_0, i64 %v0_0, i64 %v1_0
  %ptr_0 = getelementptr i64 , i64 *
 %r64ptr, i32 0
  store i64 %v_0, i64 * %ptr_0

  %v0_1 = extractelement <16 x i64> %0, i32 1
  %v1_1 = extractelement <16 x i64> %1, i32 1
  %c_1 = icmp slt i64 %v0_1, %v1_1
  %v_1 = select i1 %c_1, i64 %v0_1, i64 %v1_1
  %ptr_1 = getelementptr i64 , i64 *
 %r64ptr, i32 1
  store i64 %v_1, i64 * %ptr_1

  %v0_2 = extractelement <16 x i64> %0, i32 2
  %v1_2 = extractelement <16 x i64> %1, i32 2
  %c_2 = icmp slt i64 %v0_2, %v1_2
  %v_2 = select i1 %c_2, i64 %v0_2, i64 %v1_2
  %ptr_2 = getelementptr i64 , i64 *
 %r64ptr, i32 2
  store i64 %v_2, i64 * %ptr_2

  %v0_3 = extractelement <16 x i64> %0, i32 3
  %v1_3 = extractelement <16 x i64> %1, i32 3
  %c_3 = icmp slt i64 %v0_3, %v1_3
  %v_3 = select i1 %c_3, i64 %v0_3, i64 %v1_3
  %ptr_3 = getelementptr i64 , i64 *
 %r64ptr, i32 3
  store i64 %v_3, i64 * %ptr_3

  %v0_4 = extractelement <16 x i64> %0, i32 4
  %v1_4 = extractelement <16 x i64> %1, i32 4
  %c_4 = icmp slt i64 %v0_4, %v1_4
  %v_4 = select i1 %c_4, i64 %v0_4, i64 %v1_4
  %ptr_4 = getelementptr i64 , i64 *
 %r64ptr, i32 4
  store i64 %v_4, i64 * %ptr_4

  %v0_5 = extractelement <16 x i64> %0, i32 5
  %v1_5 = extractelement <16 x i64> %1, i32 5
  %c_5 = icmp slt i64 %v0_5, %v1_5
  %v_5 = select i1 %c_5, i64 %v0_5, i64 %v1_5
  %ptr_5 = getelementptr i64 , i64 *
 %r64ptr, i32 5
  store i64 %v_5, i64 * %ptr_5

  %v0_6 = extractelement <16 x i64> %0, i32 6
  %v1_6 = extractelement <16 x i64> %1, i32 6
  %c_6 = icmp slt i64 %v0_6, %v1_6
  %v_6 = select i1 %c_6, i64 %v0_6, i64 %v1_6
  %ptr_6 = getelementptr i64 , i64 *
 %r64ptr, i32 6
  store i64 %v_6, i64 * %ptr_6

  %v0_7 = extractelement <16 x i64> %0, i32 7
  %v1_7 = extractelement <16 x i64> %1, i32 7
  %c_7 = icmp slt i64 %v0_7, %v1_7
  %v_7 = select i1 %c_7, i64 %v0_7, i64 %v1_7
  %ptr_7 = getelementptr i64 , i64 *
 %r64ptr, i32 7
  store i64 %v_7, i64 * %ptr_7

  %v0_8 = extractelement <16 x i64> %0, i32 8
  %v1_8 = extractelement <16 x i64> %1, i32 8
  %c_8 = icmp slt i64 %v0_8, %v1_8
  %v_8 = select i1 %c_8, i64 %v0_8, i64 %v1_8
  %ptr_8 = getelementptr i64 , i64 *
 %r64ptr, i32 8
  store i64 %v_8, i64 * %ptr_8

  %v0_9 = extractelement <16 x i64> %0, i32 9
  %v1_9 = extractelement <16 x i64> %1, i32 9
  %c_9 = icmp slt i64 %v0_9, %v1_9
  %v_9 = select i1 %c_9, i64 %v0_9, i64 %v1_9
  %ptr_9 = getelementptr i64 , i64 *
 %r64ptr, i32 9
  store i64 %v_9, i64 * %ptr_9

  %v0_10 = extractelement <16 x i64> %0, i32 10
  %v1_10 = extractelement <16 x i64> %1, i32 10
  %c_10 = icmp slt i64 %v0_10, %v1_10
  %v_10 = select i1 %c_10, i64 %v0_10, i64 %v1_10
  %ptr_10 = getelementptr i64 , i64 *
 %r64ptr, i32 10
  store i64 %v_10, i64 * %ptr_10

  %v0_11 = extractelement <16 x i64> %0, i32 11
  %v1_11 = extractelement <16 x i64> %1, i32 11
  %c_11 = icmp slt i64 %v0_11, %v1_11
  %v_11 = select i1 %c_11, i64 %v0_11, i64 %v1_11
  %ptr_11 = getelementptr i64 , i64 *
 %r64ptr, i32 11
  store i64 %v_11, i64 * %ptr_11

  %v0_12 = extractelement <16 x i64> %0, i32 12
  %v1_12 = extractelement <16 x i64> %1, i32 12
  %c_12 = icmp slt i64 %v0_12, %v1_12
  %v_12 = select i1 %c_12, i64 %v0_12, i64 %v1_12
  %ptr_12 = getelementptr i64 , i64 *
 %r64ptr, i32 12
  store i64 %v_12, i64 * %ptr_12

  %v0_13 = extractelement <16 x i64> %0, i32 13
  %v1_13 = extractelement <16 x i64> %1, i32 13
  %c_13 = icmp slt i64 %v0_13, %v1_13
  %v_13 = select i1 %c_13, i64 %v0_13, i64 %v1_13
  %ptr_13 = getelementptr i64 , i64 *
 %r64ptr, i32 13
  store i64 %v_13, i64 * %ptr_13

  %v0_14 = extractelement <16 x i64> %0, i32 14
  %v1_14 = extractelement <16 x i64> %1, i32 14
  %c_14 = icmp slt i64 %v0_14, %v1_14
  %v_14 = select i1 %c_14, i64 %v0_14, i64 %v1_14
  %ptr_14 = getelementptr i64 , i64 *
 %r64ptr, i32 14
  store i64 %v_14, i64 * %ptr_14

  %v0_15 = extractelement <16 x i64> %0, i32 15
  %v1_15 = extractelement <16 x i64> %1, i32 15
  %c_15 = icmp slt i64 %v0_15, %v1_15
  %v_15 = select i1 %c_15, i64 %v0_15, i64 %v1_15
  %ptr_15 = getelementptr i64 , i64 *
 %r64ptr, i32 15
  store i64 %v_15, i64 * %ptr_15
                  

  %ret = load <16 x i64>  , <16 x i64>  *
  %rptr
  ret <16 x i64> %ret
}


define i64 @__max_uniform_int64(i64, i64) nounwind alwaysinline readnone {
  %c = icmp sgt i64 %0, %1
  %r = select i1 %c, i64 %0, i64 %1
  ret i64 %r
}

define <16 x i64> @__max_varying_int64(<16 x i64>, <16 x i64>) nounwind alwaysinline readnone {
  %rptr = alloca <16 x i64>
  %r64ptr = bitcast <16 x i64> * %rptr to i64 *

  
  %v0_0 = extractelement <16 x i64> %0, i32 0
  %v1_0 = extractelement <16 x i64> %1, i32 0
  %c_0 = icmp sgt i64 %v0_0, %v1_0
  %v_0 = select i1 %c_0, i64 %v0_0, i64 %v1_0
  %ptr_0 = getelementptr i64 , i64 *
 %r64ptr, i32 0
  store i64 %v_0, i64 * %ptr_0

  %v0_1 = extractelement <16 x i64> %0, i32 1
  %v1_1 = extractelement <16 x i64> %1, i32 1
  %c_1 = icmp sgt i64 %v0_1, %v1_1
  %v_1 = select i1 %c_1, i64 %v0_1, i64 %v1_1
  %ptr_1 = getelementptr i64 , i64 *
 %r64ptr, i32 1
  store i64 %v_1, i64 * %ptr_1

  %v0_2 = extractelement <16 x i64> %0, i32 2
  %v1_2 = extractelement <16 x i64> %1, i32 2
  %c_2 = icmp sgt i64 %v0_2, %v1_2
  %v_2 = select i1 %c_2, i64 %v0_2, i64 %v1_2
  %ptr_2 = getelementptr i64 , i64 *
 %r64ptr, i32 2
  store i64 %v_2, i64 * %ptr_2

  %v0_3 = extractelement <16 x i64> %0, i32 3
  %v1_3 = extractelement <16 x i64> %1, i32 3
  %c_3 = icmp sgt i64 %v0_3, %v1_3
  %v_3 = select i1 %c_3, i64 %v0_3, i64 %v1_3
  %ptr_3 = getelementptr i64 , i64 *
 %r64ptr, i32 3
  store i64 %v_3, i64 * %ptr_3

  %v0_4 = extractelement <16 x i64> %0, i32 4
  %v1_4 = extractelement <16 x i64> %1, i32 4
  %c_4 = icmp sgt i64 %v0_4, %v1_4
  %v_4 = select i1 %c_4, i64 %v0_4, i64 %v1_4
  %ptr_4 = getelementptr i64 , i64 *
 %r64ptr, i32 4
  store i64 %v_4, i64 * %ptr_4

  %v0_5 = extractelement <16 x i64> %0, i32 5
  %v1_5 = extractelement <16 x i64> %1, i32 5
  %c_5 = icmp sgt i64 %v0_5, %v1_5
  %v_5 = select i1 %c_5, i64 %v0_5, i64 %v1_5
  %ptr_5 = getelementptr i64 , i64 *
 %r64ptr, i32 5
  store i64 %v_5, i64 * %ptr_5

  %v0_6 = extractelement <16 x i64> %0, i32 6
  %v1_6 = extractelement <16 x i64> %1, i32 6
  %c_6 = icmp sgt i64 %v0_6, %v1_6
  %v_6 = select i1 %c_6, i64 %v0_6, i64 %v1_6
  %ptr_6 = getelementptr i64 , i64 *
 %r64ptr, i32 6
  store i64 %v_6, i64 * %ptr_6

  %v0_7 = extractelement <16 x i64> %0, i32 7
  %v1_7 = extractelement <16 x i64> %1, i32 7
  %c_7 = icmp sgt i64 %v0_7, %v1_7
  %v_7 = select i1 %c_7, i64 %v0_7, i64 %v1_7
  %ptr_7 = getelementptr i64 , i64 *
 %r64ptr, i32 7
  store i64 %v_7, i64 * %ptr_7

  %v0_8 = extractelement <16 x i64> %0, i32 8
  %v1_8 = extractelement <16 x i64> %1, i32 8
  %c_8 = icmp sgt i64 %v0_8, %v1_8
  %v_8 = select i1 %c_8, i64 %v0_8, i64 %v1_8
  %ptr_8 = getelementptr i64 , i64 *
 %r64ptr, i32 8
  store i64 %v_8, i64 * %ptr_8

  %v0_9 = extractelement <16 x i64> %0, i32 9
  %v1_9 = extractelement <16 x i64> %1, i32 9
  %c_9 = icmp sgt i64 %v0_9, %v1_9
  %v_9 = select i1 %c_9, i64 %v0_9, i64 %v1_9
  %ptr_9 = getelementptr i64 , i64 *
 %r64ptr, i32 9
  store i64 %v_9, i64 * %ptr_9

  %v0_10 = extractelement <16 x i64> %0, i32 10
  %v1_10 = extractelement <16 x i64> %1, i32 10
  %c_10 = icmp sgt i64 %v0_10, %v1_10
  %v_10 = select i1 %c_10, i64 %v0_10, i64 %v1_10
  %ptr_10 = getelementptr i64 , i64 *
 %r64ptr, i32 10
  store i64 %v_10, i64 * %ptr_10

  %v0_11 = extractelement <16 x i64> %0, i32 11
  %v1_11 = extractelement <16 x i64> %1, i32 11
  %c_11 = icmp sgt i64 %v0_11, %v1_11
  %v_11 = select i1 %c_11, i64 %v0_11, i64 %v1_11
  %ptr_11 = getelementptr i64 , i64 *
 %r64ptr, i32 11
  store i64 %v_11, i64 * %ptr_11

  %v0_12 = extractelement <16 x i64> %0, i32 12
  %v1_12 = extractelement <16 x i64> %1, i32 12
  %c_12 = icmp sgt i64 %v0_12, %v1_12
  %v_12 = select i1 %c_12, i64 %v0_12, i64 %v1_12
  %ptr_12 = getelementptr i64 , i64 *
 %r64ptr, i32 12
  store i64 %v_12, i64 * %ptr_12

  %v0_13 = extractelement <16 x i64> %0, i32 13
  %v1_13 = extractelement <16 x i64> %1, i32 13
  %c_13 = icmp sgt i64 %v0_13, %v1_13
  %v_13 = select i1 %c_13, i64 %v0_13, i64 %v1_13
  %ptr_13 = getelementptr i64 , i64 *
 %r64ptr, i32 13
  store i64 %v_13, i64 * %ptr_13

  %v0_14 = extractelement <16 x i64> %0, i32 14
  %v1_14 = extractelement <16 x i64> %1, i32 14
  %c_14 = icmp sgt i64 %v0_14, %v1_14
  %v_14 = select i1 %c_14, i64 %v0_14, i64 %v1_14
  %ptr_14 = getelementptr i64 , i64 *
 %r64ptr, i32 14
  store i64 %v_14, i64 * %ptr_14

  %v0_15 = extractelement <16 x i64> %0, i32 15
  %v1_15 = extractelement <16 x i64> %1, i32 15
  %c_15 = icmp sgt i64 %v0_15, %v1_15
  %v_15 = select i1 %c_15, i64 %v0_15, i64 %v1_15
  %ptr_15 = getelementptr i64 , i64 *
 %r64ptr, i32 15
  store i64 %v_15, i64 * %ptr_15
                  

  %ret = load <16 x i64>  , <16 x i64>  *
  %rptr
  ret <16 x i64> %ret
}


define i64 @__min_uniform_uint64(i64, i64) nounwind alwaysinline readnone {
  %c = icmp ult i64 %0, %1
  %r = select i1 %c, i64 %0, i64 %1
  ret i64 %r
}

define <16 x i64> @__min_varying_uint64(<16 x i64>, <16 x i64>) nounwind alwaysinline readnone {
  %rptr = alloca <16 x i64>
  %r64ptr = bitcast <16 x i64> * %rptr to i64 *

  
  %v0_0 = extractelement <16 x i64> %0, i32 0
  %v1_0 = extractelement <16 x i64> %1, i32 0
  %c_0 = icmp ult i64 %v0_0, %v1_0
  %v_0 = select i1 %c_0, i64 %v0_0, i64 %v1_0
  %ptr_0 = getelementptr i64 , i64 *
 %r64ptr, i32 0
  store i64 %v_0, i64 * %ptr_0

  %v0_1 = extractelement <16 x i64> %0, i32 1
  %v1_1 = extractelement <16 x i64> %1, i32 1
  %c_1 = icmp ult i64 %v0_1, %v1_1
  %v_1 = select i1 %c_1, i64 %v0_1, i64 %v1_1
  %ptr_1 = getelementptr i64 , i64 *
 %r64ptr, i32 1
  store i64 %v_1, i64 * %ptr_1

  %v0_2 = extractelement <16 x i64> %0, i32 2
  %v1_2 = extractelement <16 x i64> %1, i32 2
  %c_2 = icmp ult i64 %v0_2, %v1_2
  %v_2 = select i1 %c_2, i64 %v0_2, i64 %v1_2
  %ptr_2 = getelementptr i64 , i64 *
 %r64ptr, i32 2
  store i64 %v_2, i64 * %ptr_2

  %v0_3 = extractelement <16 x i64> %0, i32 3
  %v1_3 = extractelement <16 x i64> %1, i32 3
  %c_3 = icmp ult i64 %v0_3, %v1_3
  %v_3 = select i1 %c_3, i64 %v0_3, i64 %v1_3
  %ptr_3 = getelementptr i64 , i64 *
 %r64ptr, i32 3
  store i64 %v_3, i64 * %ptr_3

  %v0_4 = extractelement <16 x i64> %0, i32 4
  %v1_4 = extractelement <16 x i64> %1, i32 4
  %c_4 = icmp ult i64 %v0_4, %v1_4
  %v_4 = select i1 %c_4, i64 %v0_4, i64 %v1_4
  %ptr_4 = getelementptr i64 , i64 *
 %r64ptr, i32 4
  store i64 %v_4, i64 * %ptr_4

  %v0_5 = extractelement <16 x i64> %0, i32 5
  %v1_5 = extractelement <16 x i64> %1, i32 5
  %c_5 = icmp ult i64 %v0_5, %v1_5
  %v_5 = select i1 %c_5, i64 %v0_5, i64 %v1_5
  %ptr_5 = getelementptr i64 , i64 *
 %r64ptr, i32 5
  store i64 %v_5, i64 * %ptr_5

  %v0_6 = extractelement <16 x i64> %0, i32 6
  %v1_6 = extractelement <16 x i64> %1, i32 6
  %c_6 = icmp ult i64 %v0_6, %v1_6
  %v_6 = select i1 %c_6, i64 %v0_6, i64 %v1_6
  %ptr_6 = getelementptr i64 , i64 *
 %r64ptr, i32 6
  store i64 %v_6, i64 * %ptr_6

  %v0_7 = extractelement <16 x i64> %0, i32 7
  %v1_7 = extractelement <16 x i64> %1, i32 7
  %c_7 = icmp ult i64 %v0_7, %v1_7
  %v_7 = select i1 %c_7, i64 %v0_7, i64 %v1_7
  %ptr_7 = getelementptr i64 , i64 *
 %r64ptr, i32 7
  store i64 %v_7, i64 * %ptr_7

  %v0_8 = extractelement <16 x i64> %0, i32 8
  %v1_8 = extractelement <16 x i64> %1, i32 8
  %c_8 = icmp ult i64 %v0_8, %v1_8
  %v_8 = select i1 %c_8, i64 %v0_8, i64 %v1_8
  %ptr_8 = getelementptr i64 , i64 *
 %r64ptr, i32 8
  store i64 %v_8, i64 * %ptr_8

  %v0_9 = extractelement <16 x i64> %0, i32 9
  %v1_9 = extractelement <16 x i64> %1, i32 9
  %c_9 = icmp ult i64 %v0_9, %v1_9
  %v_9 = select i1 %c_9, i64 %v0_9, i64 %v1_9
  %ptr_9 = getelementptr i64 , i64 *
 %r64ptr, i32 9
  store i64 %v_9, i64 * %ptr_9

  %v0_10 = extractelement <16 x i64> %0, i32 10
  %v1_10 = extractelement <16 x i64> %1, i32 10
  %c_10 = icmp ult i64 %v0_10, %v1_10
  %v_10 = select i1 %c_10, i64 %v0_10, i64 %v1_10
  %ptr_10 = getelementptr i64 , i64 *
 %r64ptr, i32 10
  store i64 %v_10, i64 * %ptr_10

  %v0_11 = extractelement <16 x i64> %0, i32 11
  %v1_11 = extractelement <16 x i64> %1, i32 11
  %c_11 = icmp ult i64 %v0_11, %v1_11
  %v_11 = select i1 %c_11, i64 %v0_11, i64 %v1_11
  %ptr_11 = getelementptr i64 , i64 *
 %r64ptr, i32 11
  store i64 %v_11, i64 * %ptr_11

  %v0_12 = extractelement <16 x i64> %0, i32 12
  %v1_12 = extractelement <16 x i64> %1, i32 12
  %c_12 = icmp ult i64 %v0_12, %v1_12
  %v_12 = select i1 %c_12, i64 %v0_12, i64 %v1_12
  %ptr_12 = getelementptr i64 , i64 *
 %r64ptr, i32 12
  store i64 %v_12, i64 * %ptr_12

  %v0_13 = extractelement <16 x i64> %0, i32 13
  %v1_13 = extractelement <16 x i64> %1, i32 13
  %c_13 = icmp ult i64 %v0_13, %v1_13
  %v_13 = select i1 %c_13, i64 %v0_13, i64 %v1_13
  %ptr_13 = getelementptr i64 , i64 *
 %r64ptr, i32 13
  store i64 %v_13, i64 * %ptr_13

  %v0_14 = extractelement <16 x i64> %0, i32 14
  %v1_14 = extractelement <16 x i64> %1, i32 14
  %c_14 = icmp ult i64 %v0_14, %v1_14
  %v_14 = select i1 %c_14, i64 %v0_14, i64 %v1_14
  %ptr_14 = getelementptr i64 , i64 *
 %r64ptr, i32 14
  store i64 %v_14, i64 * %ptr_14

  %v0_15 = extractelement <16 x i64> %0, i32 15
  %v1_15 = extractelement <16 x i64> %1, i32 15
  %c_15 = icmp ult i64 %v0_15, %v1_15
  %v_15 = select i1 %c_15, i64 %v0_15, i64 %v1_15
  %ptr_15 = getelementptr i64 , i64 *
 %r64ptr, i32 15
  store i64 %v_15, i64 * %ptr_15
                  

  %ret = load <16 x i64>  , <16 x i64>  *
  %rptr
  ret <16 x i64> %ret
}


define i64 @__max_uniform_uint64(i64, i64) nounwind alwaysinline readnone {
  %c = icmp ugt i64 %0, %1
  %r = select i1 %c, i64 %0, i64 %1
  ret i64 %r
}

define <16 x i64> @__max_varying_uint64(<16 x i64>, <16 x i64>) nounwind alwaysinline readnone {
  %rptr = alloca <16 x i64>
  %r64ptr = bitcast <16 x i64> * %rptr to i64 *

  
  %v0_0 = extractelement <16 x i64> %0, i32 0
  %v1_0 = extractelement <16 x i64> %1, i32 0
  %c_0 = icmp ugt i64 %v0_0, %v1_0
  %v_0 = select i1 %c_0, i64 %v0_0, i64 %v1_0
  %ptr_0 = getelementptr i64 , i64 *
 %r64ptr, i32 0
  store i64 %v_0, i64 * %ptr_0

  %v0_1 = extractelement <16 x i64> %0, i32 1
  %v1_1 = extractelement <16 x i64> %1, i32 1
  %c_1 = icmp ugt i64 %v0_1, %v1_1
  %v_1 = select i1 %c_1, i64 %v0_1, i64 %v1_1
  %ptr_1 = getelementptr i64 , i64 *
 %r64ptr, i32 1
  store i64 %v_1, i64 * %ptr_1

  %v0_2 = extractelement <16 x i64> %0, i32 2
  %v1_2 = extractelement <16 x i64> %1, i32 2
  %c_2 = icmp ugt i64 %v0_2, %v1_2
  %v_2 = select i1 %c_2, i64 %v0_2, i64 %v1_2
  %ptr_2 = getelementptr i64 , i64 *
 %r64ptr, i32 2
  store i64 %v_2, i64 * %ptr_2

  %v0_3 = extractelement <16 x i64> %0, i32 3
  %v1_3 = extractelement <16 x i64> %1, i32 3
  %c_3 = icmp ugt i64 %v0_3, %v1_3
  %v_3 = select i1 %c_3, i64 %v0_3, i64 %v1_3
  %ptr_3 = getelementptr i64 , i64 *
 %r64ptr, i32 3
  store i64 %v_3, i64 * %ptr_3

  %v0_4 = extractelement <16 x i64> %0, i32 4
  %v1_4 = extractelement <16 x i64> %1, i32 4
  %c_4 = icmp ugt i64 %v0_4, %v1_4
  %v_4 = select i1 %c_4, i64 %v0_4, i64 %v1_4
  %ptr_4 = getelementptr i64 , i64 *
 %r64ptr, i32 4
  store i64 %v_4, i64 * %ptr_4

  %v0_5 = extractelement <16 x i64> %0, i32 5
  %v1_5 = extractelement <16 x i64> %1, i32 5
  %c_5 = icmp ugt i64 %v0_5, %v1_5
  %v_5 = select i1 %c_5, i64 %v0_5, i64 %v1_5
  %ptr_5 = getelementptr i64 , i64 *
 %r64ptr, i32 5
  store i64 %v_5, i64 * %ptr_5

  %v0_6 = extractelement <16 x i64> %0, i32 6
  %v1_6 = extractelement <16 x i64> %1, i32 6
  %c_6 = icmp ugt i64 %v0_6, %v1_6
  %v_6 = select i1 %c_6, i64 %v0_6, i64 %v1_6
  %ptr_6 = getelementptr i64 , i64 *
 %r64ptr, i32 6
  store i64 %v_6, i64 * %ptr_6

  %v0_7 = extractelement <16 x i64> %0, i32 7
  %v1_7 = extractelement <16 x i64> %1, i32 7
  %c_7 = icmp ugt i64 %v0_7, %v1_7
  %v_7 = select i1 %c_7, i64 %v0_7, i64 %v1_7
  %ptr_7 = getelementptr i64 , i64 *
 %r64ptr, i32 7
  store i64 %v_7, i64 * %ptr_7

  %v0_8 = extractelement <16 x i64> %0, i32 8
  %v1_8 = extractelement <16 x i64> %1, i32 8
  %c_8 = icmp ugt i64 %v0_8, %v1_8
  %v_8 = select i1 %c_8, i64 %v0_8, i64 %v1_8
  %ptr_8 = getelementptr i64 , i64 *
 %r64ptr, i32 8
  store i64 %v_8, i64 * %ptr_8

  %v0_9 = extractelement <16 x i64> %0, i32 9
  %v1_9 = extractelement <16 x i64> %1, i32 9
  %c_9 = icmp ugt i64 %v0_9, %v1_9
  %v_9 = select i1 %c_9, i64 %v0_9, i64 %v1_9
  %ptr_9 = getelementptr i64 , i64 *
 %r64ptr, i32 9
  store i64 %v_9, i64 * %ptr_9

  %v0_10 = extractelement <16 x i64> %0, i32 10
  %v1_10 = extractelement <16 x i64> %1, i32 10
  %c_10 = icmp ugt i64 %v0_10, %v1_10
  %v_10 = select i1 %c_10, i64 %v0_10, i64 %v1_10
  %ptr_10 = getelementptr i64 , i64 *
 %r64ptr, i32 10
  store i64 %v_10, i64 * %ptr_10

  %v0_11 = extractelement <16 x i64> %0, i32 11
  %v1_11 = extractelement <16 x i64> %1, i32 11
  %c_11 = icmp ugt i64 %v0_11, %v1_11
  %v_11 = select i1 %c_11, i64 %v0_11, i64 %v1_11
  %ptr_11 = getelementptr i64 , i64 *
 %r64ptr, i32 11
  store i64 %v_11, i64 * %ptr_11

  %v0_12 = extractelement <16 x i64> %0, i32 12
  %v1_12 = extractelement <16 x i64> %1, i32 12
  %c_12 = icmp ugt i64 %v0_12, %v1_12
  %v_12 = select i1 %c_12, i64 %v0_12, i64 %v1_12
  %ptr_12 = getelementptr i64 , i64 *
 %r64ptr, i32 12
  store i64 %v_12, i64 * %ptr_12

  %v0_13 = extractelement <16 x i64> %0, i32 13
  %v1_13 = extractelement <16 x i64> %1, i32 13
  %c_13 = icmp ugt i64 %v0_13, %v1_13
  %v_13 = select i1 %c_13, i64 %v0_13, i64 %v1_13
  %ptr_13 = getelementptr i64 , i64 *
 %r64ptr, i32 13
  store i64 %v_13, i64 * %ptr_13

  %v0_14 = extractelement <16 x i64> %0, i32 14
  %v1_14 = extractelement <16 x i64> %1, i32 14
  %c_14 = icmp ugt i64 %v0_14, %v1_14
  %v_14 = select i1 %c_14, i64 %v0_14, i64 %v1_14
  %ptr_14 = getelementptr i64 , i64 *
 %r64ptr, i32 14
  store i64 %v_14, i64 * %ptr_14

  %v0_15 = extractelement <16 x i64> %0, i32 15
  %v1_15 = extractelement <16 x i64> %1, i32 15
  %c_15 = icmp ugt i64 %v0_15, %v1_15
  %v_15 = select i1 %c_15, i64 %v0_15, i64 %v1_15
  %ptr_15 = getelementptr i64 , i64 *
 %r64ptr, i32 15
  store i64 %v_15, i64 * %ptr_15
                  

  %ret = load <16 x i64>  , <16 x i64>  *
  %rptr
  ret <16 x i64> %ret
}



declare <16 x i8> @llvm.x86.sse2.padds.b(<16 x i8>, <16 x i8>) nounwind readnone
define <16 x i8> @__padds_vi8(<16 x i8> %a0, <16 x i8> %a1) {
  %res = call <16 x i8> @llvm.x86.sse2.padds.b(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.x86.sse2.padds.w(<8 x i16>, <8 x i16>) nounwind readnone
define <16 x i16> @__padds_vi16(<16 x i16> %a0, <16 x i16> %a1) {
  
%ret_0a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret_0b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%vret_0 = call <8 x i16> @llvm.x86.sse2.padds.w(<8 x i16> %ret_0a, <8 x i16> %ret_0b)
%ret_1a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%ret_1b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%vret_1 = call <8 x i16> @llvm.x86.sse2.padds.w(<8 x i16> %ret_1a, <8 x i16> %ret_1b)
%ret = shufflevector <8 x i16> %vret_0, <8 x i16> %vret_1, 
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x i16> %ret
}

declare <16 x i8> @llvm.x86.sse2.paddus.b(<16 x i8>, <16 x i8>) nounwind readnone
define <16 x i8> @__paddus_vi8(<16 x i8> %a0, <16 x i8> %a1) {
  %res = call <16 x i8> @llvm.x86.sse2.paddus.b(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.x86.sse2.paddus.w(<8 x i16>, <8 x i16>) nounwind readnone
define <16 x i16> @__paddus_vi16(<16 x i16> %a0, <16 x i16> %a1) {
  
%ret_0a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret_0b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%vret_0 = call <8 x i16> @llvm.x86.sse2.paddus.w(<8 x i16> %ret_0a, <8 x i16> %ret_0b)
%ret_1a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%ret_1b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%vret_1 = call <8 x i16> @llvm.x86.sse2.paddus.w(<8 x i16> %ret_1a, <8 x i16> %ret_1b)
%ret = shufflevector <8 x i16> %vret_0, <8 x i16> %vret_1, 
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  
  ret <16 x i16> %ret
}

declare <16 x i8> @llvm.x86.sse2.psubs.b(<16 x i8>, <16 x i8>) nounwind readnone
define <16 x i8> @__psubs_vi8(<16 x i8> %a0, <16 x i8> %a1) {
  %res = call <16 x i8> @llvm.x86.sse2.psubs.b(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.x86.sse2.psubs.w(<8 x i16>, <8 x i16>) nounwind readnone
define <16 x i16> @__psubs_vi16(<16 x i16> %a0, <16 x i16> %a1) {
  
%ret_0a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret_0b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%vret_0 = call <8 x i16> @llvm.x86.sse2.psubs.w(<8 x i16> %ret_0a, <8 x i16> %ret_0b)
%ret_1a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%ret_1b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%vret_1 = call <8 x i16> @llvm.x86.sse2.psubs.w(<8 x i16> %ret_1a, <8 x i16> %ret_1b)
%ret = shufflevector <8 x i16> %vret_0, <8 x i16> %vret_1, 
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x i16> %ret
}

declare <16 x i8> @llvm.x86.sse2.psubus.b(<16 x i8>, <16 x i8>) nounwind readnone
define <16 x i8> @__psubus_vi8(<16 x i8> %a0, <16 x i8> %a1) {
  %res = call <16 x i8> @llvm.x86.sse2.psubus.b(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.x86.sse2.psubus.w(<8 x i16>, <8 x i16>) nounwind readnone
define <16 x i16> @__psubus_vi16(<16 x i16> %a0, <16 x i16> %a1) {
  
%ret_0a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret_0b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%vret_0 = call <8 x i16> @llvm.x86.sse2.psubus.w(<8 x i16> %ret_0a, <8 x i16> %ret_0b)
%ret_1a = shufflevector <16 x i16> %a0, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%ret_1b = shufflevector <16 x i16> %a1, <16 x i16> undef,
          <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%vret_1 = call <8 x i16> @llvm.x86.sse2.psubus.w(<8 x i16> %ret_1a, <8 x i16> %ret_1b)
%ret = shufflevector <8 x i16> %vret_0, <8 x i16> %vret_1, 
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  
  ret <16 x i16> %ret
}
 


;;  Copyright (c) 2010-2020, Intel Corporation
;;  All rights reserved.
;;
;;  Redistribution and use in source and binary forms, with or without
;;  modification, are permitted provided that the following conditions are
;;  met:
;;
;;    * Redistributions of source code must retain the above copyright
;;      notice, this list of conditions and the following disclaimer.
;;
;;    * Redistributions in binary form must reproduce the above copyright
;;      notice, this list of conditions and the following disclaimer in the
;;      documentation and/or other materials provided with the distribution.
;;
;;    * Neither the name of Intel Corporation nor the names of its
;;      contributors may be used to endorse or promote products derived from
;;      this software without specific prior written permission.
;;
;;
;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
;;   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
;;   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
;;   OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;;   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SSE4 target implementation.




declare i32 @llvm.ctlz.i32(i32)
declare i64 @llvm.ctlz.i64(i64)
declare i32 @llvm.cttz.i32(i32)
declare i64 @llvm.cttz.i64(i64)






define i32 @__count_trailing_zeros_i32(i32) nounwind readnone alwaysinline {
  %c = call i32 @llvm.cttz.i32(i32 %0)
  ret i32 %c
}

define i64 @__count_trailing_zeros_i64(i64) nounwind readnone alwaysinline {
  %c = call i64 @llvm.cttz.i64(i64 %0)
  ret i64 %c
}

define i32 @__count_leading_zeros_i32(i32) nounwind readnone alwaysinline {
  %c = call i32 @llvm.ctlz.i32(i32 %0)
  ret i32 %c
}

define i64 @__count_leading_zeros_i64(i64) nounwind readnone alwaysinline {
  %c = call i64 @llvm.ctlz.i64(i64 %0)
  ret i64 %c
}



declare i32 @llvm.ctpop.i32(i32) nounwind readnone
declare i64 @llvm.ctpop.i64(i64) nounwind readnone

define i32 @__popcnt_int32(i32) nounwind readonly alwaysinline {
  %call = call i32 @llvm.ctpop.i32(i32 %0)
  ret i32 %call
}

define i64 @__popcnt_int64(i64) nounwind readonly alwaysinline {
  %call = call i64 @llvm.ctpop.i64(i64 %0)
  ret i64 %call
}


declare void @llvm.prefetch(i8* nocapture %ptr, i32 %readwrite, i32 %locality,
                            i32 %cachetype) ; cachetype == 1 is dcache

define void @__prefetch_read_uniform_1(i8 *) alwaysinline {
  call void @llvm.prefetch(i8 * %0, i32 0, i32 3, i32 1)
  ret void
}

define void @__prefetch_read_uniform_2(i8 *) alwaysinline {
  call void @llvm.prefetch(i8 * %0, i32 0, i32 2, i32 1)
  ret void
}

define void @__prefetch_read_uniform_3(i8 *) alwaysinline {
  call void @llvm.prefetch(i8 * %0, i32 0, i32 1, i32 1)
  ret void
}

define void @__prefetch_read_uniform_nt(i8 *) alwaysinline {
  call void @llvm.prefetch(i8 * %0, i32 0, i32 0, i32 1)
  ret void
}

define void @__prefetch_read_varying_1(<16 x i64> %addr, <16 x i8> %mask) alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %addr, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_0_ID, i32 0, i32 3, i32 1)
  
  %iptr_1_ID = extractelement <16 x i64> %addr, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_1_ID, i32 0, i32 3, i32 1)
  
  %iptr_2_ID = extractelement <16 x i64> %addr, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_2_ID, i32 0, i32 3, i32 1)
  
  %iptr_3_ID = extractelement <16 x i64> %addr, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_3_ID, i32 0, i32 3, i32 1)
  
  %iptr_4_ID = extractelement <16 x i64> %addr, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_4_ID, i32 0, i32 3, i32 1)
  
  %iptr_5_ID = extractelement <16 x i64> %addr, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_5_ID, i32 0, i32 3, i32 1)
  
  %iptr_6_ID = extractelement <16 x i64> %addr, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_6_ID, i32 0, i32 3, i32 1)
  
  %iptr_7_ID = extractelement <16 x i64> %addr, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_7_ID, i32 0, i32 3, i32 1)
  
  %iptr_8_ID = extractelement <16 x i64> %addr, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_8_ID, i32 0, i32 3, i32 1)
  
  %iptr_9_ID = extractelement <16 x i64> %addr, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_9_ID, i32 0, i32 3, i32 1)
  
  %iptr_10_ID = extractelement <16 x i64> %addr, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_10_ID, i32 0, i32 3, i32 1)
  
  %iptr_11_ID = extractelement <16 x i64> %addr, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_11_ID, i32 0, i32 3, i32 1)
  
  %iptr_12_ID = extractelement <16 x i64> %addr, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_12_ID, i32 0, i32 3, i32 1)
  
  %iptr_13_ID = extractelement <16 x i64> %addr, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_13_ID, i32 0, i32 3, i32 1)
  
  %iptr_14_ID = extractelement <16 x i64> %addr, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_14_ID, i32 0, i32 3, i32 1)
  
  %iptr_15_ID = extractelement <16 x i64> %addr, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_15_ID, i32 0, i32 3, i32 1)
  
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %addr, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i8*
  call void @llvm.prefetch(i8 * %ptr__id, i32 0, i32 3, i32 1)
  
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

declare void @__prefetch_read_varying_1_native(i8 * %base, i32 %scale, <16 x i32> %offsets, <16 x i8> %mask) nounwind

define void @__prefetch_read_varying_2(<16 x i64> %addr, <16 x i8> %mask) alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %addr, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_0_ID, i32 0, i32 2, i32 1)
  
  %iptr_1_ID = extractelement <16 x i64> %addr, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_1_ID, i32 0, i32 2, i32 1)
  
  %iptr_2_ID = extractelement <16 x i64> %addr, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_2_ID, i32 0, i32 2, i32 1)
  
  %iptr_3_ID = extractelement <16 x i64> %addr, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_3_ID, i32 0, i32 2, i32 1)
  
  %iptr_4_ID = extractelement <16 x i64> %addr, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_4_ID, i32 0, i32 2, i32 1)
  
  %iptr_5_ID = extractelement <16 x i64> %addr, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_5_ID, i32 0, i32 2, i32 1)
  
  %iptr_6_ID = extractelement <16 x i64> %addr, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_6_ID, i32 0, i32 2, i32 1)
  
  %iptr_7_ID = extractelement <16 x i64> %addr, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_7_ID, i32 0, i32 2, i32 1)
  
  %iptr_8_ID = extractelement <16 x i64> %addr, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_8_ID, i32 0, i32 2, i32 1)
  
  %iptr_9_ID = extractelement <16 x i64> %addr, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_9_ID, i32 0, i32 2, i32 1)
  
  %iptr_10_ID = extractelement <16 x i64> %addr, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_10_ID, i32 0, i32 2, i32 1)
  
  %iptr_11_ID = extractelement <16 x i64> %addr, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_11_ID, i32 0, i32 2, i32 1)
  
  %iptr_12_ID = extractelement <16 x i64> %addr, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_12_ID, i32 0, i32 2, i32 1)
  
  %iptr_13_ID = extractelement <16 x i64> %addr, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_13_ID, i32 0, i32 2, i32 1)
  
  %iptr_14_ID = extractelement <16 x i64> %addr, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_14_ID, i32 0, i32 2, i32 1)
  
  %iptr_15_ID = extractelement <16 x i64> %addr, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_15_ID, i32 0, i32 2, i32 1)
  
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %addr, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i8*
  call void @llvm.prefetch(i8 * %ptr__id, i32 0, i32 2, i32 1)
  
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

declare void @__prefetch_read_varying_2_native(i8 * %base, i32 %scale, <16 x i32> %offsets, <16 x i8> %mask) nounwind

define void @__prefetch_read_varying_3(<16 x i64> %addr, <16 x i8> %mask) alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %addr, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_0_ID, i32 0, i32 1, i32 1)
  
  %iptr_1_ID = extractelement <16 x i64> %addr, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_1_ID, i32 0, i32 1, i32 1)
  
  %iptr_2_ID = extractelement <16 x i64> %addr, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_2_ID, i32 0, i32 1, i32 1)
  
  %iptr_3_ID = extractelement <16 x i64> %addr, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_3_ID, i32 0, i32 1, i32 1)
  
  %iptr_4_ID = extractelement <16 x i64> %addr, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_4_ID, i32 0, i32 1, i32 1)
  
  %iptr_5_ID = extractelement <16 x i64> %addr, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_5_ID, i32 0, i32 1, i32 1)
  
  %iptr_6_ID = extractelement <16 x i64> %addr, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_6_ID, i32 0, i32 1, i32 1)
  
  %iptr_7_ID = extractelement <16 x i64> %addr, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_7_ID, i32 0, i32 1, i32 1)
  
  %iptr_8_ID = extractelement <16 x i64> %addr, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_8_ID, i32 0, i32 1, i32 1)
  
  %iptr_9_ID = extractelement <16 x i64> %addr, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_9_ID, i32 0, i32 1, i32 1)
  
  %iptr_10_ID = extractelement <16 x i64> %addr, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_10_ID, i32 0, i32 1, i32 1)
  
  %iptr_11_ID = extractelement <16 x i64> %addr, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_11_ID, i32 0, i32 1, i32 1)
  
  %iptr_12_ID = extractelement <16 x i64> %addr, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_12_ID, i32 0, i32 1, i32 1)
  
  %iptr_13_ID = extractelement <16 x i64> %addr, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_13_ID, i32 0, i32 1, i32 1)
  
  %iptr_14_ID = extractelement <16 x i64> %addr, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_14_ID, i32 0, i32 1, i32 1)
  
  %iptr_15_ID = extractelement <16 x i64> %addr, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_15_ID, i32 0, i32 1, i32 1)
  
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %addr, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i8*
  call void @llvm.prefetch(i8 * %ptr__id, i32 0, i32 1, i32 1)
  
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

declare void @__prefetch_read_varying_3_native(i8 * %base, i32 %scale, <16 x i32> %offsets, <16 x i8> %mask) nounwind

define void @__prefetch_read_varying_nt(<16 x i64> %addr, <16 x i8> %mask) alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %addr, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_0_ID, i32 0, i32 0, i32 1)
  
  %iptr_1_ID = extractelement <16 x i64> %addr, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_1_ID, i32 0, i32 0, i32 1)
  
  %iptr_2_ID = extractelement <16 x i64> %addr, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_2_ID, i32 0, i32 0, i32 1)
  
  %iptr_3_ID = extractelement <16 x i64> %addr, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_3_ID, i32 0, i32 0, i32 1)
  
  %iptr_4_ID = extractelement <16 x i64> %addr, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_4_ID, i32 0, i32 0, i32 1)
  
  %iptr_5_ID = extractelement <16 x i64> %addr, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_5_ID, i32 0, i32 0, i32 1)
  
  %iptr_6_ID = extractelement <16 x i64> %addr, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_6_ID, i32 0, i32 0, i32 1)
  
  %iptr_7_ID = extractelement <16 x i64> %addr, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_7_ID, i32 0, i32 0, i32 1)
  
  %iptr_8_ID = extractelement <16 x i64> %addr, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_8_ID, i32 0, i32 0, i32 1)
  
  %iptr_9_ID = extractelement <16 x i64> %addr, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_9_ID, i32 0, i32 0, i32 1)
  
  %iptr_10_ID = extractelement <16 x i64> %addr, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_10_ID, i32 0, i32 0, i32 1)
  
  %iptr_11_ID = extractelement <16 x i64> %addr, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_11_ID, i32 0, i32 0, i32 1)
  
  %iptr_12_ID = extractelement <16 x i64> %addr, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_12_ID, i32 0, i32 0, i32 1)
  
  %iptr_13_ID = extractelement <16 x i64> %addr, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_13_ID, i32 0, i32 0, i32 1)
  
  %iptr_14_ID = extractelement <16 x i64> %addr, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_14_ID, i32 0, i32 0, i32 1)
  
  %iptr_15_ID = extractelement <16 x i64> %addr, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8*
  call void @llvm.prefetch(i8 * %ptr_15_ID, i32 0, i32 0, i32 1)
  
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %addr, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i8*
  call void @llvm.prefetch(i8 * %ptr__id, i32 0, i32 0, i32 1)
  
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

declare void @__prefetch_read_varying_nt_native(i8 * %base, i32 %scale, <16 x i32> %offsets, <16 x i8> %mask) nounwind



define <16 x i8> @__broadcast_i8(<16 x i8>, i32) nounwind readnone alwaysinline {
  %v = extractelement <16 x i8> %0, i32 %1
  %broadcast_init = insertelement <16 x i8> undef, i8 %v, i32 0
  %broadcast = shufflevector <16 x i8> %broadcast_init, <16 x i8> undef, <16 x i32> zeroinitializer 
  ret <16 x i8> %broadcast
}

define <16 x i8> @__rotate_i8(<16 x i8>, i32) nounwind readnone alwaysinline {
  %isc = call i1 @__is_compile_time_constant_uniform_int32(i32 %1)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; though verbose, this turms into tight code if %1 is a constant
  
  %delta_0 = add i32 %1, 0
  %delta_clamped_0 = and i32 %delta_0, 15
  %v_0 = extractelement <16 x i8> %0, i32 %delta_clamped_0  
  %delta_1 = add i32 %1, 1
  %delta_clamped_1 = and i32 %delta_1, 15
  %v_1 = extractelement <16 x i8> %0, i32 %delta_clamped_1  
  %delta_2 = add i32 %1, 2
  %delta_clamped_2 = and i32 %delta_2, 15
  %v_2 = extractelement <16 x i8> %0, i32 %delta_clamped_2  
  %delta_3 = add i32 %1, 3
  %delta_clamped_3 = and i32 %delta_3, 15
  %v_3 = extractelement <16 x i8> %0, i32 %delta_clamped_3  
  %delta_4 = add i32 %1, 4
  %delta_clamped_4 = and i32 %delta_4, 15
  %v_4 = extractelement <16 x i8> %0, i32 %delta_clamped_4  
  %delta_5 = add i32 %1, 5
  %delta_clamped_5 = and i32 %delta_5, 15
  %v_5 = extractelement <16 x i8> %0, i32 %delta_clamped_5  
  %delta_6 = add i32 %1, 6
  %delta_clamped_6 = and i32 %delta_6, 15
  %v_6 = extractelement <16 x i8> %0, i32 %delta_clamped_6  
  %delta_7 = add i32 %1, 7
  %delta_clamped_7 = and i32 %delta_7, 15
  %v_7 = extractelement <16 x i8> %0, i32 %delta_clamped_7  
  %delta_8 = add i32 %1, 8
  %delta_clamped_8 = and i32 %delta_8, 15
  %v_8 = extractelement <16 x i8> %0, i32 %delta_clamped_8  
  %delta_9 = add i32 %1, 9
  %delta_clamped_9 = and i32 %delta_9, 15
  %v_9 = extractelement <16 x i8> %0, i32 %delta_clamped_9  
  %delta_10 = add i32 %1, 10
  %delta_clamped_10 = and i32 %delta_10, 15
  %v_10 = extractelement <16 x i8> %0, i32 %delta_clamped_10  
  %delta_11 = add i32 %1, 11
  %delta_clamped_11 = and i32 %delta_11, 15
  %v_11 = extractelement <16 x i8> %0, i32 %delta_clamped_11  
  %delta_12 = add i32 %1, 12
  %delta_clamped_12 = and i32 %delta_12, 15
  %v_12 = extractelement <16 x i8> %0, i32 %delta_clamped_12  
  %delta_13 = add i32 %1, 13
  %delta_clamped_13 = and i32 %delta_13, 15
  %v_13 = extractelement <16 x i8> %0, i32 %delta_clamped_13  
  %delta_14 = add i32 %1, 14
  %delta_clamped_14 = and i32 %delta_14, 15
  %v_14 = extractelement <16 x i8> %0, i32 %delta_clamped_14  
  %delta_15 = add i32 %1, 15
  %delta_clamped_15 = and i32 %delta_15, 15
  %v_15 = extractelement <16 x i8> %0, i32 %delta_clamped_15

  %ret_0 = insertelement <16 x i8> undef, i8 %v_0, i32 0
  %ret_1 = insertelement <16 x i8> %ret_0, i8 %v_1, i32 1
  %ret_2 = insertelement <16 x i8> %ret_1, i8 %v_2, i32 2
  %ret_3 = insertelement <16 x i8> %ret_2, i8 %v_3, i32 3
  %ret_4 = insertelement <16 x i8> %ret_3, i8 %v_4, i32 4
  %ret_5 = insertelement <16 x i8> %ret_4, i8 %v_5, i32 5
  %ret_6 = insertelement <16 x i8> %ret_5, i8 %v_6, i32 6
  %ret_7 = insertelement <16 x i8> %ret_6, i8 %v_7, i32 7
  %ret_8 = insertelement <16 x i8> %ret_7, i8 %v_8, i32 8
  %ret_9 = insertelement <16 x i8> %ret_8, i8 %v_9, i32 9
  %ret_10 = insertelement <16 x i8> %ret_9, i8 %v_10, i32 10
  %ret_11 = insertelement <16 x i8> %ret_10, i8 %v_11, i32 11
  %ret_12 = insertelement <16 x i8> %ret_11, i8 %v_12, i32 12
  %ret_13 = insertelement <16 x i8> %ret_12, i8 %v_13, i32 13
  %ret_14 = insertelement <16 x i8> %ret_13, i8 %v_14, i32 14
  %ret_15 = insertelement <16 x i8> %ret_14, i8 %v_15, i32 15

  ret <16 x i8> %ret_15

not_const:
  ; store two instances of the vector into memory
  %ptr = alloca <16 x i8>, i32 2
  %ptr0 = getelementptr <16 x i8> , <16 x i8> *
 %ptr, i32 0
  store <16 x i8> %0, <16 x i8> * %ptr0
  %ptr1 = getelementptr <16 x i8> , <16 x i8> *
 %ptr, i32 1
  store <16 x i8> %0, <16 x i8> * %ptr1

  ; compute offset in [0,vectorwidth-1], then index into the doubled-up vector
  %offset = and i32 %1, 15
  %ptr_as_elt_array = bitcast <16 x i8> * %ptr to [32 x i8] *
  %load_ptr = getelementptr [32 x i8] , [32 x i8] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i8 * %load_ptr to <16 x i8> *
  %result = load <16 x i8>  , <16 x i8>  *
  %load_ptr_vec, align 1
  ret <16 x i8> %result
}

define <16 x i8> @__shift_i8(<16 x i8>, i32) nounwind readnone alwaysinline {
  %ptr = alloca <16 x i8>, i32 3
  %ptr0 = getelementptr <16 x i8> , <16 x i8> *
 %ptr, i32 0
  store <16 x i8> zeroinitializer, <16 x i8> * %ptr0
  %ptr1 = getelementptr <16 x i8> , <16 x i8> *
 %ptr, i32 1
  store <16 x i8> %0, <16 x i8> * %ptr1
  %ptr2 = getelementptr <16 x i8> , <16 x i8> *
 %ptr, i32 2
  store <16 x i8> zeroinitializer, <16 x i8> * %ptr2

  %offset = add i32 %1, 16
  %ptr_as_elt_array = bitcast <16 x i8> * %ptr to [48 x i8] *
  %load_ptr = getelementptr [48 x i8] , [48 x i8] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i8 * %load_ptr to <16 x i8> *
  %result = load <16 x i8>  , <16 x i8>  *
  %load_ptr_vec, align 1
  ret <16 x i8> %result
}


define <16 x i8> @__shuffle_i8(<16 x i8>, <16 x i32>) nounwind readnone alwaysinline {
  
  %index_0 = extractelement <16 x i32> %1, i32 0  
  %index_1 = extractelement <16 x i32> %1, i32 1  
  %index_2 = extractelement <16 x i32> %1, i32 2  
  %index_3 = extractelement <16 x i32> %1, i32 3  
  %index_4 = extractelement <16 x i32> %1, i32 4  
  %index_5 = extractelement <16 x i32> %1, i32 5  
  %index_6 = extractelement <16 x i32> %1, i32 6  
  %index_7 = extractelement <16 x i32> %1, i32 7  
  %index_8 = extractelement <16 x i32> %1, i32 8  
  %index_9 = extractelement <16 x i32> %1, i32 9  
  %index_10 = extractelement <16 x i32> %1, i32 10  
  %index_11 = extractelement <16 x i32> %1, i32 11  
  %index_12 = extractelement <16 x i32> %1, i32 12  
  %index_13 = extractelement <16 x i32> %1, i32 13  
  %index_14 = extractelement <16 x i32> %1, i32 14  
  %index_15 = extractelement <16 x i32> %1, i32 15
  
  %v_0 = extractelement <16 x i8> %0, i32 %index_0  
  %v_1 = extractelement <16 x i8> %0, i32 %index_1  
  %v_2 = extractelement <16 x i8> %0, i32 %index_2  
  %v_3 = extractelement <16 x i8> %0, i32 %index_3  
  %v_4 = extractelement <16 x i8> %0, i32 %index_4  
  %v_5 = extractelement <16 x i8> %0, i32 %index_5  
  %v_6 = extractelement <16 x i8> %0, i32 %index_6  
  %v_7 = extractelement <16 x i8> %0, i32 %index_7  
  %v_8 = extractelement <16 x i8> %0, i32 %index_8  
  %v_9 = extractelement <16 x i8> %0, i32 %index_9  
  %v_10 = extractelement <16 x i8> %0, i32 %index_10  
  %v_11 = extractelement <16 x i8> %0, i32 %index_11  
  %v_12 = extractelement <16 x i8> %0, i32 %index_12  
  %v_13 = extractelement <16 x i8> %0, i32 %index_13  
  %v_14 = extractelement <16 x i8> %0, i32 %index_14  
  %v_15 = extractelement <16 x i8> %0, i32 %index_15

  %ret_0 = insertelement <16 x i8> undef, i8 %v_0, i32 0
  %ret_1 = insertelement <16 x i8> %ret_0, i8 %v_1, i32 1
  %ret_2 = insertelement <16 x i8> %ret_1, i8 %v_2, i32 2
  %ret_3 = insertelement <16 x i8> %ret_2, i8 %v_3, i32 3
  %ret_4 = insertelement <16 x i8> %ret_3, i8 %v_4, i32 4
  %ret_5 = insertelement <16 x i8> %ret_4, i8 %v_5, i32 5
  %ret_6 = insertelement <16 x i8> %ret_5, i8 %v_6, i32 6
  %ret_7 = insertelement <16 x i8> %ret_6, i8 %v_7, i32 7
  %ret_8 = insertelement <16 x i8> %ret_7, i8 %v_8, i32 8
  %ret_9 = insertelement <16 x i8> %ret_8, i8 %v_9, i32 9
  %ret_10 = insertelement <16 x i8> %ret_9, i8 %v_10, i32 10
  %ret_11 = insertelement <16 x i8> %ret_10, i8 %v_11, i32 11
  %ret_12 = insertelement <16 x i8> %ret_11, i8 %v_12, i32 12
  %ret_13 = insertelement <16 x i8> %ret_12, i8 %v_13, i32 13
  %ret_14 = insertelement <16 x i8> %ret_13, i8 %v_14, i32 14
  %ret_15 = insertelement <16 x i8> %ret_14, i8 %v_15, i32 15

  ret <16 x i8> %ret_15
}

define <16 x i8> @__shuffle2_i8(<16 x i8>, <16 x i8>, <16 x i32>) nounwind readnone alwaysinline {
  %v2 = shufflevector <16 x i8> %0, <16 x i8> %1, <32 x i32> <
      i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30,  i32 31
  >
  
  %index_0 = extractelement <16 x i32> %2, i32 0  
  %index_1 = extractelement <16 x i32> %2, i32 1  
  %index_2 = extractelement <16 x i32> %2, i32 2  
  %index_3 = extractelement <16 x i32> %2, i32 3  
  %index_4 = extractelement <16 x i32> %2, i32 4  
  %index_5 = extractelement <16 x i32> %2, i32 5  
  %index_6 = extractelement <16 x i32> %2, i32 6  
  %index_7 = extractelement <16 x i32> %2, i32 7  
  %index_8 = extractelement <16 x i32> %2, i32 8  
  %index_9 = extractelement <16 x i32> %2, i32 9  
  %index_10 = extractelement <16 x i32> %2, i32 10  
  %index_11 = extractelement <16 x i32> %2, i32 11  
  %index_12 = extractelement <16 x i32> %2, i32 12  
  %index_13 = extractelement <16 x i32> %2, i32 13  
  %index_14 = extractelement <16 x i32> %2, i32 14  
  %index_15 = extractelement <16 x i32> %2, i32 15

  %isc = call i1 @__is_compile_time_constant_varying_int32(<16 x i32> %2)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; extract from the requested lanes and insert into the result; LLVM turns
  ; this into good code in the end
  
  %v_0 = extractelement <32 x i8> %v2, i32 %index_0  
  %v_1 = extractelement <32 x i8> %v2, i32 %index_1  
  %v_2 = extractelement <32 x i8> %v2, i32 %index_2  
  %v_3 = extractelement <32 x i8> %v2, i32 %index_3  
  %v_4 = extractelement <32 x i8> %v2, i32 %index_4  
  %v_5 = extractelement <32 x i8> %v2, i32 %index_5  
  %v_6 = extractelement <32 x i8> %v2, i32 %index_6  
  %v_7 = extractelement <32 x i8> %v2, i32 %index_7  
  %v_8 = extractelement <32 x i8> %v2, i32 %index_8  
  %v_9 = extractelement <32 x i8> %v2, i32 %index_9  
  %v_10 = extractelement <32 x i8> %v2, i32 %index_10  
  %v_11 = extractelement <32 x i8> %v2, i32 %index_11  
  %v_12 = extractelement <32 x i8> %v2, i32 %index_12  
  %v_13 = extractelement <32 x i8> %v2, i32 %index_13  
  %v_14 = extractelement <32 x i8> %v2, i32 %index_14  
  %v_15 = extractelement <32 x i8> %v2, i32 %index_15

  %ret_0 = insertelement <16 x i8> undef, i8 %v_0, i32 0
  %ret_1 = insertelement <16 x i8> %ret_0, i8 %v_1, i32 1
  %ret_2 = insertelement <16 x i8> %ret_1, i8 %v_2, i32 2
  %ret_3 = insertelement <16 x i8> %ret_2, i8 %v_3, i32 3
  %ret_4 = insertelement <16 x i8> %ret_3, i8 %v_4, i32 4
  %ret_5 = insertelement <16 x i8> %ret_4, i8 %v_5, i32 5
  %ret_6 = insertelement <16 x i8> %ret_5, i8 %v_6, i32 6
  %ret_7 = insertelement <16 x i8> %ret_6, i8 %v_7, i32 7
  %ret_8 = insertelement <16 x i8> %ret_7, i8 %v_8, i32 8
  %ret_9 = insertelement <16 x i8> %ret_8, i8 %v_9, i32 9
  %ret_10 = insertelement <16 x i8> %ret_9, i8 %v_10, i32 10
  %ret_11 = insertelement <16 x i8> %ret_10, i8 %v_11, i32 11
  %ret_12 = insertelement <16 x i8> %ret_11, i8 %v_12, i32 12
  %ret_13 = insertelement <16 x i8> %ret_12, i8 %v_13, i32 13
  %ret_14 = insertelement <16 x i8> %ret_13, i8 %v_14, i32 14
  %ret_15 = insertelement <16 x i8> %ret_14, i8 %v_15, i32 15

  ret <16 x i8> %ret_15

not_const:
  ; otherwise store the two vectors onto the stack and then use the given
  ; permutation vector to get indices into that array...
  %ptr = alloca <32 x i8>
  store <32 x i8> %v2, <32 x i8> * %ptr
  %baseptr = bitcast <32 x i8> * %ptr to i8 *

  %ptr_0 = getelementptr i8 , i8 *
 %baseptr, i32 %index_0
  %val_0 = load i8  , i8  *
  %ptr_0
  %result_0 = insertelement <16 x i8> undef, i8 %val_0, i32 0

  
  %ptr_1 = getelementptr i8 , i8 *
 %baseptr, i32 %index_1
  %val_1 = load i8  , i8  *
  %ptr_1
  %result_1 = insertelement <16 x i8> %result_0, i8 %val_1, i32 1
  
  %ptr_2 = getelementptr i8 , i8 *
 %baseptr, i32 %index_2
  %val_2 = load i8  , i8  *
  %ptr_2
  %result_2 = insertelement <16 x i8> %result_1, i8 %val_2, i32 2
  
  %ptr_3 = getelementptr i8 , i8 *
 %baseptr, i32 %index_3
  %val_3 = load i8  , i8  *
  %ptr_3
  %result_3 = insertelement <16 x i8> %result_2, i8 %val_3, i32 3
  
  %ptr_4 = getelementptr i8 , i8 *
 %baseptr, i32 %index_4
  %val_4 = load i8  , i8  *
  %ptr_4
  %result_4 = insertelement <16 x i8> %result_3, i8 %val_4, i32 4
  
  %ptr_5 = getelementptr i8 , i8 *
 %baseptr, i32 %index_5
  %val_5 = load i8  , i8  *
  %ptr_5
  %result_5 = insertelement <16 x i8> %result_4, i8 %val_5, i32 5
  
  %ptr_6 = getelementptr i8 , i8 *
 %baseptr, i32 %index_6
  %val_6 = load i8  , i8  *
  %ptr_6
  %result_6 = insertelement <16 x i8> %result_5, i8 %val_6, i32 6
  
  %ptr_7 = getelementptr i8 , i8 *
 %baseptr, i32 %index_7
  %val_7 = load i8  , i8  *
  %ptr_7
  %result_7 = insertelement <16 x i8> %result_6, i8 %val_7, i32 7
  
  %ptr_8 = getelementptr i8 , i8 *
 %baseptr, i32 %index_8
  %val_8 = load i8  , i8  *
  %ptr_8
  %result_8 = insertelement <16 x i8> %result_7, i8 %val_8, i32 8
  
  %ptr_9 = getelementptr i8 , i8 *
 %baseptr, i32 %index_9
  %val_9 = load i8  , i8  *
  %ptr_9
  %result_9 = insertelement <16 x i8> %result_8, i8 %val_9, i32 9
  
  %ptr_10 = getelementptr i8 , i8 *
 %baseptr, i32 %index_10
  %val_10 = load i8  , i8  *
  %ptr_10
  %result_10 = insertelement <16 x i8> %result_9, i8 %val_10, i32 10
  
  %ptr_11 = getelementptr i8 , i8 *
 %baseptr, i32 %index_11
  %val_11 = load i8  , i8  *
  %ptr_11
  %result_11 = insertelement <16 x i8> %result_10, i8 %val_11, i32 11
  
  %ptr_12 = getelementptr i8 , i8 *
 %baseptr, i32 %index_12
  %val_12 = load i8  , i8  *
  %ptr_12
  %result_12 = insertelement <16 x i8> %result_11, i8 %val_12, i32 12
  
  %ptr_13 = getelementptr i8 , i8 *
 %baseptr, i32 %index_13
  %val_13 = load i8  , i8  *
  %ptr_13
  %result_13 = insertelement <16 x i8> %result_12, i8 %val_13, i32 13
  
  %ptr_14 = getelementptr i8 , i8 *
 %baseptr, i32 %index_14
  %val_14 = load i8  , i8  *
  %ptr_14
  %result_14 = insertelement <16 x i8> %result_13, i8 %val_14, i32 14
  
  %ptr_15 = getelementptr i8 , i8 *
 %baseptr, i32 %index_15
  %val_15 = load i8  , i8  *
  %ptr_15
  %result_15 = insertelement <16 x i8> %result_14, i8 %val_15, i32 15


  ret <16 x i8> %result_15
}


define <16 x i16> @__broadcast_i16(<16 x i16>, i32) nounwind readnone alwaysinline {
  %v = extractelement <16 x i16> %0, i32 %1
  %broadcast_init = insertelement <16 x i16> undef, i16 %v, i32 0
  %broadcast = shufflevector <16 x i16> %broadcast_init, <16 x i16> undef, <16 x i32> zeroinitializer 
  ret <16 x i16> %broadcast
}

define <16 x i16> @__rotate_i16(<16 x i16>, i32) nounwind readnone alwaysinline {
  %isc = call i1 @__is_compile_time_constant_uniform_int32(i32 %1)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; though verbose, this turms into tight code if %1 is a constant
  
  %delta_0 = add i32 %1, 0
  %delta_clamped_0 = and i32 %delta_0, 15
  %v_0 = extractelement <16 x i16> %0, i32 %delta_clamped_0  
  %delta_1 = add i32 %1, 1
  %delta_clamped_1 = and i32 %delta_1, 15
  %v_1 = extractelement <16 x i16> %0, i32 %delta_clamped_1  
  %delta_2 = add i32 %1, 2
  %delta_clamped_2 = and i32 %delta_2, 15
  %v_2 = extractelement <16 x i16> %0, i32 %delta_clamped_2  
  %delta_3 = add i32 %1, 3
  %delta_clamped_3 = and i32 %delta_3, 15
  %v_3 = extractelement <16 x i16> %0, i32 %delta_clamped_3  
  %delta_4 = add i32 %1, 4
  %delta_clamped_4 = and i32 %delta_4, 15
  %v_4 = extractelement <16 x i16> %0, i32 %delta_clamped_4  
  %delta_5 = add i32 %1, 5
  %delta_clamped_5 = and i32 %delta_5, 15
  %v_5 = extractelement <16 x i16> %0, i32 %delta_clamped_5  
  %delta_6 = add i32 %1, 6
  %delta_clamped_6 = and i32 %delta_6, 15
  %v_6 = extractelement <16 x i16> %0, i32 %delta_clamped_6  
  %delta_7 = add i32 %1, 7
  %delta_clamped_7 = and i32 %delta_7, 15
  %v_7 = extractelement <16 x i16> %0, i32 %delta_clamped_7  
  %delta_8 = add i32 %1, 8
  %delta_clamped_8 = and i32 %delta_8, 15
  %v_8 = extractelement <16 x i16> %0, i32 %delta_clamped_8  
  %delta_9 = add i32 %1, 9
  %delta_clamped_9 = and i32 %delta_9, 15
  %v_9 = extractelement <16 x i16> %0, i32 %delta_clamped_9  
  %delta_10 = add i32 %1, 10
  %delta_clamped_10 = and i32 %delta_10, 15
  %v_10 = extractelement <16 x i16> %0, i32 %delta_clamped_10  
  %delta_11 = add i32 %1, 11
  %delta_clamped_11 = and i32 %delta_11, 15
  %v_11 = extractelement <16 x i16> %0, i32 %delta_clamped_11  
  %delta_12 = add i32 %1, 12
  %delta_clamped_12 = and i32 %delta_12, 15
  %v_12 = extractelement <16 x i16> %0, i32 %delta_clamped_12  
  %delta_13 = add i32 %1, 13
  %delta_clamped_13 = and i32 %delta_13, 15
  %v_13 = extractelement <16 x i16> %0, i32 %delta_clamped_13  
  %delta_14 = add i32 %1, 14
  %delta_clamped_14 = and i32 %delta_14, 15
  %v_14 = extractelement <16 x i16> %0, i32 %delta_clamped_14  
  %delta_15 = add i32 %1, 15
  %delta_clamped_15 = and i32 %delta_15, 15
  %v_15 = extractelement <16 x i16> %0, i32 %delta_clamped_15

  %ret_0 = insertelement <16 x i16> undef, i16 %v_0, i32 0
  %ret_1 = insertelement <16 x i16> %ret_0, i16 %v_1, i32 1
  %ret_2 = insertelement <16 x i16> %ret_1, i16 %v_2, i32 2
  %ret_3 = insertelement <16 x i16> %ret_2, i16 %v_3, i32 3
  %ret_4 = insertelement <16 x i16> %ret_3, i16 %v_4, i32 4
  %ret_5 = insertelement <16 x i16> %ret_4, i16 %v_5, i32 5
  %ret_6 = insertelement <16 x i16> %ret_5, i16 %v_6, i32 6
  %ret_7 = insertelement <16 x i16> %ret_6, i16 %v_7, i32 7
  %ret_8 = insertelement <16 x i16> %ret_7, i16 %v_8, i32 8
  %ret_9 = insertelement <16 x i16> %ret_8, i16 %v_9, i32 9
  %ret_10 = insertelement <16 x i16> %ret_9, i16 %v_10, i32 10
  %ret_11 = insertelement <16 x i16> %ret_10, i16 %v_11, i32 11
  %ret_12 = insertelement <16 x i16> %ret_11, i16 %v_12, i32 12
  %ret_13 = insertelement <16 x i16> %ret_12, i16 %v_13, i32 13
  %ret_14 = insertelement <16 x i16> %ret_13, i16 %v_14, i32 14
  %ret_15 = insertelement <16 x i16> %ret_14, i16 %v_15, i32 15

  ret <16 x i16> %ret_15

not_const:
  ; store two instances of the vector into memory
  %ptr = alloca <16 x i16>, i32 2
  %ptr0 = getelementptr <16 x i16> , <16 x i16> *
 %ptr, i32 0
  store <16 x i16> %0, <16 x i16> * %ptr0
  %ptr1 = getelementptr <16 x i16> , <16 x i16> *
 %ptr, i32 1
  store <16 x i16> %0, <16 x i16> * %ptr1

  ; compute offset in [0,vectorwidth-1], then index into the doubled-up vector
  %offset = and i32 %1, 15
  %ptr_as_elt_array = bitcast <16 x i16> * %ptr to [32 x i16] *
  %load_ptr = getelementptr [32 x i16] , [32 x i16] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i16 * %load_ptr to <16 x i16> *
  %result = load <16 x i16>  , <16 x i16>  *
  %load_ptr_vec, align 2
  ret <16 x i16> %result
}

define <16 x i16> @__shift_i16(<16 x i16>, i32) nounwind readnone alwaysinline {
  %ptr = alloca <16 x i16>, i32 3
  %ptr0 = getelementptr <16 x i16> , <16 x i16> *
 %ptr, i32 0
  store <16 x i16> zeroinitializer, <16 x i16> * %ptr0
  %ptr1 = getelementptr <16 x i16> , <16 x i16> *
 %ptr, i32 1
  store <16 x i16> %0, <16 x i16> * %ptr1
  %ptr2 = getelementptr <16 x i16> , <16 x i16> *
 %ptr, i32 2
  store <16 x i16> zeroinitializer, <16 x i16> * %ptr2

  %offset = add i32 %1, 16
  %ptr_as_elt_array = bitcast <16 x i16> * %ptr to [48 x i16] *
  %load_ptr = getelementptr [48 x i16] , [48 x i16] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i16 * %load_ptr to <16 x i16> *
  %result = load <16 x i16>  , <16 x i16>  *
  %load_ptr_vec, align 2
  ret <16 x i16> %result
}


define <16 x i16> @__shuffle_i16(<16 x i16>, <16 x i32>) nounwind readnone alwaysinline {
  
  %index_0 = extractelement <16 x i32> %1, i32 0  
  %index_1 = extractelement <16 x i32> %1, i32 1  
  %index_2 = extractelement <16 x i32> %1, i32 2  
  %index_3 = extractelement <16 x i32> %1, i32 3  
  %index_4 = extractelement <16 x i32> %1, i32 4  
  %index_5 = extractelement <16 x i32> %1, i32 5  
  %index_6 = extractelement <16 x i32> %1, i32 6  
  %index_7 = extractelement <16 x i32> %1, i32 7  
  %index_8 = extractelement <16 x i32> %1, i32 8  
  %index_9 = extractelement <16 x i32> %1, i32 9  
  %index_10 = extractelement <16 x i32> %1, i32 10  
  %index_11 = extractelement <16 x i32> %1, i32 11  
  %index_12 = extractelement <16 x i32> %1, i32 12  
  %index_13 = extractelement <16 x i32> %1, i32 13  
  %index_14 = extractelement <16 x i32> %1, i32 14  
  %index_15 = extractelement <16 x i32> %1, i32 15
  
  %v_0 = extractelement <16 x i16> %0, i32 %index_0  
  %v_1 = extractelement <16 x i16> %0, i32 %index_1  
  %v_2 = extractelement <16 x i16> %0, i32 %index_2  
  %v_3 = extractelement <16 x i16> %0, i32 %index_3  
  %v_4 = extractelement <16 x i16> %0, i32 %index_4  
  %v_5 = extractelement <16 x i16> %0, i32 %index_5  
  %v_6 = extractelement <16 x i16> %0, i32 %index_6  
  %v_7 = extractelement <16 x i16> %0, i32 %index_7  
  %v_8 = extractelement <16 x i16> %0, i32 %index_8  
  %v_9 = extractelement <16 x i16> %0, i32 %index_9  
  %v_10 = extractelement <16 x i16> %0, i32 %index_10  
  %v_11 = extractelement <16 x i16> %0, i32 %index_11  
  %v_12 = extractelement <16 x i16> %0, i32 %index_12  
  %v_13 = extractelement <16 x i16> %0, i32 %index_13  
  %v_14 = extractelement <16 x i16> %0, i32 %index_14  
  %v_15 = extractelement <16 x i16> %0, i32 %index_15

  %ret_0 = insertelement <16 x i16> undef, i16 %v_0, i32 0
  %ret_1 = insertelement <16 x i16> %ret_0, i16 %v_1, i32 1
  %ret_2 = insertelement <16 x i16> %ret_1, i16 %v_2, i32 2
  %ret_3 = insertelement <16 x i16> %ret_2, i16 %v_3, i32 3
  %ret_4 = insertelement <16 x i16> %ret_3, i16 %v_4, i32 4
  %ret_5 = insertelement <16 x i16> %ret_4, i16 %v_5, i32 5
  %ret_6 = insertelement <16 x i16> %ret_5, i16 %v_6, i32 6
  %ret_7 = insertelement <16 x i16> %ret_6, i16 %v_7, i32 7
  %ret_8 = insertelement <16 x i16> %ret_7, i16 %v_8, i32 8
  %ret_9 = insertelement <16 x i16> %ret_8, i16 %v_9, i32 9
  %ret_10 = insertelement <16 x i16> %ret_9, i16 %v_10, i32 10
  %ret_11 = insertelement <16 x i16> %ret_10, i16 %v_11, i32 11
  %ret_12 = insertelement <16 x i16> %ret_11, i16 %v_12, i32 12
  %ret_13 = insertelement <16 x i16> %ret_12, i16 %v_13, i32 13
  %ret_14 = insertelement <16 x i16> %ret_13, i16 %v_14, i32 14
  %ret_15 = insertelement <16 x i16> %ret_14, i16 %v_15, i32 15

  ret <16 x i16> %ret_15
}

define <16 x i16> @__shuffle2_i16(<16 x i16>, <16 x i16>, <16 x i32>) nounwind readnone alwaysinline {
  %v2 = shufflevector <16 x i16> %0, <16 x i16> %1, <32 x i32> <
      i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30,  i32 31
  >
  
  %index_0 = extractelement <16 x i32> %2, i32 0  
  %index_1 = extractelement <16 x i32> %2, i32 1  
  %index_2 = extractelement <16 x i32> %2, i32 2  
  %index_3 = extractelement <16 x i32> %2, i32 3  
  %index_4 = extractelement <16 x i32> %2, i32 4  
  %index_5 = extractelement <16 x i32> %2, i32 5  
  %index_6 = extractelement <16 x i32> %2, i32 6  
  %index_7 = extractelement <16 x i32> %2, i32 7  
  %index_8 = extractelement <16 x i32> %2, i32 8  
  %index_9 = extractelement <16 x i32> %2, i32 9  
  %index_10 = extractelement <16 x i32> %2, i32 10  
  %index_11 = extractelement <16 x i32> %2, i32 11  
  %index_12 = extractelement <16 x i32> %2, i32 12  
  %index_13 = extractelement <16 x i32> %2, i32 13  
  %index_14 = extractelement <16 x i32> %2, i32 14  
  %index_15 = extractelement <16 x i32> %2, i32 15

  %isc = call i1 @__is_compile_time_constant_varying_int32(<16 x i32> %2)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; extract from the requested lanes and insert into the result; LLVM turns
  ; this into good code in the end
  
  %v_0 = extractelement <32 x i16> %v2, i32 %index_0  
  %v_1 = extractelement <32 x i16> %v2, i32 %index_1  
  %v_2 = extractelement <32 x i16> %v2, i32 %index_2  
  %v_3 = extractelement <32 x i16> %v2, i32 %index_3  
  %v_4 = extractelement <32 x i16> %v2, i32 %index_4  
  %v_5 = extractelement <32 x i16> %v2, i32 %index_5  
  %v_6 = extractelement <32 x i16> %v2, i32 %index_6  
  %v_7 = extractelement <32 x i16> %v2, i32 %index_7  
  %v_8 = extractelement <32 x i16> %v2, i32 %index_8  
  %v_9 = extractelement <32 x i16> %v2, i32 %index_9  
  %v_10 = extractelement <32 x i16> %v2, i32 %index_10  
  %v_11 = extractelement <32 x i16> %v2, i32 %index_11  
  %v_12 = extractelement <32 x i16> %v2, i32 %index_12  
  %v_13 = extractelement <32 x i16> %v2, i32 %index_13  
  %v_14 = extractelement <32 x i16> %v2, i32 %index_14  
  %v_15 = extractelement <32 x i16> %v2, i32 %index_15

  %ret_0 = insertelement <16 x i16> undef, i16 %v_0, i32 0
  %ret_1 = insertelement <16 x i16> %ret_0, i16 %v_1, i32 1
  %ret_2 = insertelement <16 x i16> %ret_1, i16 %v_2, i32 2
  %ret_3 = insertelement <16 x i16> %ret_2, i16 %v_3, i32 3
  %ret_4 = insertelement <16 x i16> %ret_3, i16 %v_4, i32 4
  %ret_5 = insertelement <16 x i16> %ret_4, i16 %v_5, i32 5
  %ret_6 = insertelement <16 x i16> %ret_5, i16 %v_6, i32 6
  %ret_7 = insertelement <16 x i16> %ret_6, i16 %v_7, i32 7
  %ret_8 = insertelement <16 x i16> %ret_7, i16 %v_8, i32 8
  %ret_9 = insertelement <16 x i16> %ret_8, i16 %v_9, i32 9
  %ret_10 = insertelement <16 x i16> %ret_9, i16 %v_10, i32 10
  %ret_11 = insertelement <16 x i16> %ret_10, i16 %v_11, i32 11
  %ret_12 = insertelement <16 x i16> %ret_11, i16 %v_12, i32 12
  %ret_13 = insertelement <16 x i16> %ret_12, i16 %v_13, i32 13
  %ret_14 = insertelement <16 x i16> %ret_13, i16 %v_14, i32 14
  %ret_15 = insertelement <16 x i16> %ret_14, i16 %v_15, i32 15

  ret <16 x i16> %ret_15

not_const:
  ; otherwise store the two vectors onto the stack and then use the given
  ; permutation vector to get indices into that array...
  %ptr = alloca <32 x i16>
  store <32 x i16> %v2, <32 x i16> * %ptr
  %baseptr = bitcast <32 x i16> * %ptr to i16 *

  %ptr_0 = getelementptr i16 , i16 *
 %baseptr, i32 %index_0
  %val_0 = load i16  , i16  *
  %ptr_0
  %result_0 = insertelement <16 x i16> undef, i16 %val_0, i32 0

  
  %ptr_1 = getelementptr i16 , i16 *
 %baseptr, i32 %index_1
  %val_1 = load i16  , i16  *
  %ptr_1
  %result_1 = insertelement <16 x i16> %result_0, i16 %val_1, i32 1
  
  %ptr_2 = getelementptr i16 , i16 *
 %baseptr, i32 %index_2
  %val_2 = load i16  , i16  *
  %ptr_2
  %result_2 = insertelement <16 x i16> %result_1, i16 %val_2, i32 2
  
  %ptr_3 = getelementptr i16 , i16 *
 %baseptr, i32 %index_3
  %val_3 = load i16  , i16  *
  %ptr_3
  %result_3 = insertelement <16 x i16> %result_2, i16 %val_3, i32 3
  
  %ptr_4 = getelementptr i16 , i16 *
 %baseptr, i32 %index_4
  %val_4 = load i16  , i16  *
  %ptr_4
  %result_4 = insertelement <16 x i16> %result_3, i16 %val_4, i32 4
  
  %ptr_5 = getelementptr i16 , i16 *
 %baseptr, i32 %index_5
  %val_5 = load i16  , i16  *
  %ptr_5
  %result_5 = insertelement <16 x i16> %result_4, i16 %val_5, i32 5
  
  %ptr_6 = getelementptr i16 , i16 *
 %baseptr, i32 %index_6
  %val_6 = load i16  , i16  *
  %ptr_6
  %result_6 = insertelement <16 x i16> %result_5, i16 %val_6, i32 6
  
  %ptr_7 = getelementptr i16 , i16 *
 %baseptr, i32 %index_7
  %val_7 = load i16  , i16  *
  %ptr_7
  %result_7 = insertelement <16 x i16> %result_6, i16 %val_7, i32 7
  
  %ptr_8 = getelementptr i16 , i16 *
 %baseptr, i32 %index_8
  %val_8 = load i16  , i16  *
  %ptr_8
  %result_8 = insertelement <16 x i16> %result_7, i16 %val_8, i32 8
  
  %ptr_9 = getelementptr i16 , i16 *
 %baseptr, i32 %index_9
  %val_9 = load i16  , i16  *
  %ptr_9
  %result_9 = insertelement <16 x i16> %result_8, i16 %val_9, i32 9
  
  %ptr_10 = getelementptr i16 , i16 *
 %baseptr, i32 %index_10
  %val_10 = load i16  , i16  *
  %ptr_10
  %result_10 = insertelement <16 x i16> %result_9, i16 %val_10, i32 10
  
  %ptr_11 = getelementptr i16 , i16 *
 %baseptr, i32 %index_11
  %val_11 = load i16  , i16  *
  %ptr_11
  %result_11 = insertelement <16 x i16> %result_10, i16 %val_11, i32 11
  
  %ptr_12 = getelementptr i16 , i16 *
 %baseptr, i32 %index_12
  %val_12 = load i16  , i16  *
  %ptr_12
  %result_12 = insertelement <16 x i16> %result_11, i16 %val_12, i32 12
  
  %ptr_13 = getelementptr i16 , i16 *
 %baseptr, i32 %index_13
  %val_13 = load i16  , i16  *
  %ptr_13
  %result_13 = insertelement <16 x i16> %result_12, i16 %val_13, i32 13
  
  %ptr_14 = getelementptr i16 , i16 *
 %baseptr, i32 %index_14
  %val_14 = load i16  , i16  *
  %ptr_14
  %result_14 = insertelement <16 x i16> %result_13, i16 %val_14, i32 14
  
  %ptr_15 = getelementptr i16 , i16 *
 %baseptr, i32 %index_15
  %val_15 = load i16  , i16  *
  %ptr_15
  %result_15 = insertelement <16 x i16> %result_14, i16 %val_15, i32 15


  ret <16 x i16> %result_15
}


define <16 x float> @__broadcast_float(<16 x float>, i32) nounwind readnone alwaysinline {
  %v = extractelement <16 x float> %0, i32 %1
  %broadcast_init = insertelement <16 x float> undef, float %v, i32 0
  %broadcast = shufflevector <16 x float> %broadcast_init, <16 x float> undef, <16 x i32> zeroinitializer 
  ret <16 x float> %broadcast
}

define <16 x float> @__rotate_float(<16 x float>, i32) nounwind readnone alwaysinline {
  %isc = call i1 @__is_compile_time_constant_uniform_int32(i32 %1)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; though verbose, this turms into tight code if %1 is a constant
  
  %delta_0 = add i32 %1, 0
  %delta_clamped_0 = and i32 %delta_0, 15
  %v_0 = extractelement <16 x float> %0, i32 %delta_clamped_0  
  %delta_1 = add i32 %1, 1
  %delta_clamped_1 = and i32 %delta_1, 15
  %v_1 = extractelement <16 x float> %0, i32 %delta_clamped_1  
  %delta_2 = add i32 %1, 2
  %delta_clamped_2 = and i32 %delta_2, 15
  %v_2 = extractelement <16 x float> %0, i32 %delta_clamped_2  
  %delta_3 = add i32 %1, 3
  %delta_clamped_3 = and i32 %delta_3, 15
  %v_3 = extractelement <16 x float> %0, i32 %delta_clamped_3  
  %delta_4 = add i32 %1, 4
  %delta_clamped_4 = and i32 %delta_4, 15
  %v_4 = extractelement <16 x float> %0, i32 %delta_clamped_4  
  %delta_5 = add i32 %1, 5
  %delta_clamped_5 = and i32 %delta_5, 15
  %v_5 = extractelement <16 x float> %0, i32 %delta_clamped_5  
  %delta_6 = add i32 %1, 6
  %delta_clamped_6 = and i32 %delta_6, 15
  %v_6 = extractelement <16 x float> %0, i32 %delta_clamped_6  
  %delta_7 = add i32 %1, 7
  %delta_clamped_7 = and i32 %delta_7, 15
  %v_7 = extractelement <16 x float> %0, i32 %delta_clamped_7  
  %delta_8 = add i32 %1, 8
  %delta_clamped_8 = and i32 %delta_8, 15
  %v_8 = extractelement <16 x float> %0, i32 %delta_clamped_8  
  %delta_9 = add i32 %1, 9
  %delta_clamped_9 = and i32 %delta_9, 15
  %v_9 = extractelement <16 x float> %0, i32 %delta_clamped_9  
  %delta_10 = add i32 %1, 10
  %delta_clamped_10 = and i32 %delta_10, 15
  %v_10 = extractelement <16 x float> %0, i32 %delta_clamped_10  
  %delta_11 = add i32 %1, 11
  %delta_clamped_11 = and i32 %delta_11, 15
  %v_11 = extractelement <16 x float> %0, i32 %delta_clamped_11  
  %delta_12 = add i32 %1, 12
  %delta_clamped_12 = and i32 %delta_12, 15
  %v_12 = extractelement <16 x float> %0, i32 %delta_clamped_12  
  %delta_13 = add i32 %1, 13
  %delta_clamped_13 = and i32 %delta_13, 15
  %v_13 = extractelement <16 x float> %0, i32 %delta_clamped_13  
  %delta_14 = add i32 %1, 14
  %delta_clamped_14 = and i32 %delta_14, 15
  %v_14 = extractelement <16 x float> %0, i32 %delta_clamped_14  
  %delta_15 = add i32 %1, 15
  %delta_clamped_15 = and i32 %delta_15, 15
  %v_15 = extractelement <16 x float> %0, i32 %delta_clamped_15

  %ret_0 = insertelement <16 x float> undef, float %v_0, i32 0
  %ret_1 = insertelement <16 x float> %ret_0, float %v_1, i32 1
  %ret_2 = insertelement <16 x float> %ret_1, float %v_2, i32 2
  %ret_3 = insertelement <16 x float> %ret_2, float %v_3, i32 3
  %ret_4 = insertelement <16 x float> %ret_3, float %v_4, i32 4
  %ret_5 = insertelement <16 x float> %ret_4, float %v_5, i32 5
  %ret_6 = insertelement <16 x float> %ret_5, float %v_6, i32 6
  %ret_7 = insertelement <16 x float> %ret_6, float %v_7, i32 7
  %ret_8 = insertelement <16 x float> %ret_7, float %v_8, i32 8
  %ret_9 = insertelement <16 x float> %ret_8, float %v_9, i32 9
  %ret_10 = insertelement <16 x float> %ret_9, float %v_10, i32 10
  %ret_11 = insertelement <16 x float> %ret_10, float %v_11, i32 11
  %ret_12 = insertelement <16 x float> %ret_11, float %v_12, i32 12
  %ret_13 = insertelement <16 x float> %ret_12, float %v_13, i32 13
  %ret_14 = insertelement <16 x float> %ret_13, float %v_14, i32 14
  %ret_15 = insertelement <16 x float> %ret_14, float %v_15, i32 15

  ret <16 x float> %ret_15

not_const:
  ; store two instances of the vector into memory
  %ptr = alloca <16 x float>, i32 2
  %ptr0 = getelementptr <16 x float> , <16 x float> *
 %ptr, i32 0
  store <16 x float> %0, <16 x float> * %ptr0
  %ptr1 = getelementptr <16 x float> , <16 x float> *
 %ptr, i32 1
  store <16 x float> %0, <16 x float> * %ptr1

  ; compute offset in [0,vectorwidth-1], then index into the doubled-up vector
  %offset = and i32 %1, 15
  %ptr_as_elt_array = bitcast <16 x float> * %ptr to [32 x float] *
  %load_ptr = getelementptr [32 x float] , [32 x float] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast float * %load_ptr to <16 x float> *
  %result = load <16 x float>  , <16 x float>  *
  %load_ptr_vec, align 4
  ret <16 x float> %result
}

define <16 x float> @__shift_float(<16 x float>, i32) nounwind readnone alwaysinline {
  %ptr = alloca <16 x float>, i32 3
  %ptr0 = getelementptr <16 x float> , <16 x float> *
 %ptr, i32 0
  store <16 x float> zeroinitializer, <16 x float> * %ptr0
  %ptr1 = getelementptr <16 x float> , <16 x float> *
 %ptr, i32 1
  store <16 x float> %0, <16 x float> * %ptr1
  %ptr2 = getelementptr <16 x float> , <16 x float> *
 %ptr, i32 2
  store <16 x float> zeroinitializer, <16 x float> * %ptr2

  %offset = add i32 %1, 16
  %ptr_as_elt_array = bitcast <16 x float> * %ptr to [48 x float] *
  %load_ptr = getelementptr [48 x float] , [48 x float] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast float * %load_ptr to <16 x float> *
  %result = load <16 x float>  , <16 x float>  *
  %load_ptr_vec, align 4
  ret <16 x float> %result
}


define <16 x float> @__shuffle_float(<16 x float>, <16 x i32>) nounwind readnone alwaysinline {
  
  %index_0 = extractelement <16 x i32> %1, i32 0  
  %index_1 = extractelement <16 x i32> %1, i32 1  
  %index_2 = extractelement <16 x i32> %1, i32 2  
  %index_3 = extractelement <16 x i32> %1, i32 3  
  %index_4 = extractelement <16 x i32> %1, i32 4  
  %index_5 = extractelement <16 x i32> %1, i32 5  
  %index_6 = extractelement <16 x i32> %1, i32 6  
  %index_7 = extractelement <16 x i32> %1, i32 7  
  %index_8 = extractelement <16 x i32> %1, i32 8  
  %index_9 = extractelement <16 x i32> %1, i32 9  
  %index_10 = extractelement <16 x i32> %1, i32 10  
  %index_11 = extractelement <16 x i32> %1, i32 11  
  %index_12 = extractelement <16 x i32> %1, i32 12  
  %index_13 = extractelement <16 x i32> %1, i32 13  
  %index_14 = extractelement <16 x i32> %1, i32 14  
  %index_15 = extractelement <16 x i32> %1, i32 15
  
  %v_0 = extractelement <16 x float> %0, i32 %index_0  
  %v_1 = extractelement <16 x float> %0, i32 %index_1  
  %v_2 = extractelement <16 x float> %0, i32 %index_2  
  %v_3 = extractelement <16 x float> %0, i32 %index_3  
  %v_4 = extractelement <16 x float> %0, i32 %index_4  
  %v_5 = extractelement <16 x float> %0, i32 %index_5  
  %v_6 = extractelement <16 x float> %0, i32 %index_6  
  %v_7 = extractelement <16 x float> %0, i32 %index_7  
  %v_8 = extractelement <16 x float> %0, i32 %index_8  
  %v_9 = extractelement <16 x float> %0, i32 %index_9  
  %v_10 = extractelement <16 x float> %0, i32 %index_10  
  %v_11 = extractelement <16 x float> %0, i32 %index_11  
  %v_12 = extractelement <16 x float> %0, i32 %index_12  
  %v_13 = extractelement <16 x float> %0, i32 %index_13  
  %v_14 = extractelement <16 x float> %0, i32 %index_14  
  %v_15 = extractelement <16 x float> %0, i32 %index_15

  %ret_0 = insertelement <16 x float> undef, float %v_0, i32 0
  %ret_1 = insertelement <16 x float> %ret_0, float %v_1, i32 1
  %ret_2 = insertelement <16 x float> %ret_1, float %v_2, i32 2
  %ret_3 = insertelement <16 x float> %ret_2, float %v_3, i32 3
  %ret_4 = insertelement <16 x float> %ret_3, float %v_4, i32 4
  %ret_5 = insertelement <16 x float> %ret_4, float %v_5, i32 5
  %ret_6 = insertelement <16 x float> %ret_5, float %v_6, i32 6
  %ret_7 = insertelement <16 x float> %ret_6, float %v_7, i32 7
  %ret_8 = insertelement <16 x float> %ret_7, float %v_8, i32 8
  %ret_9 = insertelement <16 x float> %ret_8, float %v_9, i32 9
  %ret_10 = insertelement <16 x float> %ret_9, float %v_10, i32 10
  %ret_11 = insertelement <16 x float> %ret_10, float %v_11, i32 11
  %ret_12 = insertelement <16 x float> %ret_11, float %v_12, i32 12
  %ret_13 = insertelement <16 x float> %ret_12, float %v_13, i32 13
  %ret_14 = insertelement <16 x float> %ret_13, float %v_14, i32 14
  %ret_15 = insertelement <16 x float> %ret_14, float %v_15, i32 15

  ret <16 x float> %ret_15
}

define <16 x float> @__shuffle2_float(<16 x float>, <16 x float>, <16 x i32>) nounwind readnone alwaysinline {
  %v2 = shufflevector <16 x float> %0, <16 x float> %1, <32 x i32> <
      i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30,  i32 31
  >
  
  %index_0 = extractelement <16 x i32> %2, i32 0  
  %index_1 = extractelement <16 x i32> %2, i32 1  
  %index_2 = extractelement <16 x i32> %2, i32 2  
  %index_3 = extractelement <16 x i32> %2, i32 3  
  %index_4 = extractelement <16 x i32> %2, i32 4  
  %index_5 = extractelement <16 x i32> %2, i32 5  
  %index_6 = extractelement <16 x i32> %2, i32 6  
  %index_7 = extractelement <16 x i32> %2, i32 7  
  %index_8 = extractelement <16 x i32> %2, i32 8  
  %index_9 = extractelement <16 x i32> %2, i32 9  
  %index_10 = extractelement <16 x i32> %2, i32 10  
  %index_11 = extractelement <16 x i32> %2, i32 11  
  %index_12 = extractelement <16 x i32> %2, i32 12  
  %index_13 = extractelement <16 x i32> %2, i32 13  
  %index_14 = extractelement <16 x i32> %2, i32 14  
  %index_15 = extractelement <16 x i32> %2, i32 15

  %isc = call i1 @__is_compile_time_constant_varying_int32(<16 x i32> %2)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; extract from the requested lanes and insert into the result; LLVM turns
  ; this into good code in the end
  
  %v_0 = extractelement <32 x float> %v2, i32 %index_0  
  %v_1 = extractelement <32 x float> %v2, i32 %index_1  
  %v_2 = extractelement <32 x float> %v2, i32 %index_2  
  %v_3 = extractelement <32 x float> %v2, i32 %index_3  
  %v_4 = extractelement <32 x float> %v2, i32 %index_4  
  %v_5 = extractelement <32 x float> %v2, i32 %index_5  
  %v_6 = extractelement <32 x float> %v2, i32 %index_6  
  %v_7 = extractelement <32 x float> %v2, i32 %index_7  
  %v_8 = extractelement <32 x float> %v2, i32 %index_8  
  %v_9 = extractelement <32 x float> %v2, i32 %index_9  
  %v_10 = extractelement <32 x float> %v2, i32 %index_10  
  %v_11 = extractelement <32 x float> %v2, i32 %index_11  
  %v_12 = extractelement <32 x float> %v2, i32 %index_12  
  %v_13 = extractelement <32 x float> %v2, i32 %index_13  
  %v_14 = extractelement <32 x float> %v2, i32 %index_14  
  %v_15 = extractelement <32 x float> %v2, i32 %index_15

  %ret_0 = insertelement <16 x float> undef, float %v_0, i32 0
  %ret_1 = insertelement <16 x float> %ret_0, float %v_1, i32 1
  %ret_2 = insertelement <16 x float> %ret_1, float %v_2, i32 2
  %ret_3 = insertelement <16 x float> %ret_2, float %v_3, i32 3
  %ret_4 = insertelement <16 x float> %ret_3, float %v_4, i32 4
  %ret_5 = insertelement <16 x float> %ret_4, float %v_5, i32 5
  %ret_6 = insertelement <16 x float> %ret_5, float %v_6, i32 6
  %ret_7 = insertelement <16 x float> %ret_6, float %v_7, i32 7
  %ret_8 = insertelement <16 x float> %ret_7, float %v_8, i32 8
  %ret_9 = insertelement <16 x float> %ret_8, float %v_9, i32 9
  %ret_10 = insertelement <16 x float> %ret_9, float %v_10, i32 10
  %ret_11 = insertelement <16 x float> %ret_10, float %v_11, i32 11
  %ret_12 = insertelement <16 x float> %ret_11, float %v_12, i32 12
  %ret_13 = insertelement <16 x float> %ret_12, float %v_13, i32 13
  %ret_14 = insertelement <16 x float> %ret_13, float %v_14, i32 14
  %ret_15 = insertelement <16 x float> %ret_14, float %v_15, i32 15

  ret <16 x float> %ret_15

not_const:
  ; otherwise store the two vectors onto the stack and then use the given
  ; permutation vector to get indices into that array...
  %ptr = alloca <32 x float>
  store <32 x float> %v2, <32 x float> * %ptr
  %baseptr = bitcast <32 x float> * %ptr to float *

  %ptr_0 = getelementptr float , float *
 %baseptr, i32 %index_0
  %val_0 = load float  , float  *
  %ptr_0
  %result_0 = insertelement <16 x float> undef, float %val_0, i32 0

  
  %ptr_1 = getelementptr float , float *
 %baseptr, i32 %index_1
  %val_1 = load float  , float  *
  %ptr_1
  %result_1 = insertelement <16 x float> %result_0, float %val_1, i32 1
  
  %ptr_2 = getelementptr float , float *
 %baseptr, i32 %index_2
  %val_2 = load float  , float  *
  %ptr_2
  %result_2 = insertelement <16 x float> %result_1, float %val_2, i32 2
  
  %ptr_3 = getelementptr float , float *
 %baseptr, i32 %index_3
  %val_3 = load float  , float  *
  %ptr_3
  %result_3 = insertelement <16 x float> %result_2, float %val_3, i32 3
  
  %ptr_4 = getelementptr float , float *
 %baseptr, i32 %index_4
  %val_4 = load float  , float  *
  %ptr_4
  %result_4 = insertelement <16 x float> %result_3, float %val_4, i32 4
  
  %ptr_5 = getelementptr float , float *
 %baseptr, i32 %index_5
  %val_5 = load float  , float  *
  %ptr_5
  %result_5 = insertelement <16 x float> %result_4, float %val_5, i32 5
  
  %ptr_6 = getelementptr float , float *
 %baseptr, i32 %index_6
  %val_6 = load float  , float  *
  %ptr_6
  %result_6 = insertelement <16 x float> %result_5, float %val_6, i32 6
  
  %ptr_7 = getelementptr float , float *
 %baseptr, i32 %index_7
  %val_7 = load float  , float  *
  %ptr_7
  %result_7 = insertelement <16 x float> %result_6, float %val_7, i32 7
  
  %ptr_8 = getelementptr float , float *
 %baseptr, i32 %index_8
  %val_8 = load float  , float  *
  %ptr_8
  %result_8 = insertelement <16 x float> %result_7, float %val_8, i32 8
  
  %ptr_9 = getelementptr float , float *
 %baseptr, i32 %index_9
  %val_9 = load float  , float  *
  %ptr_9
  %result_9 = insertelement <16 x float> %result_8, float %val_9, i32 9
  
  %ptr_10 = getelementptr float , float *
 %baseptr, i32 %index_10
  %val_10 = load float  , float  *
  %ptr_10
  %result_10 = insertelement <16 x float> %result_9, float %val_10, i32 10
  
  %ptr_11 = getelementptr float , float *
 %baseptr, i32 %index_11
  %val_11 = load float  , float  *
  %ptr_11
  %result_11 = insertelement <16 x float> %result_10, float %val_11, i32 11
  
  %ptr_12 = getelementptr float , float *
 %baseptr, i32 %index_12
  %val_12 = load float  , float  *
  %ptr_12
  %result_12 = insertelement <16 x float> %result_11, float %val_12, i32 12
  
  %ptr_13 = getelementptr float , float *
 %baseptr, i32 %index_13
  %val_13 = load float  , float  *
  %ptr_13
  %result_13 = insertelement <16 x float> %result_12, float %val_13, i32 13
  
  %ptr_14 = getelementptr float , float *
 %baseptr, i32 %index_14
  %val_14 = load float  , float  *
  %ptr_14
  %result_14 = insertelement <16 x float> %result_13, float %val_14, i32 14
  
  %ptr_15 = getelementptr float , float *
 %baseptr, i32 %index_15
  %val_15 = load float  , float  *
  %ptr_15
  %result_15 = insertelement <16 x float> %result_14, float %val_15, i32 15


  ret <16 x float> %result_15
}


define <16 x i32> @__broadcast_i32(<16 x i32>, i32) nounwind readnone alwaysinline {
  %v = extractelement <16 x i32> %0, i32 %1
  %broadcast_init = insertelement <16 x i32> undef, i32 %v, i32 0
  %broadcast = shufflevector <16 x i32> %broadcast_init, <16 x i32> undef, <16 x i32> zeroinitializer 
  ret <16 x i32> %broadcast
}

define <16 x i32> @__rotate_i32(<16 x i32>, i32) nounwind readnone alwaysinline {
  %isc = call i1 @__is_compile_time_constant_uniform_int32(i32 %1)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; though verbose, this turms into tight code if %1 is a constant
  
  %delta_0 = add i32 %1, 0
  %delta_clamped_0 = and i32 %delta_0, 15
  %v_0 = extractelement <16 x i32> %0, i32 %delta_clamped_0  
  %delta_1 = add i32 %1, 1
  %delta_clamped_1 = and i32 %delta_1, 15
  %v_1 = extractelement <16 x i32> %0, i32 %delta_clamped_1  
  %delta_2 = add i32 %1, 2
  %delta_clamped_2 = and i32 %delta_2, 15
  %v_2 = extractelement <16 x i32> %0, i32 %delta_clamped_2  
  %delta_3 = add i32 %1, 3
  %delta_clamped_3 = and i32 %delta_3, 15
  %v_3 = extractelement <16 x i32> %0, i32 %delta_clamped_3  
  %delta_4 = add i32 %1, 4
  %delta_clamped_4 = and i32 %delta_4, 15
  %v_4 = extractelement <16 x i32> %0, i32 %delta_clamped_4  
  %delta_5 = add i32 %1, 5
  %delta_clamped_5 = and i32 %delta_5, 15
  %v_5 = extractelement <16 x i32> %0, i32 %delta_clamped_5  
  %delta_6 = add i32 %1, 6
  %delta_clamped_6 = and i32 %delta_6, 15
  %v_6 = extractelement <16 x i32> %0, i32 %delta_clamped_6  
  %delta_7 = add i32 %1, 7
  %delta_clamped_7 = and i32 %delta_7, 15
  %v_7 = extractelement <16 x i32> %0, i32 %delta_clamped_7  
  %delta_8 = add i32 %1, 8
  %delta_clamped_8 = and i32 %delta_8, 15
  %v_8 = extractelement <16 x i32> %0, i32 %delta_clamped_8  
  %delta_9 = add i32 %1, 9
  %delta_clamped_9 = and i32 %delta_9, 15
  %v_9 = extractelement <16 x i32> %0, i32 %delta_clamped_9  
  %delta_10 = add i32 %1, 10
  %delta_clamped_10 = and i32 %delta_10, 15
  %v_10 = extractelement <16 x i32> %0, i32 %delta_clamped_10  
  %delta_11 = add i32 %1, 11
  %delta_clamped_11 = and i32 %delta_11, 15
  %v_11 = extractelement <16 x i32> %0, i32 %delta_clamped_11  
  %delta_12 = add i32 %1, 12
  %delta_clamped_12 = and i32 %delta_12, 15
  %v_12 = extractelement <16 x i32> %0, i32 %delta_clamped_12  
  %delta_13 = add i32 %1, 13
  %delta_clamped_13 = and i32 %delta_13, 15
  %v_13 = extractelement <16 x i32> %0, i32 %delta_clamped_13  
  %delta_14 = add i32 %1, 14
  %delta_clamped_14 = and i32 %delta_14, 15
  %v_14 = extractelement <16 x i32> %0, i32 %delta_clamped_14  
  %delta_15 = add i32 %1, 15
  %delta_clamped_15 = and i32 %delta_15, 15
  %v_15 = extractelement <16 x i32> %0, i32 %delta_clamped_15

  %ret_0 = insertelement <16 x i32> undef, i32 %v_0, i32 0
  %ret_1 = insertelement <16 x i32> %ret_0, i32 %v_1, i32 1
  %ret_2 = insertelement <16 x i32> %ret_1, i32 %v_2, i32 2
  %ret_3 = insertelement <16 x i32> %ret_2, i32 %v_3, i32 3
  %ret_4 = insertelement <16 x i32> %ret_3, i32 %v_4, i32 4
  %ret_5 = insertelement <16 x i32> %ret_4, i32 %v_5, i32 5
  %ret_6 = insertelement <16 x i32> %ret_5, i32 %v_6, i32 6
  %ret_7 = insertelement <16 x i32> %ret_6, i32 %v_7, i32 7
  %ret_8 = insertelement <16 x i32> %ret_7, i32 %v_8, i32 8
  %ret_9 = insertelement <16 x i32> %ret_8, i32 %v_9, i32 9
  %ret_10 = insertelement <16 x i32> %ret_9, i32 %v_10, i32 10
  %ret_11 = insertelement <16 x i32> %ret_10, i32 %v_11, i32 11
  %ret_12 = insertelement <16 x i32> %ret_11, i32 %v_12, i32 12
  %ret_13 = insertelement <16 x i32> %ret_12, i32 %v_13, i32 13
  %ret_14 = insertelement <16 x i32> %ret_13, i32 %v_14, i32 14
  %ret_15 = insertelement <16 x i32> %ret_14, i32 %v_15, i32 15

  ret <16 x i32> %ret_15

not_const:
  ; store two instances of the vector into memory
  %ptr = alloca <16 x i32>, i32 2
  %ptr0 = getelementptr <16 x i32> , <16 x i32> *
 %ptr, i32 0
  store <16 x i32> %0, <16 x i32> * %ptr0
  %ptr1 = getelementptr <16 x i32> , <16 x i32> *
 %ptr, i32 1
  store <16 x i32> %0, <16 x i32> * %ptr1

  ; compute offset in [0,vectorwidth-1], then index into the doubled-up vector
  %offset = and i32 %1, 15
  %ptr_as_elt_array = bitcast <16 x i32> * %ptr to [32 x i32] *
  %load_ptr = getelementptr [32 x i32] , [32 x i32] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i32 * %load_ptr to <16 x i32> *
  %result = load <16 x i32>  , <16 x i32>  *
  %load_ptr_vec, align 4
  ret <16 x i32> %result
}

define <16 x i32> @__shift_i32(<16 x i32>, i32) nounwind readnone alwaysinline {
  %ptr = alloca <16 x i32>, i32 3
  %ptr0 = getelementptr <16 x i32> , <16 x i32> *
 %ptr, i32 0
  store <16 x i32> zeroinitializer, <16 x i32> * %ptr0
  %ptr1 = getelementptr <16 x i32> , <16 x i32> *
 %ptr, i32 1
  store <16 x i32> %0, <16 x i32> * %ptr1
  %ptr2 = getelementptr <16 x i32> , <16 x i32> *
 %ptr, i32 2
  store <16 x i32> zeroinitializer, <16 x i32> * %ptr2

  %offset = add i32 %1, 16
  %ptr_as_elt_array = bitcast <16 x i32> * %ptr to [48 x i32] *
  %load_ptr = getelementptr [48 x i32] , [48 x i32] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i32 * %load_ptr to <16 x i32> *
  %result = load <16 x i32>  , <16 x i32>  *
  %load_ptr_vec, align 4
  ret <16 x i32> %result
}


define <16 x i32> @__shuffle_i32(<16 x i32>, <16 x i32>) nounwind readnone alwaysinline {
  
  %index_0 = extractelement <16 x i32> %1, i32 0  
  %index_1 = extractelement <16 x i32> %1, i32 1  
  %index_2 = extractelement <16 x i32> %1, i32 2  
  %index_3 = extractelement <16 x i32> %1, i32 3  
  %index_4 = extractelement <16 x i32> %1, i32 4  
  %index_5 = extractelement <16 x i32> %1, i32 5  
  %index_6 = extractelement <16 x i32> %1, i32 6  
  %index_7 = extractelement <16 x i32> %1, i32 7  
  %index_8 = extractelement <16 x i32> %1, i32 8  
  %index_9 = extractelement <16 x i32> %1, i32 9  
  %index_10 = extractelement <16 x i32> %1, i32 10  
  %index_11 = extractelement <16 x i32> %1, i32 11  
  %index_12 = extractelement <16 x i32> %1, i32 12  
  %index_13 = extractelement <16 x i32> %1, i32 13  
  %index_14 = extractelement <16 x i32> %1, i32 14  
  %index_15 = extractelement <16 x i32> %1, i32 15
  
  %v_0 = extractelement <16 x i32> %0, i32 %index_0  
  %v_1 = extractelement <16 x i32> %0, i32 %index_1  
  %v_2 = extractelement <16 x i32> %0, i32 %index_2  
  %v_3 = extractelement <16 x i32> %0, i32 %index_3  
  %v_4 = extractelement <16 x i32> %0, i32 %index_4  
  %v_5 = extractelement <16 x i32> %0, i32 %index_5  
  %v_6 = extractelement <16 x i32> %0, i32 %index_6  
  %v_7 = extractelement <16 x i32> %0, i32 %index_7  
  %v_8 = extractelement <16 x i32> %0, i32 %index_8  
  %v_9 = extractelement <16 x i32> %0, i32 %index_9  
  %v_10 = extractelement <16 x i32> %0, i32 %index_10  
  %v_11 = extractelement <16 x i32> %0, i32 %index_11  
  %v_12 = extractelement <16 x i32> %0, i32 %index_12  
  %v_13 = extractelement <16 x i32> %0, i32 %index_13  
  %v_14 = extractelement <16 x i32> %0, i32 %index_14  
  %v_15 = extractelement <16 x i32> %0, i32 %index_15

  %ret_0 = insertelement <16 x i32> undef, i32 %v_0, i32 0
  %ret_1 = insertelement <16 x i32> %ret_0, i32 %v_1, i32 1
  %ret_2 = insertelement <16 x i32> %ret_1, i32 %v_2, i32 2
  %ret_3 = insertelement <16 x i32> %ret_2, i32 %v_3, i32 3
  %ret_4 = insertelement <16 x i32> %ret_3, i32 %v_4, i32 4
  %ret_5 = insertelement <16 x i32> %ret_4, i32 %v_5, i32 5
  %ret_6 = insertelement <16 x i32> %ret_5, i32 %v_6, i32 6
  %ret_7 = insertelement <16 x i32> %ret_6, i32 %v_7, i32 7
  %ret_8 = insertelement <16 x i32> %ret_7, i32 %v_8, i32 8
  %ret_9 = insertelement <16 x i32> %ret_8, i32 %v_9, i32 9
  %ret_10 = insertelement <16 x i32> %ret_9, i32 %v_10, i32 10
  %ret_11 = insertelement <16 x i32> %ret_10, i32 %v_11, i32 11
  %ret_12 = insertelement <16 x i32> %ret_11, i32 %v_12, i32 12
  %ret_13 = insertelement <16 x i32> %ret_12, i32 %v_13, i32 13
  %ret_14 = insertelement <16 x i32> %ret_13, i32 %v_14, i32 14
  %ret_15 = insertelement <16 x i32> %ret_14, i32 %v_15, i32 15

  ret <16 x i32> %ret_15
}

define <16 x i32> @__shuffle2_i32(<16 x i32>, <16 x i32>, <16 x i32>) nounwind readnone alwaysinline {
  %v2 = shufflevector <16 x i32> %0, <16 x i32> %1, <32 x i32> <
      i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30,  i32 31
  >
  
  %index_0 = extractelement <16 x i32> %2, i32 0  
  %index_1 = extractelement <16 x i32> %2, i32 1  
  %index_2 = extractelement <16 x i32> %2, i32 2  
  %index_3 = extractelement <16 x i32> %2, i32 3  
  %index_4 = extractelement <16 x i32> %2, i32 4  
  %index_5 = extractelement <16 x i32> %2, i32 5  
  %index_6 = extractelement <16 x i32> %2, i32 6  
  %index_7 = extractelement <16 x i32> %2, i32 7  
  %index_8 = extractelement <16 x i32> %2, i32 8  
  %index_9 = extractelement <16 x i32> %2, i32 9  
  %index_10 = extractelement <16 x i32> %2, i32 10  
  %index_11 = extractelement <16 x i32> %2, i32 11  
  %index_12 = extractelement <16 x i32> %2, i32 12  
  %index_13 = extractelement <16 x i32> %2, i32 13  
  %index_14 = extractelement <16 x i32> %2, i32 14  
  %index_15 = extractelement <16 x i32> %2, i32 15

  %isc = call i1 @__is_compile_time_constant_varying_int32(<16 x i32> %2)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; extract from the requested lanes and insert into the result; LLVM turns
  ; this into good code in the end
  
  %v_0 = extractelement <32 x i32> %v2, i32 %index_0  
  %v_1 = extractelement <32 x i32> %v2, i32 %index_1  
  %v_2 = extractelement <32 x i32> %v2, i32 %index_2  
  %v_3 = extractelement <32 x i32> %v2, i32 %index_3  
  %v_4 = extractelement <32 x i32> %v2, i32 %index_4  
  %v_5 = extractelement <32 x i32> %v2, i32 %index_5  
  %v_6 = extractelement <32 x i32> %v2, i32 %index_6  
  %v_7 = extractelement <32 x i32> %v2, i32 %index_7  
  %v_8 = extractelement <32 x i32> %v2, i32 %index_8  
  %v_9 = extractelement <32 x i32> %v2, i32 %index_9  
  %v_10 = extractelement <32 x i32> %v2, i32 %index_10  
  %v_11 = extractelement <32 x i32> %v2, i32 %index_11  
  %v_12 = extractelement <32 x i32> %v2, i32 %index_12  
  %v_13 = extractelement <32 x i32> %v2, i32 %index_13  
  %v_14 = extractelement <32 x i32> %v2, i32 %index_14  
  %v_15 = extractelement <32 x i32> %v2, i32 %index_15

  %ret_0 = insertelement <16 x i32> undef, i32 %v_0, i32 0
  %ret_1 = insertelement <16 x i32> %ret_0, i32 %v_1, i32 1
  %ret_2 = insertelement <16 x i32> %ret_1, i32 %v_2, i32 2
  %ret_3 = insertelement <16 x i32> %ret_2, i32 %v_3, i32 3
  %ret_4 = insertelement <16 x i32> %ret_3, i32 %v_4, i32 4
  %ret_5 = insertelement <16 x i32> %ret_4, i32 %v_5, i32 5
  %ret_6 = insertelement <16 x i32> %ret_5, i32 %v_6, i32 6
  %ret_7 = insertelement <16 x i32> %ret_6, i32 %v_7, i32 7
  %ret_8 = insertelement <16 x i32> %ret_7, i32 %v_8, i32 8
  %ret_9 = insertelement <16 x i32> %ret_8, i32 %v_9, i32 9
  %ret_10 = insertelement <16 x i32> %ret_9, i32 %v_10, i32 10
  %ret_11 = insertelement <16 x i32> %ret_10, i32 %v_11, i32 11
  %ret_12 = insertelement <16 x i32> %ret_11, i32 %v_12, i32 12
  %ret_13 = insertelement <16 x i32> %ret_12, i32 %v_13, i32 13
  %ret_14 = insertelement <16 x i32> %ret_13, i32 %v_14, i32 14
  %ret_15 = insertelement <16 x i32> %ret_14, i32 %v_15, i32 15

  ret <16 x i32> %ret_15

not_const:
  ; otherwise store the two vectors onto the stack and then use the given
  ; permutation vector to get indices into that array...
  %ptr = alloca <32 x i32>
  store <32 x i32> %v2, <32 x i32> * %ptr
  %baseptr = bitcast <32 x i32> * %ptr to i32 *

  %ptr_0 = getelementptr i32 , i32 *
 %baseptr, i32 %index_0
  %val_0 = load i32  , i32  *
  %ptr_0
  %result_0 = insertelement <16 x i32> undef, i32 %val_0, i32 0

  
  %ptr_1 = getelementptr i32 , i32 *
 %baseptr, i32 %index_1
  %val_1 = load i32  , i32  *
  %ptr_1
  %result_1 = insertelement <16 x i32> %result_0, i32 %val_1, i32 1
  
  %ptr_2 = getelementptr i32 , i32 *
 %baseptr, i32 %index_2
  %val_2 = load i32  , i32  *
  %ptr_2
  %result_2 = insertelement <16 x i32> %result_1, i32 %val_2, i32 2
  
  %ptr_3 = getelementptr i32 , i32 *
 %baseptr, i32 %index_3
  %val_3 = load i32  , i32  *
  %ptr_3
  %result_3 = insertelement <16 x i32> %result_2, i32 %val_3, i32 3
  
  %ptr_4 = getelementptr i32 , i32 *
 %baseptr, i32 %index_4
  %val_4 = load i32  , i32  *
  %ptr_4
  %result_4 = insertelement <16 x i32> %result_3, i32 %val_4, i32 4
  
  %ptr_5 = getelementptr i32 , i32 *
 %baseptr, i32 %index_5
  %val_5 = load i32  , i32  *
  %ptr_5
  %result_5 = insertelement <16 x i32> %result_4, i32 %val_5, i32 5
  
  %ptr_6 = getelementptr i32 , i32 *
 %baseptr, i32 %index_6
  %val_6 = load i32  , i32  *
  %ptr_6
  %result_6 = insertelement <16 x i32> %result_5, i32 %val_6, i32 6
  
  %ptr_7 = getelementptr i32 , i32 *
 %baseptr, i32 %index_7
  %val_7 = load i32  , i32  *
  %ptr_7
  %result_7 = insertelement <16 x i32> %result_6, i32 %val_7, i32 7
  
  %ptr_8 = getelementptr i32 , i32 *
 %baseptr, i32 %index_8
  %val_8 = load i32  , i32  *
  %ptr_8
  %result_8 = insertelement <16 x i32> %result_7, i32 %val_8, i32 8
  
  %ptr_9 = getelementptr i32 , i32 *
 %baseptr, i32 %index_9
  %val_9 = load i32  , i32  *
  %ptr_9
  %result_9 = insertelement <16 x i32> %result_8, i32 %val_9, i32 9
  
  %ptr_10 = getelementptr i32 , i32 *
 %baseptr, i32 %index_10
  %val_10 = load i32  , i32  *
  %ptr_10
  %result_10 = insertelement <16 x i32> %result_9, i32 %val_10, i32 10
  
  %ptr_11 = getelementptr i32 , i32 *
 %baseptr, i32 %index_11
  %val_11 = load i32  , i32  *
  %ptr_11
  %result_11 = insertelement <16 x i32> %result_10, i32 %val_11, i32 11
  
  %ptr_12 = getelementptr i32 , i32 *
 %baseptr, i32 %index_12
  %val_12 = load i32  , i32  *
  %ptr_12
  %result_12 = insertelement <16 x i32> %result_11, i32 %val_12, i32 12
  
  %ptr_13 = getelementptr i32 , i32 *
 %baseptr, i32 %index_13
  %val_13 = load i32  , i32  *
  %ptr_13
  %result_13 = insertelement <16 x i32> %result_12, i32 %val_13, i32 13
  
  %ptr_14 = getelementptr i32 , i32 *
 %baseptr, i32 %index_14
  %val_14 = load i32  , i32  *
  %ptr_14
  %result_14 = insertelement <16 x i32> %result_13, i32 %val_14, i32 14
  
  %ptr_15 = getelementptr i32 , i32 *
 %baseptr, i32 %index_15
  %val_15 = load i32  , i32  *
  %ptr_15
  %result_15 = insertelement <16 x i32> %result_14, i32 %val_15, i32 15


  ret <16 x i32> %result_15
}


define <16 x double> @__broadcast_double(<16 x double>, i32) nounwind readnone alwaysinline {
  %v = extractelement <16 x double> %0, i32 %1
  %broadcast_init = insertelement <16 x double> undef, double %v, i32 0
  %broadcast = shufflevector <16 x double> %broadcast_init, <16 x double> undef, <16 x i32> zeroinitializer 
  ret <16 x double> %broadcast
}

define <16 x double> @__rotate_double(<16 x double>, i32) nounwind readnone alwaysinline {
  %isc = call i1 @__is_compile_time_constant_uniform_int32(i32 %1)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; though verbose, this turms into tight code if %1 is a constant
  
  %delta_0 = add i32 %1, 0
  %delta_clamped_0 = and i32 %delta_0, 15
  %v_0 = extractelement <16 x double> %0, i32 %delta_clamped_0  
  %delta_1 = add i32 %1, 1
  %delta_clamped_1 = and i32 %delta_1, 15
  %v_1 = extractelement <16 x double> %0, i32 %delta_clamped_1  
  %delta_2 = add i32 %1, 2
  %delta_clamped_2 = and i32 %delta_2, 15
  %v_2 = extractelement <16 x double> %0, i32 %delta_clamped_2  
  %delta_3 = add i32 %1, 3
  %delta_clamped_3 = and i32 %delta_3, 15
  %v_3 = extractelement <16 x double> %0, i32 %delta_clamped_3  
  %delta_4 = add i32 %1, 4
  %delta_clamped_4 = and i32 %delta_4, 15
  %v_4 = extractelement <16 x double> %0, i32 %delta_clamped_4  
  %delta_5 = add i32 %1, 5
  %delta_clamped_5 = and i32 %delta_5, 15
  %v_5 = extractelement <16 x double> %0, i32 %delta_clamped_5  
  %delta_6 = add i32 %1, 6
  %delta_clamped_6 = and i32 %delta_6, 15
  %v_6 = extractelement <16 x double> %0, i32 %delta_clamped_6  
  %delta_7 = add i32 %1, 7
  %delta_clamped_7 = and i32 %delta_7, 15
  %v_7 = extractelement <16 x double> %0, i32 %delta_clamped_7  
  %delta_8 = add i32 %1, 8
  %delta_clamped_8 = and i32 %delta_8, 15
  %v_8 = extractelement <16 x double> %0, i32 %delta_clamped_8  
  %delta_9 = add i32 %1, 9
  %delta_clamped_9 = and i32 %delta_9, 15
  %v_9 = extractelement <16 x double> %0, i32 %delta_clamped_9  
  %delta_10 = add i32 %1, 10
  %delta_clamped_10 = and i32 %delta_10, 15
  %v_10 = extractelement <16 x double> %0, i32 %delta_clamped_10  
  %delta_11 = add i32 %1, 11
  %delta_clamped_11 = and i32 %delta_11, 15
  %v_11 = extractelement <16 x double> %0, i32 %delta_clamped_11  
  %delta_12 = add i32 %1, 12
  %delta_clamped_12 = and i32 %delta_12, 15
  %v_12 = extractelement <16 x double> %0, i32 %delta_clamped_12  
  %delta_13 = add i32 %1, 13
  %delta_clamped_13 = and i32 %delta_13, 15
  %v_13 = extractelement <16 x double> %0, i32 %delta_clamped_13  
  %delta_14 = add i32 %1, 14
  %delta_clamped_14 = and i32 %delta_14, 15
  %v_14 = extractelement <16 x double> %0, i32 %delta_clamped_14  
  %delta_15 = add i32 %1, 15
  %delta_clamped_15 = and i32 %delta_15, 15
  %v_15 = extractelement <16 x double> %0, i32 %delta_clamped_15

  %ret_0 = insertelement <16 x double> undef, double %v_0, i32 0
  %ret_1 = insertelement <16 x double> %ret_0, double %v_1, i32 1
  %ret_2 = insertelement <16 x double> %ret_1, double %v_2, i32 2
  %ret_3 = insertelement <16 x double> %ret_2, double %v_3, i32 3
  %ret_4 = insertelement <16 x double> %ret_3, double %v_4, i32 4
  %ret_5 = insertelement <16 x double> %ret_4, double %v_5, i32 5
  %ret_6 = insertelement <16 x double> %ret_5, double %v_6, i32 6
  %ret_7 = insertelement <16 x double> %ret_6, double %v_7, i32 7
  %ret_8 = insertelement <16 x double> %ret_7, double %v_8, i32 8
  %ret_9 = insertelement <16 x double> %ret_8, double %v_9, i32 9
  %ret_10 = insertelement <16 x double> %ret_9, double %v_10, i32 10
  %ret_11 = insertelement <16 x double> %ret_10, double %v_11, i32 11
  %ret_12 = insertelement <16 x double> %ret_11, double %v_12, i32 12
  %ret_13 = insertelement <16 x double> %ret_12, double %v_13, i32 13
  %ret_14 = insertelement <16 x double> %ret_13, double %v_14, i32 14
  %ret_15 = insertelement <16 x double> %ret_14, double %v_15, i32 15

  ret <16 x double> %ret_15

not_const:
  ; store two instances of the vector into memory
  %ptr = alloca <16 x double>, i32 2
  %ptr0 = getelementptr <16 x double> , <16 x double> *
 %ptr, i32 0
  store <16 x double> %0, <16 x double> * %ptr0
  %ptr1 = getelementptr <16 x double> , <16 x double> *
 %ptr, i32 1
  store <16 x double> %0, <16 x double> * %ptr1

  ; compute offset in [0,vectorwidth-1], then index into the doubled-up vector
  %offset = and i32 %1, 15
  %ptr_as_elt_array = bitcast <16 x double> * %ptr to [32 x double] *
  %load_ptr = getelementptr [32 x double] , [32 x double] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast double * %load_ptr to <16 x double> *
  %result = load <16 x double>  , <16 x double>  *
  %load_ptr_vec, align 8
  ret <16 x double> %result
}

define <16 x double> @__shift_double(<16 x double>, i32) nounwind readnone alwaysinline {
  %ptr = alloca <16 x double>, i32 3
  %ptr0 = getelementptr <16 x double> , <16 x double> *
 %ptr, i32 0
  store <16 x double> zeroinitializer, <16 x double> * %ptr0
  %ptr1 = getelementptr <16 x double> , <16 x double> *
 %ptr, i32 1
  store <16 x double> %0, <16 x double> * %ptr1
  %ptr2 = getelementptr <16 x double> , <16 x double> *
 %ptr, i32 2
  store <16 x double> zeroinitializer, <16 x double> * %ptr2

  %offset = add i32 %1, 16
  %ptr_as_elt_array = bitcast <16 x double> * %ptr to [48 x double] *
  %load_ptr = getelementptr [48 x double] , [48 x double] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast double * %load_ptr to <16 x double> *
  %result = load <16 x double>  , <16 x double>  *
  %load_ptr_vec, align 8
  ret <16 x double> %result
}


define <16 x double> @__shuffle_double(<16 x double>, <16 x i32>) nounwind readnone alwaysinline {
  
  %index_0 = extractelement <16 x i32> %1, i32 0  
  %index_1 = extractelement <16 x i32> %1, i32 1  
  %index_2 = extractelement <16 x i32> %1, i32 2  
  %index_3 = extractelement <16 x i32> %1, i32 3  
  %index_4 = extractelement <16 x i32> %1, i32 4  
  %index_5 = extractelement <16 x i32> %1, i32 5  
  %index_6 = extractelement <16 x i32> %1, i32 6  
  %index_7 = extractelement <16 x i32> %1, i32 7  
  %index_8 = extractelement <16 x i32> %1, i32 8  
  %index_9 = extractelement <16 x i32> %1, i32 9  
  %index_10 = extractelement <16 x i32> %1, i32 10  
  %index_11 = extractelement <16 x i32> %1, i32 11  
  %index_12 = extractelement <16 x i32> %1, i32 12  
  %index_13 = extractelement <16 x i32> %1, i32 13  
  %index_14 = extractelement <16 x i32> %1, i32 14  
  %index_15 = extractelement <16 x i32> %1, i32 15
  
  %v_0 = extractelement <16 x double> %0, i32 %index_0  
  %v_1 = extractelement <16 x double> %0, i32 %index_1  
  %v_2 = extractelement <16 x double> %0, i32 %index_2  
  %v_3 = extractelement <16 x double> %0, i32 %index_3  
  %v_4 = extractelement <16 x double> %0, i32 %index_4  
  %v_5 = extractelement <16 x double> %0, i32 %index_5  
  %v_6 = extractelement <16 x double> %0, i32 %index_6  
  %v_7 = extractelement <16 x double> %0, i32 %index_7  
  %v_8 = extractelement <16 x double> %0, i32 %index_8  
  %v_9 = extractelement <16 x double> %0, i32 %index_9  
  %v_10 = extractelement <16 x double> %0, i32 %index_10  
  %v_11 = extractelement <16 x double> %0, i32 %index_11  
  %v_12 = extractelement <16 x double> %0, i32 %index_12  
  %v_13 = extractelement <16 x double> %0, i32 %index_13  
  %v_14 = extractelement <16 x double> %0, i32 %index_14  
  %v_15 = extractelement <16 x double> %0, i32 %index_15

  %ret_0 = insertelement <16 x double> undef, double %v_0, i32 0
  %ret_1 = insertelement <16 x double> %ret_0, double %v_1, i32 1
  %ret_2 = insertelement <16 x double> %ret_1, double %v_2, i32 2
  %ret_3 = insertelement <16 x double> %ret_2, double %v_3, i32 3
  %ret_4 = insertelement <16 x double> %ret_3, double %v_4, i32 4
  %ret_5 = insertelement <16 x double> %ret_4, double %v_5, i32 5
  %ret_6 = insertelement <16 x double> %ret_5, double %v_6, i32 6
  %ret_7 = insertelement <16 x double> %ret_6, double %v_7, i32 7
  %ret_8 = insertelement <16 x double> %ret_7, double %v_8, i32 8
  %ret_9 = insertelement <16 x double> %ret_8, double %v_9, i32 9
  %ret_10 = insertelement <16 x double> %ret_9, double %v_10, i32 10
  %ret_11 = insertelement <16 x double> %ret_10, double %v_11, i32 11
  %ret_12 = insertelement <16 x double> %ret_11, double %v_12, i32 12
  %ret_13 = insertelement <16 x double> %ret_12, double %v_13, i32 13
  %ret_14 = insertelement <16 x double> %ret_13, double %v_14, i32 14
  %ret_15 = insertelement <16 x double> %ret_14, double %v_15, i32 15

  ret <16 x double> %ret_15
}

define <16 x double> @__shuffle2_double(<16 x double>, <16 x double>, <16 x i32>) nounwind readnone alwaysinline {
  %v2 = shufflevector <16 x double> %0, <16 x double> %1, <32 x i32> <
      i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30,  i32 31
  >
  
  %index_0 = extractelement <16 x i32> %2, i32 0  
  %index_1 = extractelement <16 x i32> %2, i32 1  
  %index_2 = extractelement <16 x i32> %2, i32 2  
  %index_3 = extractelement <16 x i32> %2, i32 3  
  %index_4 = extractelement <16 x i32> %2, i32 4  
  %index_5 = extractelement <16 x i32> %2, i32 5  
  %index_6 = extractelement <16 x i32> %2, i32 6  
  %index_7 = extractelement <16 x i32> %2, i32 7  
  %index_8 = extractelement <16 x i32> %2, i32 8  
  %index_9 = extractelement <16 x i32> %2, i32 9  
  %index_10 = extractelement <16 x i32> %2, i32 10  
  %index_11 = extractelement <16 x i32> %2, i32 11  
  %index_12 = extractelement <16 x i32> %2, i32 12  
  %index_13 = extractelement <16 x i32> %2, i32 13  
  %index_14 = extractelement <16 x i32> %2, i32 14  
  %index_15 = extractelement <16 x i32> %2, i32 15

  %isc = call i1 @__is_compile_time_constant_varying_int32(<16 x i32> %2)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; extract from the requested lanes and insert into the result; LLVM turns
  ; this into good code in the end
  
  %v_0 = extractelement <32 x double> %v2, i32 %index_0  
  %v_1 = extractelement <32 x double> %v2, i32 %index_1  
  %v_2 = extractelement <32 x double> %v2, i32 %index_2  
  %v_3 = extractelement <32 x double> %v2, i32 %index_3  
  %v_4 = extractelement <32 x double> %v2, i32 %index_4  
  %v_5 = extractelement <32 x double> %v2, i32 %index_5  
  %v_6 = extractelement <32 x double> %v2, i32 %index_6  
  %v_7 = extractelement <32 x double> %v2, i32 %index_7  
  %v_8 = extractelement <32 x double> %v2, i32 %index_8  
  %v_9 = extractelement <32 x double> %v2, i32 %index_9  
  %v_10 = extractelement <32 x double> %v2, i32 %index_10  
  %v_11 = extractelement <32 x double> %v2, i32 %index_11  
  %v_12 = extractelement <32 x double> %v2, i32 %index_12  
  %v_13 = extractelement <32 x double> %v2, i32 %index_13  
  %v_14 = extractelement <32 x double> %v2, i32 %index_14  
  %v_15 = extractelement <32 x double> %v2, i32 %index_15

  %ret_0 = insertelement <16 x double> undef, double %v_0, i32 0
  %ret_1 = insertelement <16 x double> %ret_0, double %v_1, i32 1
  %ret_2 = insertelement <16 x double> %ret_1, double %v_2, i32 2
  %ret_3 = insertelement <16 x double> %ret_2, double %v_3, i32 3
  %ret_4 = insertelement <16 x double> %ret_3, double %v_4, i32 4
  %ret_5 = insertelement <16 x double> %ret_4, double %v_5, i32 5
  %ret_6 = insertelement <16 x double> %ret_5, double %v_6, i32 6
  %ret_7 = insertelement <16 x double> %ret_6, double %v_7, i32 7
  %ret_8 = insertelement <16 x double> %ret_7, double %v_8, i32 8
  %ret_9 = insertelement <16 x double> %ret_8, double %v_9, i32 9
  %ret_10 = insertelement <16 x double> %ret_9, double %v_10, i32 10
  %ret_11 = insertelement <16 x double> %ret_10, double %v_11, i32 11
  %ret_12 = insertelement <16 x double> %ret_11, double %v_12, i32 12
  %ret_13 = insertelement <16 x double> %ret_12, double %v_13, i32 13
  %ret_14 = insertelement <16 x double> %ret_13, double %v_14, i32 14
  %ret_15 = insertelement <16 x double> %ret_14, double %v_15, i32 15

  ret <16 x double> %ret_15

not_const:
  ; otherwise store the two vectors onto the stack and then use the given
  ; permutation vector to get indices into that array...
  %ptr = alloca <32 x double>
  store <32 x double> %v2, <32 x double> * %ptr
  %baseptr = bitcast <32 x double> * %ptr to double *

  %ptr_0 = getelementptr double , double *
 %baseptr, i32 %index_0
  %val_0 = load double  , double  *
  %ptr_0
  %result_0 = insertelement <16 x double> undef, double %val_0, i32 0

  
  %ptr_1 = getelementptr double , double *
 %baseptr, i32 %index_1
  %val_1 = load double  , double  *
  %ptr_1
  %result_1 = insertelement <16 x double> %result_0, double %val_1, i32 1
  
  %ptr_2 = getelementptr double , double *
 %baseptr, i32 %index_2
  %val_2 = load double  , double  *
  %ptr_2
  %result_2 = insertelement <16 x double> %result_1, double %val_2, i32 2
  
  %ptr_3 = getelementptr double , double *
 %baseptr, i32 %index_3
  %val_3 = load double  , double  *
  %ptr_3
  %result_3 = insertelement <16 x double> %result_2, double %val_3, i32 3
  
  %ptr_4 = getelementptr double , double *
 %baseptr, i32 %index_4
  %val_4 = load double  , double  *
  %ptr_4
  %result_4 = insertelement <16 x double> %result_3, double %val_4, i32 4
  
  %ptr_5 = getelementptr double , double *
 %baseptr, i32 %index_5
  %val_5 = load double  , double  *
  %ptr_5
  %result_5 = insertelement <16 x double> %result_4, double %val_5, i32 5
  
  %ptr_6 = getelementptr double , double *
 %baseptr, i32 %index_6
  %val_6 = load double  , double  *
  %ptr_6
  %result_6 = insertelement <16 x double> %result_5, double %val_6, i32 6
  
  %ptr_7 = getelementptr double , double *
 %baseptr, i32 %index_7
  %val_7 = load double  , double  *
  %ptr_7
  %result_7 = insertelement <16 x double> %result_6, double %val_7, i32 7
  
  %ptr_8 = getelementptr double , double *
 %baseptr, i32 %index_8
  %val_8 = load double  , double  *
  %ptr_8
  %result_8 = insertelement <16 x double> %result_7, double %val_8, i32 8
  
  %ptr_9 = getelementptr double , double *
 %baseptr, i32 %index_9
  %val_9 = load double  , double  *
  %ptr_9
  %result_9 = insertelement <16 x double> %result_8, double %val_9, i32 9
  
  %ptr_10 = getelementptr double , double *
 %baseptr, i32 %index_10
  %val_10 = load double  , double  *
  %ptr_10
  %result_10 = insertelement <16 x double> %result_9, double %val_10, i32 10
  
  %ptr_11 = getelementptr double , double *
 %baseptr, i32 %index_11
  %val_11 = load double  , double  *
  %ptr_11
  %result_11 = insertelement <16 x double> %result_10, double %val_11, i32 11
  
  %ptr_12 = getelementptr double , double *
 %baseptr, i32 %index_12
  %val_12 = load double  , double  *
  %ptr_12
  %result_12 = insertelement <16 x double> %result_11, double %val_12, i32 12
  
  %ptr_13 = getelementptr double , double *
 %baseptr, i32 %index_13
  %val_13 = load double  , double  *
  %ptr_13
  %result_13 = insertelement <16 x double> %result_12, double %val_13, i32 13
  
  %ptr_14 = getelementptr double , double *
 %baseptr, i32 %index_14
  %val_14 = load double  , double  *
  %ptr_14
  %result_14 = insertelement <16 x double> %result_13, double %val_14, i32 14
  
  %ptr_15 = getelementptr double , double *
 %baseptr, i32 %index_15
  %val_15 = load double  , double  *
  %ptr_15
  %result_15 = insertelement <16 x double> %result_14, double %val_15, i32 15


  ret <16 x double> %result_15
}


define <16 x i64> @__broadcast_i64(<16 x i64>, i32) nounwind readnone alwaysinline {
  %v = extractelement <16 x i64> %0, i32 %1
  %broadcast_init = insertelement <16 x i64> undef, i64 %v, i32 0
  %broadcast = shufflevector <16 x i64> %broadcast_init, <16 x i64> undef, <16 x i32> zeroinitializer 
  ret <16 x i64> %broadcast
}

define <16 x i64> @__rotate_i64(<16 x i64>, i32) nounwind readnone alwaysinline {
  %isc = call i1 @__is_compile_time_constant_uniform_int32(i32 %1)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; though verbose, this turms into tight code if %1 is a constant
  
  %delta_0 = add i32 %1, 0
  %delta_clamped_0 = and i32 %delta_0, 15
  %v_0 = extractelement <16 x i64> %0, i32 %delta_clamped_0  
  %delta_1 = add i32 %1, 1
  %delta_clamped_1 = and i32 %delta_1, 15
  %v_1 = extractelement <16 x i64> %0, i32 %delta_clamped_1  
  %delta_2 = add i32 %1, 2
  %delta_clamped_2 = and i32 %delta_2, 15
  %v_2 = extractelement <16 x i64> %0, i32 %delta_clamped_2  
  %delta_3 = add i32 %1, 3
  %delta_clamped_3 = and i32 %delta_3, 15
  %v_3 = extractelement <16 x i64> %0, i32 %delta_clamped_3  
  %delta_4 = add i32 %1, 4
  %delta_clamped_4 = and i32 %delta_4, 15
  %v_4 = extractelement <16 x i64> %0, i32 %delta_clamped_4  
  %delta_5 = add i32 %1, 5
  %delta_clamped_5 = and i32 %delta_5, 15
  %v_5 = extractelement <16 x i64> %0, i32 %delta_clamped_5  
  %delta_6 = add i32 %1, 6
  %delta_clamped_6 = and i32 %delta_6, 15
  %v_6 = extractelement <16 x i64> %0, i32 %delta_clamped_6  
  %delta_7 = add i32 %1, 7
  %delta_clamped_7 = and i32 %delta_7, 15
  %v_7 = extractelement <16 x i64> %0, i32 %delta_clamped_7  
  %delta_8 = add i32 %1, 8
  %delta_clamped_8 = and i32 %delta_8, 15
  %v_8 = extractelement <16 x i64> %0, i32 %delta_clamped_8  
  %delta_9 = add i32 %1, 9
  %delta_clamped_9 = and i32 %delta_9, 15
  %v_9 = extractelement <16 x i64> %0, i32 %delta_clamped_9  
  %delta_10 = add i32 %1, 10
  %delta_clamped_10 = and i32 %delta_10, 15
  %v_10 = extractelement <16 x i64> %0, i32 %delta_clamped_10  
  %delta_11 = add i32 %1, 11
  %delta_clamped_11 = and i32 %delta_11, 15
  %v_11 = extractelement <16 x i64> %0, i32 %delta_clamped_11  
  %delta_12 = add i32 %1, 12
  %delta_clamped_12 = and i32 %delta_12, 15
  %v_12 = extractelement <16 x i64> %0, i32 %delta_clamped_12  
  %delta_13 = add i32 %1, 13
  %delta_clamped_13 = and i32 %delta_13, 15
  %v_13 = extractelement <16 x i64> %0, i32 %delta_clamped_13  
  %delta_14 = add i32 %1, 14
  %delta_clamped_14 = and i32 %delta_14, 15
  %v_14 = extractelement <16 x i64> %0, i32 %delta_clamped_14  
  %delta_15 = add i32 %1, 15
  %delta_clamped_15 = and i32 %delta_15, 15
  %v_15 = extractelement <16 x i64> %0, i32 %delta_clamped_15

  %ret_0 = insertelement <16 x i64> undef, i64 %v_0, i32 0
  %ret_1 = insertelement <16 x i64> %ret_0, i64 %v_1, i32 1
  %ret_2 = insertelement <16 x i64> %ret_1, i64 %v_2, i32 2
  %ret_3 = insertelement <16 x i64> %ret_2, i64 %v_3, i32 3
  %ret_4 = insertelement <16 x i64> %ret_3, i64 %v_4, i32 4
  %ret_5 = insertelement <16 x i64> %ret_4, i64 %v_5, i32 5
  %ret_6 = insertelement <16 x i64> %ret_5, i64 %v_6, i32 6
  %ret_7 = insertelement <16 x i64> %ret_6, i64 %v_7, i32 7
  %ret_8 = insertelement <16 x i64> %ret_7, i64 %v_8, i32 8
  %ret_9 = insertelement <16 x i64> %ret_8, i64 %v_9, i32 9
  %ret_10 = insertelement <16 x i64> %ret_9, i64 %v_10, i32 10
  %ret_11 = insertelement <16 x i64> %ret_10, i64 %v_11, i32 11
  %ret_12 = insertelement <16 x i64> %ret_11, i64 %v_12, i32 12
  %ret_13 = insertelement <16 x i64> %ret_12, i64 %v_13, i32 13
  %ret_14 = insertelement <16 x i64> %ret_13, i64 %v_14, i32 14
  %ret_15 = insertelement <16 x i64> %ret_14, i64 %v_15, i32 15

  ret <16 x i64> %ret_15

not_const:
  ; store two instances of the vector into memory
  %ptr = alloca <16 x i64>, i32 2
  %ptr0 = getelementptr <16 x i64> , <16 x i64> *
 %ptr, i32 0
  store <16 x i64> %0, <16 x i64> * %ptr0
  %ptr1 = getelementptr <16 x i64> , <16 x i64> *
 %ptr, i32 1
  store <16 x i64> %0, <16 x i64> * %ptr1

  ; compute offset in [0,vectorwidth-1], then index into the doubled-up vector
  %offset = and i32 %1, 15
  %ptr_as_elt_array = bitcast <16 x i64> * %ptr to [32 x i64] *
  %load_ptr = getelementptr [32 x i64] , [32 x i64] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i64 * %load_ptr to <16 x i64> *
  %result = load <16 x i64>  , <16 x i64>  *
  %load_ptr_vec, align 8
  ret <16 x i64> %result
}

define <16 x i64> @__shift_i64(<16 x i64>, i32) nounwind readnone alwaysinline {
  %ptr = alloca <16 x i64>, i32 3
  %ptr0 = getelementptr <16 x i64> , <16 x i64> *
 %ptr, i32 0
  store <16 x i64> zeroinitializer, <16 x i64> * %ptr0
  %ptr1 = getelementptr <16 x i64> , <16 x i64> *
 %ptr, i32 1
  store <16 x i64> %0, <16 x i64> * %ptr1
  %ptr2 = getelementptr <16 x i64> , <16 x i64> *
 %ptr, i32 2
  store <16 x i64> zeroinitializer, <16 x i64> * %ptr2

  %offset = add i32 %1, 16
  %ptr_as_elt_array = bitcast <16 x i64> * %ptr to [48 x i64] *
  %load_ptr = getelementptr [48 x i64] , [48 x i64] *
 %ptr_as_elt_array, i32 0, i32 %offset
  %load_ptr_vec = bitcast i64 * %load_ptr to <16 x i64> *
  %result = load <16 x i64>  , <16 x i64>  *
  %load_ptr_vec, align 8
  ret <16 x i64> %result
}


define <16 x i64> @__shuffle_i64(<16 x i64>, <16 x i32>) nounwind readnone alwaysinline {
  
  %index_0 = extractelement <16 x i32> %1, i32 0  
  %index_1 = extractelement <16 x i32> %1, i32 1  
  %index_2 = extractelement <16 x i32> %1, i32 2  
  %index_3 = extractelement <16 x i32> %1, i32 3  
  %index_4 = extractelement <16 x i32> %1, i32 4  
  %index_5 = extractelement <16 x i32> %1, i32 5  
  %index_6 = extractelement <16 x i32> %1, i32 6  
  %index_7 = extractelement <16 x i32> %1, i32 7  
  %index_8 = extractelement <16 x i32> %1, i32 8  
  %index_9 = extractelement <16 x i32> %1, i32 9  
  %index_10 = extractelement <16 x i32> %1, i32 10  
  %index_11 = extractelement <16 x i32> %1, i32 11  
  %index_12 = extractelement <16 x i32> %1, i32 12  
  %index_13 = extractelement <16 x i32> %1, i32 13  
  %index_14 = extractelement <16 x i32> %1, i32 14  
  %index_15 = extractelement <16 x i32> %1, i32 15
  
  %v_0 = extractelement <16 x i64> %0, i32 %index_0  
  %v_1 = extractelement <16 x i64> %0, i32 %index_1  
  %v_2 = extractelement <16 x i64> %0, i32 %index_2  
  %v_3 = extractelement <16 x i64> %0, i32 %index_3  
  %v_4 = extractelement <16 x i64> %0, i32 %index_4  
  %v_5 = extractelement <16 x i64> %0, i32 %index_5  
  %v_6 = extractelement <16 x i64> %0, i32 %index_6  
  %v_7 = extractelement <16 x i64> %0, i32 %index_7  
  %v_8 = extractelement <16 x i64> %0, i32 %index_8  
  %v_9 = extractelement <16 x i64> %0, i32 %index_9  
  %v_10 = extractelement <16 x i64> %0, i32 %index_10  
  %v_11 = extractelement <16 x i64> %0, i32 %index_11  
  %v_12 = extractelement <16 x i64> %0, i32 %index_12  
  %v_13 = extractelement <16 x i64> %0, i32 %index_13  
  %v_14 = extractelement <16 x i64> %0, i32 %index_14  
  %v_15 = extractelement <16 x i64> %0, i32 %index_15

  %ret_0 = insertelement <16 x i64> undef, i64 %v_0, i32 0
  %ret_1 = insertelement <16 x i64> %ret_0, i64 %v_1, i32 1
  %ret_2 = insertelement <16 x i64> %ret_1, i64 %v_2, i32 2
  %ret_3 = insertelement <16 x i64> %ret_2, i64 %v_3, i32 3
  %ret_4 = insertelement <16 x i64> %ret_3, i64 %v_4, i32 4
  %ret_5 = insertelement <16 x i64> %ret_4, i64 %v_5, i32 5
  %ret_6 = insertelement <16 x i64> %ret_5, i64 %v_6, i32 6
  %ret_7 = insertelement <16 x i64> %ret_6, i64 %v_7, i32 7
  %ret_8 = insertelement <16 x i64> %ret_7, i64 %v_8, i32 8
  %ret_9 = insertelement <16 x i64> %ret_8, i64 %v_9, i32 9
  %ret_10 = insertelement <16 x i64> %ret_9, i64 %v_10, i32 10
  %ret_11 = insertelement <16 x i64> %ret_10, i64 %v_11, i32 11
  %ret_12 = insertelement <16 x i64> %ret_11, i64 %v_12, i32 12
  %ret_13 = insertelement <16 x i64> %ret_12, i64 %v_13, i32 13
  %ret_14 = insertelement <16 x i64> %ret_13, i64 %v_14, i32 14
  %ret_15 = insertelement <16 x i64> %ret_14, i64 %v_15, i32 15

  ret <16 x i64> %ret_15
}

define <16 x i64> @__shuffle2_i64(<16 x i64>, <16 x i64>, <16 x i32>) nounwind readnone alwaysinline {
  %v2 = shufflevector <16 x i64> %0, <16 x i64> %1, <32 x i32> <
      i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30,  i32 31
  >
  
  %index_0 = extractelement <16 x i32> %2, i32 0  
  %index_1 = extractelement <16 x i32> %2, i32 1  
  %index_2 = extractelement <16 x i32> %2, i32 2  
  %index_3 = extractelement <16 x i32> %2, i32 3  
  %index_4 = extractelement <16 x i32> %2, i32 4  
  %index_5 = extractelement <16 x i32> %2, i32 5  
  %index_6 = extractelement <16 x i32> %2, i32 6  
  %index_7 = extractelement <16 x i32> %2, i32 7  
  %index_8 = extractelement <16 x i32> %2, i32 8  
  %index_9 = extractelement <16 x i32> %2, i32 9  
  %index_10 = extractelement <16 x i32> %2, i32 10  
  %index_11 = extractelement <16 x i32> %2, i32 11  
  %index_12 = extractelement <16 x i32> %2, i32 12  
  %index_13 = extractelement <16 x i32> %2, i32 13  
  %index_14 = extractelement <16 x i32> %2, i32 14  
  %index_15 = extractelement <16 x i32> %2, i32 15

  %isc = call i1 @__is_compile_time_constant_varying_int32(<16 x i32> %2)
  br i1 %isc, label %is_const, label %not_const

is_const:
  ; extract from the requested lanes and insert into the result; LLVM turns
  ; this into good code in the end
  
  %v_0 = extractelement <32 x i64> %v2, i32 %index_0  
  %v_1 = extractelement <32 x i64> %v2, i32 %index_1  
  %v_2 = extractelement <32 x i64> %v2, i32 %index_2  
  %v_3 = extractelement <32 x i64> %v2, i32 %index_3  
  %v_4 = extractelement <32 x i64> %v2, i32 %index_4  
  %v_5 = extractelement <32 x i64> %v2, i32 %index_5  
  %v_6 = extractelement <32 x i64> %v2, i32 %index_6  
  %v_7 = extractelement <32 x i64> %v2, i32 %index_7  
  %v_8 = extractelement <32 x i64> %v2, i32 %index_8  
  %v_9 = extractelement <32 x i64> %v2, i32 %index_9  
  %v_10 = extractelement <32 x i64> %v2, i32 %index_10  
  %v_11 = extractelement <32 x i64> %v2, i32 %index_11  
  %v_12 = extractelement <32 x i64> %v2, i32 %index_12  
  %v_13 = extractelement <32 x i64> %v2, i32 %index_13  
  %v_14 = extractelement <32 x i64> %v2, i32 %index_14  
  %v_15 = extractelement <32 x i64> %v2, i32 %index_15

  %ret_0 = insertelement <16 x i64> undef, i64 %v_0, i32 0
  %ret_1 = insertelement <16 x i64> %ret_0, i64 %v_1, i32 1
  %ret_2 = insertelement <16 x i64> %ret_1, i64 %v_2, i32 2
  %ret_3 = insertelement <16 x i64> %ret_2, i64 %v_3, i32 3
  %ret_4 = insertelement <16 x i64> %ret_3, i64 %v_4, i32 4
  %ret_5 = insertelement <16 x i64> %ret_4, i64 %v_5, i32 5
  %ret_6 = insertelement <16 x i64> %ret_5, i64 %v_6, i32 6
  %ret_7 = insertelement <16 x i64> %ret_6, i64 %v_7, i32 7
  %ret_8 = insertelement <16 x i64> %ret_7, i64 %v_8, i32 8
  %ret_9 = insertelement <16 x i64> %ret_8, i64 %v_9, i32 9
  %ret_10 = insertelement <16 x i64> %ret_9, i64 %v_10, i32 10
  %ret_11 = insertelement <16 x i64> %ret_10, i64 %v_11, i32 11
  %ret_12 = insertelement <16 x i64> %ret_11, i64 %v_12, i32 12
  %ret_13 = insertelement <16 x i64> %ret_12, i64 %v_13, i32 13
  %ret_14 = insertelement <16 x i64> %ret_13, i64 %v_14, i32 14
  %ret_15 = insertelement <16 x i64> %ret_14, i64 %v_15, i32 15

  ret <16 x i64> %ret_15

not_const:
  ; otherwise store the two vectors onto the stack and then use the given
  ; permutation vector to get indices into that array...
  %ptr = alloca <32 x i64>
  store <32 x i64> %v2, <32 x i64> * %ptr
  %baseptr = bitcast <32 x i64> * %ptr to i64 *

  %ptr_0 = getelementptr i64 , i64 *
 %baseptr, i32 %index_0
  %val_0 = load i64  , i64  *
  %ptr_0
  %result_0 = insertelement <16 x i64> undef, i64 %val_0, i32 0

  
  %ptr_1 = getelementptr i64 , i64 *
 %baseptr, i32 %index_1
  %val_1 = load i64  , i64  *
  %ptr_1
  %result_1 = insertelement <16 x i64> %result_0, i64 %val_1, i32 1
  
  %ptr_2 = getelementptr i64 , i64 *
 %baseptr, i32 %index_2
  %val_2 = load i64  , i64  *
  %ptr_2
  %result_2 = insertelement <16 x i64> %result_1, i64 %val_2, i32 2
  
  %ptr_3 = getelementptr i64 , i64 *
 %baseptr, i32 %index_3
  %val_3 = load i64  , i64  *
  %ptr_3
  %result_3 = insertelement <16 x i64> %result_2, i64 %val_3, i32 3
  
  %ptr_4 = getelementptr i64 , i64 *
 %baseptr, i32 %index_4
  %val_4 = load i64  , i64  *
  %ptr_4
  %result_4 = insertelement <16 x i64> %result_3, i64 %val_4, i32 4
  
  %ptr_5 = getelementptr i64 , i64 *
 %baseptr, i32 %index_5
  %val_5 = load i64  , i64  *
  %ptr_5
  %result_5 = insertelement <16 x i64> %result_4, i64 %val_5, i32 5
  
  %ptr_6 = getelementptr i64 , i64 *
 %baseptr, i32 %index_6
  %val_6 = load i64  , i64  *
  %ptr_6
  %result_6 = insertelement <16 x i64> %result_5, i64 %val_6, i32 6
  
  %ptr_7 = getelementptr i64 , i64 *
 %baseptr, i32 %index_7
  %val_7 = load i64  , i64  *
  %ptr_7
  %result_7 = insertelement <16 x i64> %result_6, i64 %val_7, i32 7
  
  %ptr_8 = getelementptr i64 , i64 *
 %baseptr, i32 %index_8
  %val_8 = load i64  , i64  *
  %ptr_8
  %result_8 = insertelement <16 x i64> %result_7, i64 %val_8, i32 8
  
  %ptr_9 = getelementptr i64 , i64 *
 %baseptr, i32 %index_9
  %val_9 = load i64  , i64  *
  %ptr_9
  %result_9 = insertelement <16 x i64> %result_8, i64 %val_9, i32 9
  
  %ptr_10 = getelementptr i64 , i64 *
 %baseptr, i32 %index_10
  %val_10 = load i64  , i64  *
  %ptr_10
  %result_10 = insertelement <16 x i64> %result_9, i64 %val_10, i32 10
  
  %ptr_11 = getelementptr i64 , i64 *
 %baseptr, i32 %index_11
  %val_11 = load i64  , i64  *
  %ptr_11
  %result_11 = insertelement <16 x i64> %result_10, i64 %val_11, i32 11
  
  %ptr_12 = getelementptr i64 , i64 *
 %baseptr, i32 %index_12
  %val_12 = load i64  , i64  *
  %ptr_12
  %result_12 = insertelement <16 x i64> %result_11, i64 %val_12, i32 12
  
  %ptr_13 = getelementptr i64 , i64 *
 %baseptr, i32 %index_13
  %val_13 = load i64  , i64  *
  %ptr_13
  %result_13 = insertelement <16 x i64> %result_12, i64 %val_13, i32 13
  
  %ptr_14 = getelementptr i64 , i64 *
 %baseptr, i32 %index_14
  %val_14 = load i64  , i64  *
  %ptr_14
  %result_14 = insertelement <16 x i64> %result_13, i64 %val_14, i32 14
  
  %ptr_15 = getelementptr i64 , i64 *
 %baseptr, i32 %index_15
  %val_15 = load i64  , i64  *
  %ptr_15
  %result_15 = insertelement <16 x i64> %result_14, i64 %val_15, i32 15


  ret <16 x i64> %result_15
}






;; use 4-wide building blocks


define void
@__aos_to_soa4_float4(<4 x float> %v0, <4 x float> %v1, <4 x float> %v2,
        <4 x float> %v3, <4 x float> * noalias %out0,
        <4 x float> * noalias %out1, <4 x float> * noalias %out2,
        <4 x float> * noalias %out3) nounwind alwaysinline {
  %t0 = shufflevector <4 x float> %v2, <4 x float> %v3,  ; r2 r3 g2 g3
          <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %t1 = shufflevector <4 x float> %v2, <4 x float> %v3,  ; b2 b3 a2 a3
          <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  %t2 = shufflevector <4 x float> %v0, <4 x float> %v1,  ; r0 r1 g0 g1
          <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %t3 = shufflevector <4 x float> %v0, <4 x float> %v1,  ; b0 b1 a0 a1
          <4 x i32> <i32 2, i32 6, i32 3, i32 7>

  %r0 = shufflevector <4 x float> %t2, <4 x float> %t0,  ; r0 r1 r2 r3
          <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x float> %r0, <4 x float> * %out0
  %r1 = shufflevector <4 x float> %t2, <4 x float> %t0,  ; g0 g1 g2 g3
          <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  store <4 x float> %r1, <4 x float> * %out1
  %r2 = shufflevector <4 x float> %t3, <4 x float> %t1,  ; b0 b1 b2 b3
          <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x float> %r2, <4 x float> * %out2
  %r3 = shufflevector <4 x float> %t3, <4 x float> %t1,  ; a0 a1 a2 a3
          <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  store <4 x float> %r3, <4 x float> * %out3
  ret void
}


;; Do the reverse of __aos_to_soa4_float4--reorder <r0 r1 r2 r3> <g0 g1 g2 g3> ..
;; to <r0 g0 b0 a0> <r1 g1 b1 a1> ...
;; This is the exact same set of operations that __soa_to_soa4_float4 does
;; (a 4x4 transpose), so just call that...

define void
@__soa_to_aos4_float4(<4 x float> %v0, <4 x float> %v1, <4 x float> %v2,
        <4 x float> %v3, <4 x float> * noalias %out0,
        <4 x float> * noalias %out1, <4 x float> * noalias %out2,
        <4 x float> * noalias %out3) nounwind alwaysinline {
  call void @__aos_to_soa4_float4(<4 x float> %v0, <4 x float> %v1,
    <4 x float> %v2, <4 x float> %v3, <4 x float> * %out0,
    <4 x float> * %out1, <4 x float> * %out2, <4 x float> * %out3)
  ret void
}

define void
@__aos_to_soa4_double4(<4 x double> %v0, <4 x double> %v1, <4 x double> %v2,
        <4 x double> %v3, <4 x double> * noalias %out0,
        <4 x double> * noalias %out1, <4 x double> * noalias %out2,
        <4 x double> * noalias %out3) nounwind alwaysinline {
  %t0 = shufflevector <4 x double> %v2, <4 x double> %v3,  ; r2 r3 g2 g3
          <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %t1 = shufflevector <4 x double> %v2, <4 x double> %v3,  ; b2 b3 a2 a3
          <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  %t2 = shufflevector <4 x double> %v0, <4 x double> %v1,  ; r0 r1 g0 g1
          <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %t3 = shufflevector <4 x double> %v0, <4 x double> %v1,  ; b0 b1 a0 a1
          <4 x i32> <i32 2, i32 6, i32 3, i32 7>

  %r0 = shufflevector <4 x double> %t2, <4 x double> %t0,  ; r0 r1 r2 r3
          <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x double> %r0, <4 x double> * %out0
  %r1 = shufflevector <4 x double> %t2, <4 x double> %t0,  ; g0 g1 g2 g3
          <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  store <4 x double> %r1, <4 x double> * %out1
  %r2 = shufflevector <4 x double> %t3, <4 x double> %t1,  ; b0 b1 b2 b3
          <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x double> %r2, <4 x double> * %out2
  %r3 = shufflevector <4 x double> %t3, <4 x double> %t1,  ; a0 a1 a2 a3
          <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  store <4 x double> %r3, <4 x double> * %out3
  ret void
}

;; Do the reverse of __aos_to_soa4_double4--reorder <r0 r1 r2 r3> <g0 g1 g2 g3> ..
;; to <r0 g0 b0 a0> <r1 g1 b1 a1> ...
;; This is the exact same set of operations that __soa_to_soa4_double4 does
;; (a 4x4 transpose), so just call that...

define void
@__soa_to_aos4_double4(<4 x double> %v0, <4 x double> %v1, <4 x double> %v2,
        <4 x double> %v3, <4 x double> * noalias %out0,
        <4 x double> * noalias %out1, <4 x double> * noalias %out2,
        <4 x double> * noalias %out3) nounwind alwaysinline {
  call void @__aos_to_soa4_double4(<4 x double> %v0, <4 x double> %v1,
    <4 x double> %v2, <4 x double> %v3, <4 x double> * %out0,
    <4 x double> * %out1, <4 x double> * %out2, <4 x double> * %out3)
  ret void
}

;; Convert 3-wide AOS values to SOA--specifically, given 3 4-vectors
;; <x0 y0 z0 x1> <y1 z1 x2 y2> <z2 x3 y3 z3>, transpose to
;; <x0 x1 x2 x3> <y0 y1 y2 y3> <z0 z1 z2 z3>.

define void
@__aos_to_soa3_float4(<4 x float> %v0, <4 x float> %v1, <4 x float> %v2,
        <4 x float> * noalias %out0, <4 x float> * noalias %out1,
        <4 x float> * noalias %out2) nounwind alwaysinline {
  %t0 = shufflevector <4 x float> %v0, <4 x float> %v1, ; x0 x1 y0 y1
    <4 x i32> <i32 0, i32 3, i32 1, i32 4>
  %t1 = shufflevector <4 x float> %v1, <4 x float> %v2, ; x2 x3 y2 y3
    <4 x i32> <i32 2, i32 5, i32 3, i32 6>

  %r0 = shufflevector <4 x float> %t0, <4 x float> %t1, ; x0 x1 x1 x3
    <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x float> %r0, <4 x float> * %out0

  %r1 = shufflevector <4 x float> %t0, <4 x float> %t1, ; y0 y1 y2 y3
    <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  store <4 x float> %r1, <4 x float> * %out1

  %t2 = shufflevector <4 x float> %v0, <4 x float> %v1, ; z0 z1 x x
    <4 x i32> <i32 2, i32 5, i32 undef, i32 undef>

  %r2 = shufflevector <4 x float> %t2, <4 x float> %v2, ; z0 z1 z2 z3
    <4 x i32> <i32 0, i32 1, i32 4, i32 7>
  store <4 x float> %r2, <4 x float> * %out2
  ret void
}


;; The inverse of __aos_to_soa3_float4: convert 3 4-vectors
;; <x0 x1 x2 x3> <y0 y1 y2 y3> <z0 z1 z2 z3> to
;; <x0 y0 z0 x1> <y1 z1 x2 y2> <z2 x3 y3 z3>.

define void
@__soa_to_aos3_float4(<4 x float> %v0, <4 x float> %v1, <4 x float> %v2,
        <4 x float> * noalias %out0, <4 x float> * noalias %out1,
        <4 x float> * noalias %out2) nounwind alwaysinline {
  %t0 = shufflevector <4 x float> %v0, <4 x float> %v1, ; x0 x1 x2 y0
    <4 x i32> <i32 0, i32 1, i32 2, i32 4>
  %t1 = shufflevector <4 x float> %v1, <4 x float> %v2, ; y1 y2 z0 z1
    <4 x i32> <i32 1, i32 2, i32 4, i32 5>

  %r0 = shufflevector <4 x float> %t0, <4 x float> %t1, ; x0 y0 z0 x1
    <4 x i32> <i32 0, i32 3, i32 6, i32 1>
  store <4 x float> %r0, <4 x float> * %out0
  %r1 = shufflevector <4 x float> %t0, <4 x float> %t1, ; y1 z1 x2 y2
    <4 x i32> <i32 4, i32 7, i32 2, i32 5>
  store <4 x float> %r1, <4 x float> * %out1

  %t2 = shufflevector <4 x float> %v0, <4 x float> %v1, ; x3 y3 x x
    <4 x i32> <i32 3, i32 7, i32 undef, i32 undef>

  %r2 = shufflevector <4 x float> %t2, <4 x float> %v2, ; z2 x3 y3 z3
    <4 x i32> <i32 6, i32 0, i32 1, i32 7>
  store <4 x float> %r2, <4 x float> * %out2
  ret void
}

define void
@__aos_to_soa3_double4(<4 x double> %v0, <4 x double> %v1, <4 x double> %v2,
        <4 x double> * noalias %out0, <4 x double> * noalias %out1,
        <4 x double> * noalias %out2) nounwind alwaysinline {
  %t0 = shufflevector <4 x double> %v0, <4 x double> %v1, ; x0 x1 y0 y1
    <4 x i32> <i32 0, i32 3, i32 1, i32 4>
  %t1 = shufflevector <4 x double> %v1, <4 x double> %v2, ; x2 x3 y2 y3
    <4 x i32> <i32 2, i32 5, i32 3, i32 6>

  %r0 = shufflevector <4 x double> %t0, <4 x double> %t1, ; x0 x1 x1 x3
    <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x double> %r0, <4 x double> * %out0

  %r1 = shufflevector <4 x double> %t0, <4 x double> %t1, ; y0 y1 y2 y3
    <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  store <4 x double> %r1, <4 x double> * %out1

  %t2 = shufflevector <4 x double> %v0, <4 x double> %v1, ; z0 z1 x x
    <4 x i32> <i32 2, i32 5, i32 undef, i32 undef>

  %r2 = shufflevector <4 x double> %t2, <4 x double> %v2, ; z0 z1 z2 z3
    <4 x i32> <i32 0, i32 1, i32 4, i32 7>
  store <4 x double> %r2, <4 x double> * %out2
  ret void
}

define void
@__soa_to_aos3_double4(<4 x double> %v0, <4 x double> %v1, <4 x double> %v2,
        <4 x double> * noalias %out0, <4 x double> * noalias %out1,
        <4 x double> * noalias %out2) nounwind alwaysinline {
  %t0 = shufflevector <4 x double> %v0, <4 x double> %v1, ; x0 x1 x2 y0
    <4 x i32> <i32 0, i32 1, i32 2, i32 4>
  %t1 = shufflevector <4 x double> %v1, <4 x double> %v2, ; y1 y2 z0 z1
    <4 x i32> <i32 1, i32 2, i32 4, i32 5>

  %r0 = shufflevector <4 x double> %t0, <4 x double> %t1, ; x0 y0 z0 x1
    <4 x i32> <i32 0, i32 3, i32 6, i32 1>
  store <4 x double> %r0, <4 x double> * %out0
  %r1 = shufflevector <4 x double> %t0, <4 x double> %t1, ; y1 z1 x2 y2
    <4 x i32> <i32 4, i32 7, i32 2, i32 5>
  store <4 x double> %r1, <4 x double> * %out1

  %t2 = shufflevector <4 x double> %v0, <4 x double> %v1, ; x3 y3 x x
    <4 x i32> <i32 3, i32 7, i32 undef, i32 undef>

  %r2 = shufflevector <4 x double> %t2, <4 x double> %v2, ; z2 x3 y3 z3
    <4 x i32> <i32 6, i32 0, i32 1, i32 7>
  store <4 x double> %r2, <4 x double> * %out2
  ret void
}

;; Convert 2-wide AOS values to SOA--specifically, given 2 4-vectors
;; <x0 y0 x1 y1> <x2 y2 x3 y3>, transpose to
;; <x0 x1 x2 x3> <y0 y1 y2 y3>.

define void
@__aos_to_soa2_float4(<4 x float> %v0, <4 x float> %v1,
        <4 x float> * noalias %out0, <4 x float> * noalias %out1) nounwind alwaysinline {
  %t0 = shufflevector <4 x float> %v0, <4 x float> %v1, ; x0 x1 x2 x3
    <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %t1 = shufflevector <4 x float> %v0, <4 x float> %v1, ; y0 y1 y2 y3
    <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  store <4 x float> %t0, <4 x float> * %out0
  store <4 x float> %t1, <4 x float> * %out1
  ret void
}


;; The inverse of __aos_to_soa3_float4: convert 3 4-vectors
;; <x0 x1 x2 x3> <y0 y1 y2 y3>, to
;; <x0 y0 x1 y1> <x2 y2 x3 y3>.

define void
@__soa_to_aos2_float4(<4 x float> %v0, <4 x float> %v1,
        <4 x float> * noalias %out0, <4 x float> * noalias %out1) nounwind alwaysinline {
  %t0 = shufflevector <4 x float> %v0, <4 x float> %v1, ; x0 y0 x1 y1
    <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %t1 = shufflevector <4 x float> %v0, <4 x float> %v1, ; x2 y2 x3 y3
    <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  store <4 x float> %t0, <4 x float> * %out0
  store <4 x float> %t1, <4 x float> * %out1
  ret void
}

define void
@__aos_to_soa2_double4(<4 x double> %v0, <4 x double> %v1,
        <4 x double> * noalias %out0, <4 x double> * noalias %out1) nounwind alwaysinline {
  %t0 = shufflevector <4 x double> %v0, <4 x double> %v1, ; x0 x1 x2 x3
    <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %t1 = shufflevector <4 x double> %v0, <4 x double> %v1, ; y0 y1 y2 y3
    <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  store <4 x double> %t0, <4 x double> * %out0
  store <4 x double> %t1, <4 x double> * %out1
  ret void
}


;; The inverse of __aos_to_soa3_float4: convert 3 4-vectors
;; <x0 x1 x2 x3> <y0 y1 y2 y3>, to
;; <x0 y0 x1 y1> <x2 y2 x3 y3>.

define void
@__soa_to_aos2_double4(<4 x double> %v0, <4 x double> %v1,
        <4 x double> * noalias %out0, <4 x double> * noalias %out1) nounwind alwaysinline {
  %t0 = shufflevector <4 x double> %v0, <4 x double> %v1, ; x0 y0 x1 y1
    <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  %t1 = shufflevector <4 x double> %v0, <4 x double> %v1, ; x2 y2 x3 y3
    <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  store <4 x double> %t0, <4 x double> * %out0
  store <4 x double> %t1, <4 x double> * %out1
  ret void
}


define void
@__aos_to_soa4_float16(<16 x float> %v0, <16 x float> %v1, <16 x float> %v2,
        <16 x float> %v3, <16 x float> * noalias %out0,
        <16 x float> * noalias %out1, <16 x float> * noalias %out2,
        <16 x float> * noalias %out3) nounwind alwaysinline {
  %v0a = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v3a = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v3b = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v3c = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v3d = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x float> * %out0 to <4 x float> *
  %out0b = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 1
  %out0c = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 2
  %out0d = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 3
  %out1a = bitcast <16 x float> * %out1 to <4 x float> *
  %out1b = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 1
  %out1c = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 2
  %out1d = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 3
  %out2a = bitcast <16 x float> * %out2 to <4 x float> *
  %out2b = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 1
  %out2c = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 2
  %out2d = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 3
  %out3a = bitcast <16 x float> * %out3 to <4 x float> *
  %out3b = getelementptr <4 x float> , <4 x float> *
 %out3a, i32 1
  %out3c = getelementptr <4 x float> , <4 x float> *
 %out3a, i32 2
  %out3d = getelementptr <4 x float> , <4 x float> *
 %out3a, i32 3

  call void @__aos_to_soa4_float4(<4 x float> %v0a, <4 x float> %v0b,
         <4 x float> %v0c, <4 x float> %v0d, <4 x float> * %out0a,
         <4 x float> * %out1a, <4 x float> * %out2a, <4 x float> * %out3a)
  call void @__aos_to_soa4_float4(<4 x float> %v1a, <4 x float> %v1b,
         <4 x float> %v1c, <4 x float> %v1d, <4 x float> * %out0b,
         <4 x float> * %out1b, <4 x float> * %out2b, <4 x float> * %out3b)
  call void @__aos_to_soa4_float4(<4 x float> %v2a, <4 x float> %v2b,
         <4 x float> %v2c, <4 x float> %v2d, <4 x float> * %out0c,
         <4 x float> * %out1c, <4 x float> * %out2c, <4 x float> * %out3c)
  call void @__aos_to_soa4_float4(<4 x float> %v3a, <4 x float> %v3b,
         <4 x float> %v3c, <4 x float> %v3d, <4 x float> * %out0d,
         <4 x float> * %out1d, <4 x float> * %out2d, <4 x float> * %out3d)
  ret void
}


define void
@__soa_to_aos4_float16(<16 x float> %v0, <16 x float> %v1, <16 x float> %v2,
        <16 x float> %v3, <16 x float> * noalias %out0,
        <16 x float> * noalias %out1, <16 x float> * noalias %out2,
        <16 x float> * noalias %out3) nounwind alwaysinline {
  %v0a = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v3a = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v3b = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v3c = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v3d = shufflevector <16 x float> %v3, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x float> * %out0 to <4 x float> *
  %out0b = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 1
  %out0c = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 2
  %out0d = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 3
  %out1a = bitcast <16 x float> * %out1 to <4 x float> *
  %out1b = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 1
  %out1c = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 2
  %out1d = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 3
  %out2a = bitcast <16 x float> * %out2 to <4 x float> *
  %out2b = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 1
  %out2c = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 2
  %out2d = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 3
  %out3a = bitcast <16 x float> * %out3 to <4 x float> *
  %out3b = getelementptr <4 x float> , <4 x float> *
 %out3a, i32 1
  %out3c = getelementptr <4 x float> , <4 x float> *
 %out3a, i32 2
  %out3d = getelementptr <4 x float> , <4 x float> *
 %out3a, i32 3

  call void @__soa_to_aos4_float4(<4 x float> %v0a, <4 x float> %v1a,
         <4 x float> %v2a, <4 x float> %v3a, <4 x float> * %out0a,
         <4 x float> * %out0b, <4 x float> * %out0c, <4 x float> * %out0d)
  call void @__soa_to_aos4_float4(<4 x float> %v0b, <4 x float> %v1b,
         <4 x float> %v2b, <4 x float> %v3b, <4 x float> * %out1a,
         <4 x float> * %out1b, <4 x float> * %out1c, <4 x float> * %out1d)
  call void @__soa_to_aos4_float4(<4 x float> %v0c, <4 x float> %v1c,
         <4 x float> %v2c, <4 x float> %v3c, <4 x float> * %out2a,
         <4 x float> * %out2b, <4 x float> * %out2c, <4 x float> * %out2d)
  call void @__soa_to_aos4_float4(<4 x float> %v0d, <4 x float> %v1d,
         <4 x float> %v2d, <4 x float> %v3d, <4 x float> * %out3a,
         <4 x float> * %out3b, <4 x float> * %out3c, <4 x float> * %out3d)
  ret void
}


define void
@__aos_to_soa4_double16(<16 x double> %v0, <16 x double> %v1, <16 x double> %v2,
        <16 x double> %v3, <16 x double> * noalias %out0,
        <16 x double> * noalias %out1, <16 x double> * noalias %out2,
        <16 x double> * noalias %out3) nounwind alwaysinline {
  %v0a = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v3a = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v3b = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v3c = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v3d = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x double> * %out0 to <4 x double> *
  %out0b = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 1
  %out0c = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 2
  %out0d = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 3
  %out1a = bitcast <16 x double> * %out1 to <4 x double> *
  %out1b = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 1
  %out1c = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 2
  %out1d = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 3
  %out2a = bitcast <16 x double> * %out2 to <4 x double> *
  %out2b = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 1
  %out2c = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 2
  %out2d = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 3
  %out3a = bitcast <16 x double> * %out3 to <4 x double> *
  %out3b = getelementptr <4 x double> , <4 x double> *
 %out3a, i32 1
  %out3c = getelementptr <4 x double> , <4 x double> *
 %out3a, i32 2
  %out3d = getelementptr <4 x double> , <4 x double> *
 %out3a, i32 3

  call void @__aos_to_soa4_double4(<4 x double> %v0a, <4 x double> %v0b,
         <4 x double> %v0c, <4 x double> %v0d, <4 x double> * %out0a,
         <4 x double> * %out1a, <4 x double> * %out2a, <4 x double> * %out3a)
  call void @__aos_to_soa4_double4(<4 x double> %v1a, <4 x double> %v1b,
         <4 x double> %v1c, <4 x double> %v1d, <4 x double> * %out0b,
         <4 x double> * %out1b, <4 x double> * %out2b, <4 x double> * %out3b)
  call void @__aos_to_soa4_double4(<4 x double> %v2a, <4 x double> %v2b,
         <4 x double> %v2c, <4 x double> %v2d, <4 x double> * %out0c,
         <4 x double> * %out1c, <4 x double> * %out2c, <4 x double> * %out3c)
  call void @__aos_to_soa4_double4(<4 x double> %v3a, <4 x double> %v3b,
         <4 x double> %v3c, <4 x double> %v3d, <4 x double> * %out0d,
         <4 x double> * %out1d, <4 x double> * %out2d, <4 x double> * %out3d)
  ret void
}

define void
@__soa_to_aos4_double16(<16 x double> %v0, <16 x double> %v1, <16 x double> %v2,
        <16 x double> %v3, <16 x double> * noalias %out0,
        <16 x double> * noalias %out1, <16 x double> * noalias %out2,
        <16 x double> * noalias %out3) nounwind alwaysinline {
  %v0a = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v3a = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v3b = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v3c = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v3d = shufflevector <16 x double> %v3, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x double> * %out0 to <4 x double> *
  %out0b = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 1
  %out0c = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 2
  %out0d = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 3
  %out1a = bitcast <16 x double> * %out1 to <4 x double> *
  %out1b = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 1
  %out1c = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 2
  %out1d = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 3
  %out2a = bitcast <16 x double> * %out2 to <4 x double> *
  %out2b = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 1
  %out2c = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 2
  %out2d = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 3
  %out3a = bitcast <16 x double> * %out3 to <4 x double> *
  %out3b = getelementptr <4 x double> , <4 x double> *
 %out3a, i32 1
  %out3c = getelementptr <4 x double> , <4 x double> *
 %out3a, i32 2
  %out3d = getelementptr <4 x double> , <4 x double> *
 %out3a, i32 3

  call void @__soa_to_aos4_double4(<4 x double> %v0a, <4 x double> %v1a,
         <4 x double> %v2a, <4 x double> %v3a, <4 x double> * %out0a,
         <4 x double> * %out0b, <4 x double> * %out0c, <4 x double> * %out0d)
  call void @__soa_to_aos4_double4(<4 x double> %v0b, <4 x double> %v1b,
         <4 x double> %v2b, <4 x double> %v3b, <4 x double> * %out1a,
         <4 x double> * %out1b, <4 x double> * %out1c, <4 x double> * %out1d)
  call void @__soa_to_aos4_double4(<4 x double> %v0c, <4 x double> %v1c,
         <4 x double> %v2c, <4 x double> %v3c, <4 x double> * %out2a,
         <4 x double> * %out2b, <4 x double> * %out2c, <4 x double> * %out2d)
  call void @__soa_to_aos4_double4(<4 x double> %v0d, <4 x double> %v1d,
         <4 x double> %v2d, <4 x double> %v3d, <4 x double> * %out3a,
         <4 x double> * %out3b, <4 x double> * %out3c, <4 x double> * %out3d)
  ret void
}

define void
@__aos_to_soa3_float16(<16 x float> %v0, <16 x float> %v1, <16 x float> %v2,
        <16 x float> * noalias %out0, <16 x float> * noalias %out1,
        <16 x float> * noalias %out2) nounwind alwaysinline {
  %v0a = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x float> * %out0 to <4 x float> *
  %out0b = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 1
  %out0c = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 2
  %out0d = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 3
  %out1a = bitcast <16 x float> * %out1 to <4 x float> *
  %out1b = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 1
  %out1c = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 2
  %out1d = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 3
  %out2a = bitcast <16 x float> * %out2 to <4 x float> *
  %out2b = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 1
  %out2c = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 2
  %out2d = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 3

  call void @__aos_to_soa3_float4(<4 x float> %v0a, <4 x float> %v0b,
         <4 x float> %v0c, <4 x float> * %out0a, <4 x float> * %out1a,
         <4 x float> * %out2a)
  call void @__aos_to_soa3_float4(<4 x float> %v0d, <4 x float> %v1a,
         <4 x float> %v1b, <4 x float> * %out0b, <4 x float> * %out1b,
         <4 x float> * %out2b)
  call void @__aos_to_soa3_float4(<4 x float> %v1c, <4 x float> %v1d,
         <4 x float> %v2a, <4 x float> * %out0c, <4 x float> * %out1c,
         <4 x float> * %out2c)
  call void @__aos_to_soa3_float4(<4 x float> %v2b, <4 x float> %v2c,
         <4 x float> %v2d, <4 x float> * %out0d, <4 x float> * %out1d,
         <4 x float> * %out2d)
  ret void
}


define void
@__soa_to_aos3_float16(<16 x float> %v0, <16 x float> %v1, <16 x float> %v2,
        <16 x float> * noalias %out0, <16 x float> * noalias %out1,
        <16 x float> * noalias %out2) nounwind alwaysinline {
  %v0a = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x float> %v0, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x float> %v1, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x float> %v2, <16 x float> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x float> * %out0 to <4 x float> *
  %out0b = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 1
  %out0c = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 2
  %out0d = getelementptr <4 x float> , <4 x float> *
 %out0a, i32 3
  %out1a = bitcast <16 x float> * %out1 to <4 x float> *
  %out1b = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 1
  %out1c = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 2
  %out1d = getelementptr <4 x float> , <4 x float> *
 %out1a, i32 3
  %out2a = bitcast <16 x float> * %out2 to <4 x float> *
  %out2b = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 1
  %out2c = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 2
  %out2d = getelementptr <4 x float> , <4 x float> *
 %out2a, i32 3

  call void @__soa_to_aos3_float4(<4 x float> %v0a, <4 x float> %v1a,
         <4 x float> %v2a, <4 x float> * %out0a, <4 x float> * %out0b,
         <4 x float> * %out0c)
  call void @__soa_to_aos3_float4(<4 x float> %v0b, <4 x float> %v1b,
         <4 x float> %v2b, <4 x float> * %out0d, <4 x float> * %out1a,
         <4 x float> * %out1b)
  call void @__soa_to_aos3_float4(<4 x float> %v0c, <4 x float> %v1c,
         <4 x float> %v2c, <4 x float> * %out1c, <4 x float> * %out1d,
         <4 x float> * %out2a)
  call void @__soa_to_aos3_float4(<4 x float> %v0d, <4 x float> %v1d,
         <4 x float> %v2d, <4 x float> * %out2b, <4 x float> * %out2c,
         <4 x float> * %out2d)
  ret void
}


define void
@__aos_to_soa3_double16(<16 x double> %v0, <16 x double> %v1, <16 x double> %v2,
        <16 x double> * noalias %out0, <16 x double> * noalias %out1,
        <16 x double> * noalias %out2) nounwind alwaysinline {
  %v0a = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x double> * %out0 to <4 x double> *
  %out0b = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 1
  %out0c = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 2
  %out0d = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 3
  %out1a = bitcast <16 x double> * %out1 to <4 x double> *
  %out1b = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 1
  %out1c = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 2
  %out1d = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 3
  %out2a = bitcast <16 x double> * %out2 to <4 x double> *
  %out2b = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 1
  %out2c = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 2
  %out2d = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 3

  call void @__aos_to_soa3_double4(<4 x double> %v0a, <4 x double> %v0b,
         <4 x double> %v0c, <4 x double> * %out0a, <4 x double> * %out1a,
         <4 x double> * %out2a)
  call void @__aos_to_soa3_double4(<4 x double> %v0d, <4 x double> %v1a,
         <4 x double> %v1b, <4 x double> * %out0b, <4 x double> * %out1b,
         <4 x double> * %out2b)
  call void @__aos_to_soa3_double4(<4 x double> %v1c, <4 x double> %v1d,
         <4 x double> %v2a, <4 x double> * %out0c, <4 x double> * %out1c,
         <4 x double> * %out2c)
  call void @__aos_to_soa3_double4(<4 x double> %v2b, <4 x double> %v2c,
         <4 x double> %v2d, <4 x double> * %out0d, <4 x double> * %out1d,
         <4 x double> * %out2d)
  ret void
}


define void
@__soa_to_aos3_double16(<16 x double> %v0, <16 x double> %v1, <16 x double> %v2,
        <16 x double> * noalias %out0, <16 x double> * noalias %out1,
        <16 x double> * noalias %out2) nounwind alwaysinline {
  %v0a = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v0b = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v0c = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v0d = shufflevector <16 x double> %v0, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v1a = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v1b = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v1c = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v1d = shufflevector <16 x double> %v1, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %v2a = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v2b = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %v2c = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %v2d = shufflevector <16 x double> %v2, <16 x double> undef,
         <4 x i32> <i32 12, i32 13, i32 14, i32 15>

  %out0a = bitcast <16 x double> * %out0 to <4 x double> *
  %out0b = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 1
  %out0c = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 2
  %out0d = getelementptr <4 x double> , <4 x double> *
 %out0a, i32 3
  %out1a = bitcast <16 x double> * %out1 to <4 x double> *
  %out1b = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 1
  %out1c = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 2
  %out1d = getelementptr <4 x double> , <4 x double> *
 %out1a, i32 3
  %out2a = bitcast <16 x double> * %out2 to <4 x double> *
  %out2b = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 1
  %out2c = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 2
  %out2d = getelementptr <4 x double> , <4 x double> *
 %out2a, i32 3

  call void @__soa_to_aos3_double4(<4 x double> %v0a, <4 x double> %v1a,
         <4 x double> %v2a, <4 x double> * %out0a, <4 x double> * %out0b,
         <4 x double> * %out0c)
  call void @__soa_to_aos3_double4(<4 x double> %v0b, <4 x double> %v1b,
         <4 x double> %v2b, <4 x double> * %out0d, <4 x double> * %out1a,
         <4 x double> * %out1b)
  call void @__soa_to_aos3_double4(<4 x double> %v0c, <4 x double> %v1c,
         <4 x double> %v2c, <4 x double> * %out1c, <4 x double> * %out1d,
         <4 x double> * %out2a)
  call void @__soa_to_aos3_double4(<4 x double> %v0d, <4 x double> %v1d,
         <4 x double> %v2d, <4 x double> * %out2b, <4 x double> * %out2c,
         <4 x double> * %out2d)
  ret void
}

;; reorder
;; v0 = <a0 b0 ...    a7 b7>
;; v1 = <a8 b8 ...  a15 b15>
;; to
;; out0 = <a0 ... a15>
;; out1 = <b0 ... b15>

define void
@__aos_to_soa2_float16(<16 x float> %v0, <16 x float> %v1,
        <16 x float> * noalias %out0, <16 x float> * noalias %out1) nounwind alwaysinline {
  ;; t0 = <a0 ... a15>
  %t0 = shufflevector <16 x float> %v0, <16 x float> %v1,
          <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  ;; t1 = <b0 ... b31>
  %t1 = shufflevector <16 x float> %v0, <16 x float> %v1,
          <16 x i32>  <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  store <16 x float> %t0, <16 x float> * %out0
  store <16 x float> %t1, <16 x float> * %out1
  ret void
}

;; reorder
;; v0 = <a0 ... a15>
;; v1 = <b0 ... b15>
;; to
;; out0 = <a0 b0 ... a7 b7>
;; out1 = <a8 b8 ... a15 b15>

define void
@__soa_to_aos2_float16(<16 x float> %v0, <16 x float> %v1,
        <16 x float> * noalias %out0, <16 x float> * noalias %out1) nounwind alwaysinline {
  %t0 = shufflevector <16 x float> %v0, <16 x float> %v1,
          <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  %t1 = shufflevector <16 x float> %v0, <16 x float> %v1,
          <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
  store <16 x float> %t0, <16 x float> * %out0
  store <16 x float> %t1, <16 x float> * %out1
  ret void
}


;; reorder
;; v0 = <a0 b0 ...    a7 b7>
;; v1 = <a8 b8 ...  a15 b15>
;; to
;; out0 = <a0 ... a15>
;; out1 = <b0 ... b15>

define void
@__aos_to_soa2_double16(<16 x double> %v0, <16 x double> %v1,
        <16 x double> * noalias %out0, <16 x double> * noalias %out1) nounwind alwaysinline {
  ;; t0 = <a0 ... a15>
  %t0 = shufflevector <16 x double> %v0, <16 x double> %v1,
          <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  ;; t1 = <b0 ... b31>
  %t1 = shufflevector <16 x double> %v0, <16 x double> %v1,
          <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  store <16 x double> %t0, <16 x double> * %out0
  store <16 x double> %t1, <16 x double> * %out1
  ret void
}

;; reorder
;; v0 = <a0 ... a15>
;; v1 = <b0 ... b15>
;; to
;; out0 = <a0 b0 ... a7 b7>
;; out1 = <a8 b8 ... a15 b15>

define void
@__soa_to_aos2_double16(<16 x double> %v0, <16 x double> %v1,
        <16 x double> * noalias %out0, <16 x double> * noalias %out1) nounwind alwaysinline {
  %t0 = shufflevector <16 x double> %v0, <16 x double> %v1,
          <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  %t1 = shufflevector <16 x double> %v0, <16 x double> %v1,
          <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
  store <16 x double> %t0, <16 x double> * %out0
  store <16 x double> %t1, <16 x double> * %out1
  ret void
}
 

define void
@__aos_to_soa4_float(float * noalias %p,
        <16 x float> * noalias %out0, <16 x float> * noalias %out1,
        <16 x float> * noalias %out2, <16 x float> * noalias %out3)
        nounwind alwaysinline {
  %p0 = bitcast float * %p to <16 x float> *
  %v0 = load <16 x float>  , <16 x float>  *
  %p0, align 4
  %p1 = getelementptr <16 x float> , <16 x float> *
 %p0, i32 1
  %v1 = load <16 x float>  , <16 x float>  *
  %p1, align 4
  %p2 = getelementptr <16 x float> , <16 x float> *
 %p0, i32 2
  %v2 = load <16 x float>  , <16 x float>  *
  %p2, align 4
  %p3 = getelementptr <16 x float> , <16 x float> *
 %p0, i32 3
  %v3 = load <16 x float>  , <16 x float>  *
  %p3, align 4
  call void @__aos_to_soa4_float16 (<16 x float> %v0, <16 x float> %v1,
         <16 x float> %v2, <16 x float> %v3, <16 x float> * %out0,
         <16 x float> * %out1, <16 x float> * %out2, <16 x float> * %out3)
  ret void
}

define void
@__soa_to_aos4_float(<16 x float> %v0, <16 x float> %v1, <16 x float> %v2,
             <16 x float> %v3, float * noalias %p) nounwind alwaysinline {
  %out0 = bitcast float * %p to <16 x float> *
  %out1 = getelementptr <16 x float> , <16 x float> *
 %out0, i32 1
  %out2 = getelementptr <16 x float> , <16 x float> *
 %out0, i32 2
  %out3 = getelementptr <16 x float> , <16 x float> *
 %out0, i32 3
  call void @__soa_to_aos4_float16 (<16 x float> %v0, <16 x float> %v1,
         <16 x float> %v2, <16 x float> %v3, <16 x float> * %out0,
         <16 x float> * %out1, <16 x float> * %out2, <16 x float> * %out3)
  ret void
}

define void
@__aos_to_soa4_double(double * noalias %p,
        <16 x double> * noalias %out0, <16 x double> * noalias %out1,
        <16 x double> * noalias %out2, <16 x double> * noalias %out3)
        nounwind alwaysinline {
  %p0 = bitcast double * %p to <16 x double> *
  %v0 = load <16 x double>  , <16 x double>  *
  %p0, align 4
  %p1 = getelementptr <16 x double> , <16 x double> *
 %p0, i32 1
  %v1 = load <16 x double>  , <16 x double>  *
  %p1, align 4
  %p2 = getelementptr <16 x double> , <16 x double> *
 %p0, i32 2
  %v2 = load <16 x double>  , <16 x double>  *
  %p2, align 4
  %p3 = getelementptr <16 x double> , <16 x double> *
 %p0, i32 3
  %v3 = load <16 x double>  , <16 x double>  *
  %p3, align 4
  call void @__aos_to_soa4_double16 (<16 x double> %v0, <16 x double> %v1,
         <16 x double> %v2, <16 x double> %v3, <16 x double> * %out0,
         <16 x double> * %out1, <16 x double> * %out2, <16 x double> * %out3)
  ret void
}

define void
@__soa_to_aos4_double(<16 x double> %v0, <16 x double> %v1, <16 x double> %v2,
             <16 x double> %v3, double * noalias %p) nounwind alwaysinline {
  %out0 = bitcast double * %p to <16 x double> *
  %out1 = getelementptr <16 x double> , <16 x double> *
 %out0, i32 1
  %out2 = getelementptr <16 x double> , <16 x double> *
 %out0, i32 2
  %out3 = getelementptr <16 x double> , <16 x double> *
 %out0, i32 3
  call void @__soa_to_aos4_double16 (<16 x double> %v0, <16 x double> %v1,
         <16 x double> %v2, <16 x double> %v3, <16 x double> * %out0,
         <16 x double> * %out1, <16 x double> * %out2, <16 x double> * %out3)
  ret void
}

define void
@__aos_to_soa3_float(float * noalias %p,
        <16 x float> * %out0, <16 x float> * %out1,
        <16 x float> * %out2) nounwind alwaysinline {
  %p0 = bitcast float * %p to <16 x float> *
  %v0 = load <16 x float>  , <16 x float>  *
  %p0, align 4
  %p1 = getelementptr <16 x float> , <16 x float> *
 %p0, i32 1
  %v1 = load <16 x float>  , <16 x float>  *
  %p1, align 4
  %p2 = getelementptr <16 x float> , <16 x float> *
 %p0, i32 2
  %v2 = load <16 x float>  , <16 x float>  *
  %p2, align 4
  call void @__aos_to_soa3_float16 (<16 x float> %v0, <16 x float> %v1,
         <16 x float> %v2, <16 x float> * %out0, <16 x float> * %out1,
         <16 x float> * %out2)
  ret void
}

define void
@__soa_to_aos3_float(<16 x float> %v0, <16 x float> %v1, <16 x float> %v2,
                     float * noalias %p) nounwind alwaysinline {
  %out0 = bitcast float * %p to <16 x float> *
  %out1 = getelementptr <16 x float> , <16 x float> *
 %out0, i32 1
  %out2 = getelementptr <16 x float> , <16 x float> *
 %out0, i32 2
  call void @__soa_to_aos3_float16 (<16 x float> %v0, <16 x float> %v1,
         <16 x float> %v2, <16 x float> * %out0, <16 x float> * %out1,
         <16 x float> * %out2)
  ret void
}

define void
@__aos_to_soa3_double(double * noalias %p,
        <16 x double> * %out0, <16 x double> * %out1,
        <16 x double> * %out2) nounwind alwaysinline {
  %p0 = bitcast double * %p to <16 x double> *
  %v0 = load <16 x double>  , <16 x double>  *
  %p0, align 4
  %p1 = getelementptr <16 x double> , <16 x double> *
 %p0, i32 1
  %v1 = load <16 x double>  , <16 x double>  *
  %p1, align 4
  %p2 = getelementptr <16 x double> , <16 x double> *
 %p0, i32 2
  %v2 = load <16 x double>  , <16 x double>  *
  %p2, align 4
  call void @__aos_to_soa3_double16 (<16 x double> %v0, <16 x double> %v1,
         <16 x double> %v2, <16 x double> * %out0, <16 x double> * %out1,
         <16 x double> * %out2)
  ret void
}

define void
@__soa_to_aos3_double(<16 x double> %v0, <16 x double> %v1, <16 x double> %v2,
                     double * noalias %p) nounwind alwaysinline {
  %out0 = bitcast double * %p to <16 x double> *
  %out1 = getelementptr <16 x double> , <16 x double> *
 %out0, i32 1
  %out2 = getelementptr <16 x double> , <16 x double> *
 %out0, i32 2
  call void @__soa_to_aos3_double16 (<16 x double> %v0, <16 x double> %v1,
         <16 x double> %v2, <16 x double> * %out0, <16 x double> * %out1,
         <16 x double> * %out2)
  ret void
}


define void
@__aos_to_soa2_float(float * noalias %p,
        <16 x float> * %out0, <16 x float> * %out1) nounwind alwaysinline {
  %p0 = bitcast float * %p to <16 x float> *
  %v0 = load <16 x float>  , <16 x float>  *
  %p0, align 4
  %p1 = getelementptr <16 x float> , <16 x float> *
 %p0, i32 1
  %v1 = load <16 x float>  , <16 x float>  *
  %p1, align 4
  call void @__aos_to_soa2_float16 (<16 x float> %v0, <16 x float> %v1,
         <16 x float> * %out0, <16 x float> * %out1)
  ret void
}

define void
@__soa_to_aos2_float(<16 x float> %v0, <16 x float> %v1,
                     float * noalias %p) nounwind alwaysinline {
  %out0 = bitcast float * %p to <16 x float> *
  %out1 = getelementptr <16 x float> , <16 x float> *
 %out0, i32 1
  call void @__soa_to_aos2_float16 (<16 x float> %v0, <16 x float> %v1,
         <16 x float> * %out0, <16 x float> * %out1)
  ret void
}

define void
@__aos_to_soa2_double(double * noalias %p,
        <16 x double> * %out0, <16 x double> * %out1) nounwind alwaysinline {
  %p0 = bitcast double * %p to <16 x double> *
  %v0 = load <16 x double>  , <16 x double>  *
  %p0, align 4
  %p1 = getelementptr <16 x double> , <16 x double> *
 %p0, i32 1
  %v1 = load <16 x double>  , <16 x double>  *
  %p1, align 4
  call void @__aos_to_soa2_double16 (<16 x double> %v0, <16 x double> %v1,
         <16 x double> * %out0, <16 x double> * %out1)
  ret void
}

define void
@__soa_to_aos2_double(<16 x double> %v0, <16 x double> %v1,
                     double * noalias %p) nounwind alwaysinline {
  %out0 = bitcast double * %p to <16 x double> *
  %out1 = getelementptr <16 x double> , <16 x double> *
 %out0, i32 1
  call void @__soa_to_aos2_double16 (<16 x double> %v0, <16 x double> %v1,
         <16 x double> * %out0, <16 x double> * %out1)
  ret void
}


declare i1 @__rdrand_i16(i16 * nocapture)
declare i1 @__rdrand_i32(i32 * nocapture)
declare i1 @__rdrand_i64(i64 * nocapture)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding floats

declare <4 x float> @llvm.x86.sse41.round.ss(<4 x float>, <4 x float>, i32) nounwind readnone

define float @__round_uniform_float(float) nounwind readonly alwaysinline {
  ; roundss, round mode nearest 0b00 | don't signal precision exceptions 0b1000 = 8
  ; the roundss intrinsic is a total mess--docs say:
  ;
  ;  __m128 _mm_round_ss (__m128 a, __m128 b, const int c)
  ;       
  ;  b is a 128-bit parameter. The lowest 32 bits are the result of the rounding function
  ;  on b0. The higher order 96 bits are copied directly from input parameter a. The
  ;  return value is described by the following equations:
  ;
  ;  r0 = RND(b0)
  ;  r1 = a1
  ;  r2 = a2
  ;  r3 = a3
  ;
  ;  It doesn't matter what we pass as a, since we only need the r0 value
  ;  here.  So we pass the same register for both.  Further, only the 0th
  ;  element of the b parameter matters
  %xi = insertelement <4 x float> undef, float %0, i32 0
  %xr = call <4 x float> @llvm.x86.sse41.round.ss(<4 x float> %xi, <4 x float> %xi, i32 8)
  %rs = extractelement <4 x float> %xr, i32 0
  ret float %rs
}

define float @__floor_uniform_float(float) nounwind readonly alwaysinline {
  ; see above for round_ss instrinsic discussion...
  %xi = insertelement <4 x float> undef, float %0, i32 0
  ; roundps, round down 0b01 | don't signal precision exceptions 0b1001 = 9
  %xr = call <4 x float> @llvm.x86.sse41.round.ss(<4 x float> %xi, <4 x float> %xi, i32 9)
  %rs = extractelement <4 x float> %xr, i32 0
  ret float %rs
}

define float @__ceil_uniform_float(float) nounwind readonly alwaysinline {
  ; see above for round_ss instrinsic discussion...
  %xi = insertelement <4 x float> undef, float %0, i32 0
  ; roundps, round up 0b10 | don't signal precision exceptions 0b1010 = 10
  %xr = call <4 x float> @llvm.x86.sse41.round.ss(<4 x float> %xi, <4 x float> %xi, i32 10)
  %rs = extractelement <4 x float> %xr, i32 0
  ret float %rs
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding doubles

declare <2 x double> @llvm.x86.sse41.round.sd(<2 x double>, <2 x double>, i32) nounwind readnone

define double @__round_uniform_double(double) nounwind readonly alwaysinline {
  %xi = insertelement <2 x double> undef, double %0, i32 0
  %xr = call <2 x double> @llvm.x86.sse41.round.sd(<2 x double> %xi, <2 x double> %xi, i32 8)
  %rs = extractelement <2 x double> %xr, i32 0
  ret double %rs
}

define double @__floor_uniform_double(double) nounwind readonly alwaysinline {
  ; see above for round_ss instrinsic discussion...
  %xi = insertelement <2 x double> undef, double %0, i32 0
  ; roundsd, round down 0b01 | don't signal precision exceptions 0b1001 = 9
  %xr = call <2 x double> @llvm.x86.sse41.round.sd(<2 x double> %xi, <2 x double> %xi, i32 9)
  %rs = extractelement <2 x double> %xr, i32 0
  ret double %rs
}

define double @__ceil_uniform_double(double) nounwind readonly alwaysinline {
  ; see above for round_ss instrinsic discussion...
  %xi = insertelement <2 x double> undef, double %0, i32 0
  ; roundsd, round up 0b10 | don't signal precision exceptions 0b1010 = 10
  %xr = call <2 x double> @llvm.x86.sse41.round.sd(<2 x double> %xi, <2 x double> %xi, i32 10)
  %rs = extractelement <2 x double> %xr, i32 0
  ret double %rs
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rcp

declare <4 x float> @llvm.x86.sse.rcp.ss(<4 x float>) nounwind readnone

define float @__rcp_uniform_float(float) nounwind readonly alwaysinline {
  ; do the rcpss call
  ;    uniform float iv = extract(__rcp_u(v), 0);
  ;    return iv * (2. - v * iv);
  %vecval = insertelement <4 x float> undef, float %0, i32 0
  %call = call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> %vecval)
  %scall = extractelement <4 x float> %call, i32 0

  ; do one N-R iteration to improve precision, as above
  %v_iv = fmul float %0, %scall
  %two_minus = fsub float 2., %v_iv  
  %iv_mul = fmul float %scall, %two_minus
  ret float %iv_mul
}

define float @__rcp_fast_uniform_float(float) nounwind readonly alwaysinline {
  ; do the rcpss call
  ;    uniform float iv = extract(__rcp_u(v), 0);
  ;    return iv;
  %vecval = insertelement <4 x float> undef, float %0, i32 0
  %call = call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> %vecval)
  %scall = extractelement <4 x float> %call, i32 0
  ret float %scall
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rsqrt

declare <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float>) nounwind readnone

define float @__rsqrt_uniform_float(float) nounwind readonly alwaysinline {
  ;  uniform float is = extract(__rsqrt_u(v), 0);
  %v = insertelement <4 x float> undef, float %0, i32 0
  %vis = call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> %v)
  %is = extractelement <4 x float> %vis, i32 0

  ; Newton-Raphson iteration to improve precision
  ;  return 0.5 * is * (3. - (v * is) * is);
  %v_is = fmul float %0, %is
  %v_is_is = fmul float %v_is, %is
  %three_sub = fsub float 3., %v_is_is
  %is_mul = fmul float %is, %three_sub
  %half_scale = fmul float 0.5, %is_mul
  ret float %half_scale
}

define float @__rsqrt_fast_uniform_float(float) nounwind readonly alwaysinline {
  ;  uniform float is = extract(__rsqrt_u(v), 0);
  %v = insertelement <4 x float> undef, float %0, i32 0
  %vis = call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> %v)
  %is = extractelement <4 x float> %vis, i32 0
  ret float %is
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sqrt

declare <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float>) nounwind readnone

define float @__sqrt_uniform_float(float) nounwind readonly alwaysinline {
  
  %ret_vec = insertelement <4 x float> undef, float %0, i32 0
  %ret_val = call <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float> %ret_vec)
  %ret = extractelement <4 x float> %ret_val, i32 0

  ret float %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; double precision sqrt

declare <2 x double> @llvm.x86.sse2.sqrt.sd(<2 x double>) nounwind readnone

define double @__sqrt_uniform_double(double) nounwind alwaysinline {
  
  %ret_vec = insertelement <2 x double> undef, double %0, i32 0
  %ret_val = call <2 x double> @llvm.x86.sse2.sqrt.sd(<2 x double> %ret_vec)
  %ret = extractelement <2 x double> %ret_val, i32 0

  ret double %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fast math mode

declare void @llvm.x86.sse.stmxcsr(i8 *) nounwind
declare void @llvm.x86.sse.ldmxcsr(i8 *) nounwind

define void @__fastmath() nounwind alwaysinline {
  %ptr = alloca i32
  %ptr8 = bitcast i32 * %ptr to i8 *
  call void @llvm.x86.sse.stmxcsr(i8 * %ptr8)
  %oldval = load i32  , i32  *
 %ptr

  ; turn on DAZ (64)/FTZ (32768) -> 32832
  %update = or i32 %oldval, 32832
  store i32 %update, i32 *%ptr
  call void @llvm.x86.sse.ldmxcsr(i8 * %ptr8)
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; float min/max

declare <4 x float> @llvm.x86.sse.max.ss(<4 x float>, <4 x float>) nounwind readnone
declare <4 x float> @llvm.x86.sse.min.ss(<4 x float>, <4 x float>) nounwind readnone

define float @__max_uniform_float(float, float) nounwind readonly alwaysinline {
  
  %ret_veca = insertelement <4 x float> undef, float %0, i32 0
  %ret_vecb = insertelement <4 x float> undef, float %1, i32 0
  %ret_val = call <4 x float> @llvm.x86.sse.max.ss(<4 x float> %ret_veca, <4 x float> %ret_vecb)
  %ret = extractelement <4 x float> %ret_val, i32 0

  ret float %ret
}

define float @__min_uniform_float(float, float) nounwind readonly alwaysinline {
  
  %ret_veca = insertelement <4 x float> undef, float %0, i32 0
  %ret_vecb = insertelement <4 x float> undef, float %1, i32 0
  %ret_val = call <4 x float> @llvm.x86.sse.min.ss(<4 x float> %ret_veca, <4 x float> %ret_vecb)
  %ret = extractelement <4 x float> %ret_val, i32 0

  ret float %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; double precision min/max

declare <2 x double> @llvm.x86.sse2.max.sd(<2 x double>, <2 x double>) nounwind readnone
declare <2 x double> @llvm.x86.sse2.min.sd(<2 x double>, <2 x double>) nounwind readnone

define double @__min_uniform_double(double, double) nounwind readnone alwaysinline {
  
  %ret_veca = insertelement <2 x double> undef, double %0, i32 0
  %ret_vecb = insertelement <2 x double> undef, double %1, i32 0
  %ret_val = call <2 x double> @llvm.x86.sse2.min.sd(<2 x double> %ret_veca, <2 x double> %ret_vecb)
  %ret = extractelement <2 x double> %ret_val, i32 0

  ret double %ret
}

define double @__max_uniform_double(double, double) nounwind readnone alwaysinline {
  
  %ret_veca = insertelement <2 x double> undef, double %0, i32 0
  %ret_vecb = insertelement <2 x double> undef, double %1, i32 0
  %ret_val = call <2 x double> @llvm.x86.sse2.max.sd(<2 x double> %ret_veca, <2 x double> %ret_vecb)
  %ret = extractelement <2 x double> %ret_val, i32 0

  ret double %ret
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; int min/max

declare <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32>, <4 x i32>) nounwind readnone
declare <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32>, <4 x i32>) nounwind readnone

define i32 @__min_uniform_int32(i32, i32) nounwind readonly alwaysinline {
  
  %ret_veca = insertelement <4 x i32> undef, i32 %0, i32 0
  %ret_vecb = insertelement <4 x i32> undef, i32 %1, i32 0
  %ret_val = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %ret_veca, <4 x i32> %ret_vecb)
  %ret = extractelement <4 x i32> %ret_val, i32 0

  ret i32 %ret
}

define i32 @__max_uniform_int32(i32, i32) nounwind readonly alwaysinline {
  
  %ret_veca = insertelement <4 x i32> undef, i32 %0, i32 0
  %ret_vecb = insertelement <4 x i32> undef, i32 %1, i32 0
  %ret_val = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %ret_veca, <4 x i32> %ret_vecb)
  %ret = extractelement <4 x i32> %ret_val, i32 0

  ret i32 %ret
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unsigned int min/max

declare <4 x i32> @llvm.x86.sse41.pminud(<4 x i32>, <4 x i32>) nounwind readnone
declare <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32>, <4 x i32>) nounwind readnone

define i32 @__min_uniform_uint32(i32, i32) nounwind readonly alwaysinline {
  
  %ret_veca = insertelement <4 x i32> undef, i32 %0, i32 0
  %ret_vecb = insertelement <4 x i32> undef, i32 %1, i32 0
  %ret_val = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %ret_veca, <4 x i32> %ret_vecb)
  %ret = extractelement <4 x i32> %ret_val, i32 0

  ret i32 %ret
}

define i32 @__max_uniform_uint32(i32, i32) nounwind readonly alwaysinline {
  
  %ret_veca = insertelement <4 x i32> undef, i32 %0, i32 0
  %ret_vecb = insertelement <4 x i32> undef, i32 %1, i32 0
  %ret_val = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %ret_veca, <4 x i32> %ret_vecb)
  %ret = extractelement <4 x i32> %ret_val, i32 0

  ret i32 %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; switch macro
;; This is required to ensure that gather intrinsics are used with constant scale value.
;; This particular implementation of the routine is used by non-avx512 targets currently(avx2-i64x4, avx2-i32x8, avx2-i32x16).
;; $1: Return value
;; $2: funcName
;; $3: Width
;; $4: scalar type of array
;; $5: ptr
;; $6: offset
;; $7: scalar type of offset
;; $8: vecMask
;; $9: scalar type of vecMask
;; $10: scale
;; $11: scale type




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; half conversion routines

declare float @__half_to_float_uniform(i16 %v) nounwind readnone
declare <16 x float> @__half_to_float_varying(<16 x i16> %v) nounwind readnone
declare i16 @__float_to_half_uniform(float %v) nounwind readnone
declare <16 x i16> @__float_to_half_varying(<16 x float> %v) nounwind readnone

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rcp

declare <4 x float> @llvm.x86.sse.rcp.ps(<4 x float>) nounwind readnone

define <16 x float> @__rcp_varying_float(<16 x float>) nounwind readonly alwaysinline {
  
  %__call_0 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %__vcall_0 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__call_0)
  %__call_1 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %__vcall_1 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__call_1)
  %__call_2 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %__vcall_2 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__call_2)
  %__call_3 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %__vcall_3 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__call_3)

  %__calla = shufflevector <4 x float> %__vcall_0, <4 x float> %__vcall_1, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %__callb = shufflevector <4 x float> %__vcall_2, <4 x float> %__vcall_3, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %call = shufflevector <8 x float> %__calla, <8 x float> %__callb,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ; do one N-R iteration to improve precision
  ;  float iv = __rcp_v(v);
  ;  return iv * (2. - v * iv);
  %v_iv = fmul <16 x float> %0, %call
  %two_minus = fsub <16 x float> <float 2., float 2., float 2., float 2.,
                                  float 2., float 2., float 2., float 2.,
                                  float 2., float 2., float 2., float 2.,
                                  float 2., float 2., float 2., float 2.>, %v_iv  
  %iv_mul = fmul <16 x float> %call, %two_minus
  ret <16 x float> %iv_mul
}

define <16 x float> @__rcp_fast_varying_float(<16 x float>) nounwind readonly alwaysinline {
  
  %__ret_0 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %__vret_0 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__ret_0)
  %__ret_1 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %__vret_1 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__ret_1)
  %__ret_2 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %__vret_2 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__ret_2)
  %__ret_3 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %__vret_3 = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %__ret_3)

  %__reta = shufflevector <4 x float> %__vret_0, <4 x float> %__vret_1, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %__retb = shufflevector <4 x float> %__vret_2, <4 x float> %__vret_3, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %ret = shufflevector <8 x float> %__reta, <8 x float> %__retb,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x float> %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rsqrt

declare <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float>) nounwind readnone

define <16 x float> @__rsqrt_varying_float(<16 x float> %v) nounwind readonly alwaysinline {
  ;  float is = __rsqrt_v(v);
  
  %__is_0 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %__vis_0 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__is_0)
  %__is_1 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %__vis_1 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__is_1)
  %__is_2 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %__vis_2 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__is_2)
  %__is_3 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %__vis_3 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__is_3)

  %__isa = shufflevector <4 x float> %__vis_0, <4 x float> %__vis_1, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %__isb = shufflevector <4 x float> %__vis_2, <4 x float> %__vis_3, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %is = shufflevector <8 x float> %__isa, <8 x float> %__isb,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


   ; Newton-Raphson iteration to improve precision
  ;  return 0.5 * is * (3. - (v * is) * is);
  %v_is = fmul <16 x float> %v, %is
  %v_is_is = fmul <16 x float> %v_is, %is
  %three_sub = fsub <16 x float> <float 3., float 3., float 3., float 3.,
                                  float 3., float 3., float 3., float 3.,
                                  float 3., float 3., float 3., float 3.,
                                  float 3., float 3., float 3., float 3.>, %v_is_is
  %is_mul = fmul <16 x float> %is, %three_sub
  %half_scale = fmul <16 x float> <float 0.5, float 0.5, float 0.5, float 0.5,
                                   float 0.5, float 0.5, float 0.5, float 0.5,
                                   float 0.5, float 0.5, float 0.5, float 0.5,
                                   float 0.5, float 0.5, float 0.5, float 0.5>, %is_mul
  ret <16 x float> %half_scale
}

define <16 x float> @__rsqrt_fast_varying_float(<16 x float> %v) nounwind readonly alwaysinline {
  
  %__ret_0 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %__vret_0 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__ret_0)
  %__ret_1 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %__vret_1 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__ret_1)
  %__ret_2 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %__vret_2 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__ret_2)
  %__ret_3 = shufflevector <16 x float> %v, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %__vret_3 = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %__ret_3)

  %__reta = shufflevector <4 x float> %__vret_0, <4 x float> %__vret_1, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %__retb = shufflevector <4 x float> %__vret_2, <4 x float> %__vret_3, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %ret = shufflevector <8 x float> %__reta, <8 x float> %__retb,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x float> %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sqrt

declare <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float>) nounwind readnone

define <16 x float> @__sqrt_varying_float(<16 x float>) nounwind readonly alwaysinline {
  
  %__call_0 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %__vcall_0 = call <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float> %__call_0)
  %__call_1 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %__vcall_1 = call <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float> %__call_1)
  %__call_2 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
  %__vcall_2 = call <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float> %__call_2)
  %__call_3 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
  %__vcall_3 = call <4 x float> @llvm.x86.sse.sqrt.ps(<4 x float> %__call_3)

  %__calla = shufflevector <4 x float> %__vcall_0, <4 x float> %__vcall_1, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %__callb = shufflevector <4 x float> %__vcall_2, <4 x float> %__vcall_3, 
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %call = shufflevector <8 x float> %__calla, <8 x float> %__callb,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x float> %call
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; double precision sqrt

declare <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double>) nounwind readnone

define <16 x double> @__sqrt_varying_double(<16 x double>) nounwind
alwaysinline {
  
  %ret_0 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 0, i32 1>
  %vret_0 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_0)
  %ret_1 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 2, i32 3>
  %vret_1 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_1)
  %ret_2 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 4, i32 5>
  %vret_2 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_2)
  %ret_3 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 6, i32 7>
  %vret_3 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_3)
  %ret_4 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 8, i32 9>
  %vret_4 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_4)
  %ret_5 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 10, i32 11>
  %vret_5 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_5)
  %ret_6 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 12, i32 13>
  %vret_6 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_6)
  %ret_7 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 14, i32 15>
  %vret_7 = call <2 x double> @llvm.x86.sse2.sqrt.pd(<2 x double> %ret_7)
  %reta = shufflevector <2 x double> %vret_0, <2 x double> %vret_1,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retb = shufflevector <2 x double> %vret_2, <2 x double> %vret_3,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retab = shufflevector <4 x double> %reta, <4 x double> %retb,
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %retc = shufflevector <2 x double> %vret_4, <2 x double> %vret_5,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retd = shufflevector <2 x double> %vret_6, <2 x double> %vret_7,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retcd = shufflevector <4 x double> %retc, <4 x double> %retd,
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

  %ret = shufflevector <8 x double> %retab, <8 x double> %retcd,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x double> %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding floats

declare <4 x float> @llvm.x86.sse41.round.ps(<4 x float>, i32) nounwind readnone

define <16 x float> @__round_varying_float(<16 x float>) nounwind readonly alwaysinline {
  ; roundps, round mode nearest 0b00 | don't signal precision exceptions 0b1000 = 8
  
%v0 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%v1 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%v2 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%v3 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%r0 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v0, i32 8)
%r1 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v1, i32 8)
%r2 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v2, i32 8)
%r3 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v3, i32 8)
%ret01 = shufflevector <4 x float> %r0, <4 x float> %r1,
         <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret23 = shufflevector <4 x float> %r2, <4 x float> %r3,
         <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret = shufflevector <8 x float> %ret01, <8 x float> %ret23,
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
ret <16 x float> %ret


}

define <16 x float> @__floor_varying_float(<16 x float>) nounwind readonly alwaysinline {
  ; roundps, round down 0b01 | don't signal precision exceptions 0b1001 = 9
  
%v0 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%v1 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%v2 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%v3 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%r0 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v0, i32 9)
%r1 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v1, i32 9)
%r2 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v2, i32 9)
%r3 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v3, i32 9)
%ret01 = shufflevector <4 x float> %r0, <4 x float> %r1,
         <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret23 = shufflevector <4 x float> %r2, <4 x float> %r3,
         <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret = shufflevector <8 x float> %ret01, <8 x float> %ret23,
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
ret <16 x float> %ret


}

define <16 x float> @__ceil_varying_float(<16 x float>) nounwind readonly alwaysinline {
  ; roundps, round up 0b10 | don't signal precision exceptions 0b1010 = 10
  
%v0 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%v1 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%v2 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%v3 = shufflevector <16 x float> %0, <16 x float> undef, <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%r0 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v0, i32 10)
%r1 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v1, i32 10)
%r2 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v2, i32 10)
%r3 = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %v3, i32 10)
%ret01 = shufflevector <4 x float> %r0, <4 x float> %r1,
         <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret23 = shufflevector <4 x float> %r2, <4 x float> %r3,
         <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret = shufflevector <8 x float> %ret01, <8 x float> %ret23,
         <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
ret <16 x float> %ret


}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rounding doubles

declare <2 x double> @llvm.x86.sse41.round.pd(<2 x double>, i32) nounwind readnone

define <16 x double> @__round_varying_double(<16 x double>) nounwind readonly alwaysinline {
    
%v0 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 0,  i32 1>
%v1 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 2,  i32 3>
%v2 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 4,  i32 5>
%v3 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 6,  i32 7>
%v4 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 8,  i32 9>
%v5 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 10, i32 11>
%v6 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 12, i32 13>
%v7 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 14, i32 15>
%r0 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v0, i32 8)
%r1 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v1, i32 8)
%r2 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v2, i32 8)
%r3 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v3, i32 8)
%r4 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v4, i32 8)
%r5 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v5, i32 8)
%r6 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v6, i32 8)
%r7 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v7, i32 8)
%ret0 = shufflevector <2 x double> %r0, <2 x double> %r1,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret1 = shufflevector <2 x double> %r2, <2 x double> %r3,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret01 = shufflevector <4 x double> %ret0, <4 x double> %ret1,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret2 = shufflevector <2 x double> %r4, <2 x double> %r5,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret3 = shufflevector <2 x double> %r6, <2 x double> %r7,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret23 = shufflevector <4 x double> %ret2, <4 x double> %ret3,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret = shufflevector <8 x double> %ret01, <8 x double> %ret23,
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
ret <16 x double> %ret


}

define <16 x double> @__floor_varying_double(<16 x double>) nounwind readonly alwaysinline {
  ; roundpd, round down 0b01 | don't signal precision exceptions 0b1001 = 9
    
%v0 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 0,  i32 1>
%v1 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 2,  i32 3>
%v2 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 4,  i32 5>
%v3 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 6,  i32 7>
%v4 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 8,  i32 9>
%v5 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 10, i32 11>
%v6 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 12, i32 13>
%v7 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 14, i32 15>
%r0 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v0, i32 9)
%r1 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v1, i32 9)
%r2 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v2, i32 9)
%r3 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v3, i32 9)
%r4 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v4, i32 9)
%r5 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v5, i32 9)
%r6 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v6, i32 9)
%r7 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v7, i32 9)
%ret0 = shufflevector <2 x double> %r0, <2 x double> %r1,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret1 = shufflevector <2 x double> %r2, <2 x double> %r3,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret01 = shufflevector <4 x double> %ret0, <4 x double> %ret1,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret2 = shufflevector <2 x double> %r4, <2 x double> %r5,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret3 = shufflevector <2 x double> %r6, <2 x double> %r7,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret23 = shufflevector <4 x double> %ret2, <4 x double> %ret3,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret = shufflevector <8 x double> %ret01, <8 x double> %ret23,
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
ret <16 x double> %ret


}

define <16 x double> @__ceil_varying_double(<16 x double>) nounwind readonly alwaysinline {
  ; roundpd, round up 0b10 | don't signal precision exceptions 0b1010 = 10
    
%v0 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 0,  i32 1>
%v1 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 2,  i32 3>
%v2 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 4,  i32 5>
%v3 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 6,  i32 7>
%v4 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 8,  i32 9>
%v5 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 10, i32 11>
%v6 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 12, i32 13>
%v7 = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 14, i32 15>
%r0 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v0, i32 10)
%r1 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v1, i32 10)
%r2 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v2, i32 10)
%r3 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v3, i32 10)
%r4 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v4, i32 10)
%r5 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v5, i32 10)
%r6 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v6, i32 10)
%r7 = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %v7, i32 10)
%ret0 = shufflevector <2 x double> %r0, <2 x double> %r1,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret1 = shufflevector <2 x double> %r2, <2 x double> %r3,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret01 = shufflevector <4 x double> %ret0, <4 x double> %ret1,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret2 = shufflevector <2 x double> %r4, <2 x double> %r5,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret3 = shufflevector <2 x double> %r6, <2 x double> %r7,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%ret23 = shufflevector <4 x double> %ret2, <4 x double> %ret3,
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%ret = shufflevector <8 x double> %ret01, <8 x double> %ret23,
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
ret <16 x double> %ret


}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; float min/max

declare <4 x float> @llvm.x86.sse.max.ps(<4 x float>, <4 x float>) nounwind readnone
declare <4 x float> @llvm.x86.sse.min.ps(<4 x float>, <4 x float>) nounwind readnone

define <16 x float> @__max_varying_float(<16 x float>, <16 x float>) nounwind readonly alwaysinline {
  
%call_0a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%call_0b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%rcall_0 = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> %call_0a, <4 x float> %call_0b) 

%call_1a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%call_1b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%rcall_1 = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> %call_1a, <4 x float> %call_1b) 

%call_2a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%call_2b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%rcall_2 = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> %call_2a, <4 x float> %call_2b) 

%call_3a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%call_3b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%rcall_3 = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> %call_3a, <4 x float> %call_3b)

%rcall_01 = shufflevector <4 x float> %rcall_0, <4 x float> %rcall_1, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%rcall_23 = shufflevector <4 x float> %rcall_2, <4 x float> %rcall_3, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

%call = shufflevector <8 x float> %rcall_01, <8 x float> %rcall_23, 
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x float> %call
}

define <16 x float> @__min_varying_float(<16 x float>, <16 x float>) nounwind readonly alwaysinline {
  
%call_0a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%call_0b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%rcall_0 = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> %call_0a, <4 x float> %call_0b) 

%call_1a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%call_1b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%rcall_1 = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> %call_1a, <4 x float> %call_1b) 

%call_2a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%call_2b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%rcall_2 = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> %call_2a, <4 x float> %call_2b) 

%call_3a = shufflevector <16 x float> %0, <16 x float> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%call_3b = shufflevector <16 x float> %1, <16 x float> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%rcall_3 = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> %call_3a, <4 x float> %call_3b)

%rcall_01 = shufflevector <4 x float> %rcall_0, <4 x float> %rcall_1, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%rcall_23 = shufflevector <4 x float> %rcall_2, <4 x float> %rcall_3, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

%call = shufflevector <8 x float> %rcall_01, <8 x float> %rcall_23, 
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x float> %call
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; int32 min/max

define <16 x i32> @__min_varying_int32(<16 x i32>, <16 x i32>) nounwind readonly alwaysinline {
  
%call_0a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%call_0b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%rcall_0 = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %call_0a, <4 x i32> %call_0b) 

%call_1a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%call_1b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%rcall_1 = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %call_1a, <4 x i32> %call_1b) 

%call_2a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%call_2b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%rcall_2 = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %call_2a, <4 x i32> %call_2b) 

%call_3a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%call_3b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%rcall_3 = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %call_3a, <4 x i32> %call_3b)

%rcall_01 = shufflevector <4 x i32> %rcall_0, <4 x i32> %rcall_1, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%rcall_23 = shufflevector <4 x i32> %rcall_2, <4 x i32> %rcall_3, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

%call = shufflevector <8 x i32> %rcall_01, <8 x i32> %rcall_23, 
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x i32> %call
}

define <16 x i32> @__max_varying_int32(<16 x i32>, <16 x i32>) nounwind readonly alwaysinline {
  
%call_0a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%call_0b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%rcall_0 = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %call_0a, <4 x i32> %call_0b) 

%call_1a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%call_1b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%rcall_1 = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %call_1a, <4 x i32> %call_1b) 

%call_2a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%call_2b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%rcall_2 = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %call_2a, <4 x i32> %call_2b) 

%call_3a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%call_3b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%rcall_3 = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %call_3a, <4 x i32> %call_3b)

%rcall_01 = shufflevector <4 x i32> %rcall_0, <4 x i32> %rcall_1, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%rcall_23 = shufflevector <4 x i32> %rcall_2, <4 x i32> %rcall_3, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

%call = shufflevector <8 x i32> %rcall_01, <8 x i32> %rcall_23, 
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x i32> %call
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unsigned int min/max

define <16 x i32> @__min_varying_uint32(<16 x i32>, <16 x i32>) nounwind readonly alwaysinline {
  
%call_0a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%call_0b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%rcall_0 = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %call_0a, <4 x i32> %call_0b) 

%call_1a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%call_1b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%rcall_1 = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %call_1a, <4 x i32> %call_1b) 

%call_2a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%call_2b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%rcall_2 = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %call_2a, <4 x i32> %call_2b) 

%call_3a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%call_3b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%rcall_3 = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %call_3a, <4 x i32> %call_3b)

%rcall_01 = shufflevector <4 x i32> %rcall_0, <4 x i32> %rcall_1, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%rcall_23 = shufflevector <4 x i32> %rcall_2, <4 x i32> %rcall_3, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

%call = shufflevector <8 x i32> %rcall_01, <8 x i32> %rcall_23, 
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x i32> %call
}

define <16 x i32> @__max_varying_uint32(<16 x i32>, <16 x i32>) nounwind readonly alwaysinline {
  
%call_0a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%call_0b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
%rcall_0 = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %call_0a, <4 x i32> %call_0b) 

%call_1a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%call_1b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 4, i32 5, i32 6, i32 7>
%rcall_1 = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %call_1a, <4 x i32> %call_1b) 

%call_2a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%call_2b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 8, i32 9, i32 10, i32 11>
%rcall_2 = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %call_2a, <4 x i32> %call_2b) 

%call_3a = shufflevector <16 x i32> %0, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%call_3b = shufflevector <16 x i32> %1, <16 x i32> undef,
          <4 x i32> <i32 12, i32 13, i32 14, i32 15>
%rcall_3 = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %call_3a, <4 x i32> %call_3b)

%rcall_01 = shufflevector <4 x i32> %rcall_0, <4 x i32> %rcall_1, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
%rcall_23 = shufflevector <4 x i32> %rcall_2, <4 x i32> %rcall_3, 
          <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

%call = shufflevector <8 x i32> %rcall_01, <8 x i32> %rcall_23, 
          <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x i32> %call
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; double precision min/max

declare <2 x double> @llvm.x86.sse2.max.pd(<2 x double>, <2 x double>) nounwind readnone
declare <2 x double> @llvm.x86.sse2.min.pd(<2 x double>, <2 x double>) nounwind readnone

define <16 x double> @__min_varying_double(<16 x double>, <16 x double>) nounwind readnone {
  
  %ret_0a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 0, i32 1>
  %ret_0b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 0, i32 1>
  %vret_0 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_0a, <2 x double> %ret_0b)
  %ret_1a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 2, i32 3>
  %ret_1b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 2, i32 3>
  %vret_1 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_1a, <2 x double> %ret_1b)
  %ret_2a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 4, i32 5>
  %ret_2b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 4, i32 5>
  %vret_2 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_2a, <2 x double> %ret_2b)
  %ret_3a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 6, i32 7>
  %ret_3b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 6, i32 7>
  %vret_3 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_3a, <2 x double> %ret_3b)
  %ret_4a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 8, i32 9>
  %ret_4b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 8, i32 9>
  %vret_4 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_4a, <2 x double> %ret_4b)
  %ret_5a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 10, i32 11>
  %ret_5b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 10, i32 11>
  %vret_5 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_5a, <2 x double> %ret_5b)
  %ret_6a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 12, i32 13>
  %ret_6b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 12, i32 13>
  %vret_6 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_6a, <2 x double> %ret_6b)
  %ret_7a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 14, i32 15>
  %ret_7b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 14, i32 15>
  %vret_7 = call <2 x double> @llvm.x86.sse2.min.pd(<2 x double> %ret_7a, <2 x double> %ret_7b)

  %reta = shufflevector <2 x double> %vret_0, <2 x double> %vret_1, 
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retb = shufflevector <2 x double> %vret_2, <2 x double> %vret_3, 
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retab = shufflevector <4 x double> %reta, <4 x double> %retb,
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>           

  %retc = shufflevector <2 x double> %vret_4, <2 x double> %vret_5,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retd = shufflevector <2 x double> %vret_6, <2 x double> %vret_7,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retcd = shufflevector <4 x double> %retc, <4 x double> %retd,
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

  %ret = shufflevector <8 x double> %retab, <8 x double> %retcd,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x double> %ret
}

define <16 x double> @__max_varying_double(<16 x double>, <16 x double>) nounwind readnone {
  
  %ret_0a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 0, i32 1>
  %ret_0b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 0, i32 1>
  %vret_0 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_0a, <2 x double> %ret_0b)
  %ret_1a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 2, i32 3>
  %ret_1b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 2, i32 3>
  %vret_1 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_1a, <2 x double> %ret_1b)
  %ret_2a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 4, i32 5>
  %ret_2b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 4, i32 5>
  %vret_2 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_2a, <2 x double> %ret_2b)
  %ret_3a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 6, i32 7>
  %ret_3b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 6, i32 7>
  %vret_3 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_3a, <2 x double> %ret_3b)
  %ret_4a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 8, i32 9>
  %ret_4b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 8, i32 9>
  %vret_4 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_4a, <2 x double> %ret_4b)
  %ret_5a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 10, i32 11>
  %ret_5b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 10, i32 11>
  %vret_5 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_5a, <2 x double> %ret_5b)
  %ret_6a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 12, i32 13>
  %ret_6b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 12, i32 13>
  %vret_6 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_6a, <2 x double> %ret_6b)
  %ret_7a = shufflevector <16 x double> %0, <16 x double> undef, <2 x i32> <i32 14, i32 15>
  %ret_7b = shufflevector <16 x double> %1, <16 x double> undef, <2 x i32> <i32 14, i32 15>
  %vret_7 = call <2 x double> @llvm.x86.sse2.max.pd(<2 x double> %ret_7a, <2 x double> %ret_7b)

  %reta = shufflevector <2 x double> %vret_0, <2 x double> %vret_1, 
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retb = shufflevector <2 x double> %vret_2, <2 x double> %vret_3, 
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retab = shufflevector <4 x double> %reta, <4 x double> %retb,
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>           

  %retc = shufflevector <2 x double> %vret_4, <2 x double> %vret_5,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retd = shufflevector <2 x double> %vret_6, <2 x double> %vret_7,
           <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %retcd = shufflevector <4 x double> %retc, <4 x double> %retd,
           <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>

  %ret = shufflevector <8 x double> %retab, <8 x double> %retcd,
           <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>


  ret <16 x double> %ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; svml

; FIXME

;;  Copyright (c) 2013-2015, Intel Corporation
;;  All rights reserved.
;;
;;  Redistribution and use in source and binary forms, with or without
;;  modification, are permitted provided that the following conditions are
;;  met:
;;
;;    * Redistributions of source code must retain the above copyright
;;      notice, this list of conditions and the following disclaimer.
;;
;;    * Redistributions in binary form must reproduce the above copyright
;;      notice, this list of conditions and the following disclaimer in the
;;      documentation and/or other materials provided with the distribution.
;;
;;    * Neither the name of Intel Corporation nor the names of its
;;      contributors may be used to endorse or promote products derived from
;;      this software without specific prior written permission.
;;
;;
;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
;;   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
;;   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
;;   OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;;   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  


;; svml macro

;; svml_stubs : stubs for svml calls
;; $1 - type ("float" or "double")
;; $2 - svml internal function suffix ("f" for float, "d" for double)
;; $3 - vector width


;; svml_declare : declaration of __svml_* intrinsics 
;; $1 - type ("float" or "double")
;; $2 - __svml_* intrinsic function suffix 
;;      float:  "f4"(sse) "f8"(avx) "f16"(avx512)
;;      double:  "2"(sse)  "4"(avx)   "8"(avx512)
;; $3 - vector width
;

;; defintition of __svml_* internal functions
;; $1 - type ("float" or "double")
;; $2 - __svml_* intrinsic function suffix 
;;      float:  "f4"(sse) "f8"(avx) "f16"(avx512)
;;      double:  "2"(sse)  "4"(avx)   "8"(avx512)
;; $3 - vector width
;; $4 - svml internal function suffix ("f" for float, "d" for double)



;; svml_define_x : defintition of __svml_* internal functions operation on extended width
;; $1 - type ("float" or "double")
;; $2 - __svml_* intrinsic function suffix 
;;      float:  "f4"(sse) "f8"(avx) "f16"(avx512)
;;      double:  "2"(sse)  "4"(avx)   "8"(avx512)
;; $3 - vector width
;; $4 - svml internal function suffix ("f" for float, "d" for double)
;; $5 - extended width, must be at least twice the native vector width
;;      contigent on existing of unary$3to$5 and binary$3to$5 macros

;; *todo*: in sincos call use __svml_sincos[f][2,4,8,16] call, e.g.
;;define void @__svml_sincosf(<8 x float>, <8 x float> *,
;;                                    <8 x float> *) nounwind alwaysinline {
;;  ; call svml_sincosf4 two times with the two 4-wide sub-vectors
;;  %a = shufflevector <8 x float> %0, <8 x float> undef,
;;         <4 x i32> <i32 0, i32 1, i32 2, i32 3>
;;  %b = shufflevector <8 x float> %0, <8 x float> undef,
;;         <4 x i32> <i32 4, i32 5, i32 6, i32 7>
;;
;;  %cospa = alloca <4 x float>
;;  %sa = call <4 x float> @__svml_sincosf4(<4 x float> * %cospa, <4 x float> %a)
;;
;;  %cospb = alloca <4 x float>
;;  %sb = call <4 x float> @__svml_sincosf4(<4 x float> * %cospb, <4 x float> %b)
;;
;;  %sin = shufflevector <4 x float> %sa, <4 x float> %sb,
;;         <8 x i32> <i32 0, i32 1, i32 2, i32 3,
;;                    i32 4, i32 5, i32 6, i32 7>
;;  store <8 x float> %sin, <8 x float> * %1
;;
;;  %cosa = load <4 x float> * %cospa
;;  %cosb = load <4 x float> * %cospb
;;  %cos = shufflevector <4 x float> %cosa, <4 x float> %cosb,
;;         <8 x i32> <i32 0, i32 1, i32 2, i32 3,
;;                    i32 4, i32 5, i32 6, i32 7>
;;  store <8 x float> %cos, <8 x float> * %2
;;
;;  ret void
;;}




  declare <16 x float> @__svml_sinf(<16 x float>) nounwind readnone alwaysinline
  declare <16 x float> @__svml_asinf(<16 x float>) nounwind readnone alwaysinline 
  declare <16 x float> @__svml_cosf(<16 x float>) nounwind readnone alwaysinline 
  declare void @__svml_sincosf(<16 x float>, <16 x float> *, <16 x float> *) nounwind alwaysinline 
  declare <16 x float> @__svml_tanf(<16 x float>) nounwind readnone alwaysinline 
  declare <16 x float> @__svml_atanf(<16 x float>) nounwind readnone alwaysinline 
  declare <16 x float> @__svml_atan2f(<16 x float>, <16 x float>) nounwind readnone alwaysinline 
  declare <16 x float> @__svml_expf(<16 x float>) nounwind readnone alwaysinline 
  declare <16 x float> @__svml_logf(<16 x float>) nounwind readnone alwaysinline 
  declare <16 x float> @__svml_powf(<16 x float>, <16 x float>) nounwind readnone alwaysinline 


  declare <16 x double> @__svml_sind(<16 x double>) nounwind readnone alwaysinline
  declare <16 x double> @__svml_asind(<16 x double>) nounwind readnone alwaysinline 
  declare <16 x double> @__svml_cosd(<16 x double>) nounwind readnone alwaysinline 
  declare void @__svml_sincosd(<16 x double>, <16 x double> *, <16 x double> *) nounwind alwaysinline 
  declare <16 x double> @__svml_tand(<16 x double>) nounwind readnone alwaysinline 
  declare <16 x double> @__svml_atand(<16 x double>) nounwind readnone alwaysinline 
  declare <16 x double> @__svml_atan2d(<16 x double>, <16 x double>) nounwind readnone alwaysinline 
  declare <16 x double> @__svml_expd(<16 x double>) nounwind readnone alwaysinline 
  declare <16 x double> @__svml_logd(<16 x double>) nounwind readnone alwaysinline 
  declare <16 x double> @__svml_powd(<16 x double>, <16 x double>) nounwind readnone alwaysinline 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; horizontal ops / reductions

declare i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8>) nounwind readnone

define i64 @__movmsk(<16 x i8>) nounwind readnone alwaysinline {
  %m = call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %0)
  %m64 = zext i32 %m to i64
  ret i64 %m64
}

define i1 @__any(<16 x i8>) nounwind readnone alwaysinline {
  %m = call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %0)
  %mne = icmp ne i32 %m, 0
  ret i1 %mne
}

define i1 @__all(<16 x i8>) nounwind readnone alwaysinline {
  %m = call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %0)
  %meq = icmp eq i32 %m, 65535
  ret i1 %meq
}

define i1 @__none(<16 x i8>) nounwind readnone alwaysinline {
  %m = call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %0)
  %meq = icmp eq i32 %m, 0
  ret i1 %meq
}

declare <2 x i64> @llvm.x86.sse2.psad.bw(<16 x i8>, <16 x i8>) nounwind readnone

define i16 @__reduce_add_int8(<16 x i8>) nounwind readnone alwaysinline {
  %rv = call <2 x i64> @llvm.x86.sse2.psad.bw(<16 x i8> %0,
                                              <16 x i8> zeroinitializer)
  %r0 = extractelement <2 x i64> %rv, i32 0
  %r1 = extractelement <2 x i64> %rv, i32 1
  %r = add i64 %r0, %r1
  %r16 = trunc i64 %r to i16
  ret i16 %r16
}

define internal <16 x i16> @__add_varying_i16(<16 x i16>,
                                  <16 x i16>) nounwind readnone alwaysinline {
  %r = add <16 x i16> %0, %1
  ret <16 x i16> %r
}

define internal i16 @__add_uniform_i16(i16, i16) nounwind readnone alwaysinline {
  %r = add i16 %0, %1
  ret i16 %r
}

define i16 @__reduce_add_int16(<16 x i16>) nounwind readnone alwaysinline {
  
  %v1 = shufflevector <16 x i16> %0, <16 x i16> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i16> @__add_varying_i16(<16 x i16> %v1, <16 x i16> %0)
  %v2 = shufflevector <16 x i16> %m1, <16 x i16> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i16> @__add_varying_i16(<16 x i16> %v2, <16 x i16> %m1)
  %v3 = shufflevector <16 x i16> %m2, <16 x i16> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i16> @__add_varying_i16(<16 x i16> %v3, <16 x i16> %m2)

  %m3a = extractelement <16 x i16> %m3, i32 0
  %m3b = extractelement <16 x i16> %m3, i32 1
  %m = call i16 @__add_uniform_i16(i16 %m3a, i16 %m3b)
  ret i16 %m


}

define internal <16 x float> @__add_varying_float(<16 x float>, <16 x float>) {
  %r = fadd <16 x float> %0, %1
  ret <16 x float> %r
}

define internal float @__add_uniform_float(float, float) {
  %r = fadd float %0, %1
  ret float %r
}

define float @__reduce_add_float(<16 x float>) nounwind readonly alwaysinline {
  
  %v1 = shufflevector <16 x float> %0, <16 x float> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x float> @__add_varying_float(<16 x float> %v1, <16 x float> %0)
  %v2 = shufflevector <16 x float> %m1, <16 x float> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x float> @__add_varying_float(<16 x float> %v2, <16 x float> %m1)
  %v3 = shufflevector <16 x float> %m2, <16 x float> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x float> @__add_varying_float(<16 x float> %v3, <16 x float> %m2)

  %m3a = extractelement <16 x float> %m3, i32 0
  %m3b = extractelement <16 x float> %m3, i32 1
  %m = call float @__add_uniform_float(float %m3a, float %m3b)
  ret float %m


}

define float @__reduce_min_float(<16 x float>) nounwind readnone {
  
  %v1 = shufflevector <16 x float> %0, <16 x float> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x float> @__min_varying_float(<16 x float> %v1, <16 x float> %0)
  %v2 = shufflevector <16 x float> %m1, <16 x float> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x float> @__min_varying_float(<16 x float> %v2, <16 x float> %m1)
  %v3 = shufflevector <16 x float> %m2, <16 x float> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x float> @__min_varying_float(<16 x float> %v3, <16 x float> %m2)

  %m3a = extractelement <16 x float> %m3, i32 0
  %m3b = extractelement <16 x float> %m3, i32 1
  %m = call float @__min_uniform_float(float %m3a, float %m3b)
  ret float %m


}

define float @__reduce_max_float(<16 x float>) nounwind readnone {
  
  %v1 = shufflevector <16 x float> %0, <16 x float> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x float> @__max_varying_float(<16 x float> %v1, <16 x float> %0)
  %v2 = shufflevector <16 x float> %m1, <16 x float> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x float> @__max_varying_float(<16 x float> %v2, <16 x float> %m1)
  %v3 = shufflevector <16 x float> %m2, <16 x float> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x float> @__max_varying_float(<16 x float> %v3, <16 x float> %m2)

  %m3a = extractelement <16 x float> %m3, i32 0
  %m3b = extractelement <16 x float> %m3, i32 1
  %m = call float @__max_uniform_float(float %m3a, float %m3b)
  ret float %m


}

define internal <16 x i32> @__add_varying_int32(<16 x i32>, <16 x i32>) {
  %r = add <16 x i32> %0, %1
  ret <16 x i32> %r
}

define internal i32 @__add_uniform_int32(i32, i32) {
  %r = add i32 %0, %1
  ret i32 %r
}

define i32 @__reduce_add_int32(<16 x i32>) nounwind readnone {
  
  %v1 = shufflevector <16 x i32> %0, <16 x i32> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i32> @__add_varying_int32(<16 x i32> %v1, <16 x i32> %0)
  %v2 = shufflevector <16 x i32> %m1, <16 x i32> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i32> @__add_varying_int32(<16 x i32> %v2, <16 x i32> %m1)
  %v3 = shufflevector <16 x i32> %m2, <16 x i32> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i32> @__add_varying_int32(<16 x i32> %v3, <16 x i32> %m2)

  %m3a = extractelement <16 x i32> %m3, i32 0
  %m3b = extractelement <16 x i32> %m3, i32 1
  %m = call i32 @__add_uniform_int32(i32 %m3a, i32 %m3b)
  ret i32 %m


}

define i32 @__reduce_min_int32(<16 x i32>) nounwind readnone {
  
  %v1 = shufflevector <16 x i32> %0, <16 x i32> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i32> @__min_varying_int32(<16 x i32> %v1, <16 x i32> %0)
  %v2 = shufflevector <16 x i32> %m1, <16 x i32> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i32> @__min_varying_int32(<16 x i32> %v2, <16 x i32> %m1)
  %v3 = shufflevector <16 x i32> %m2, <16 x i32> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i32> @__min_varying_int32(<16 x i32> %v3, <16 x i32> %m2)

  %m3a = extractelement <16 x i32> %m3, i32 0
  %m3b = extractelement <16 x i32> %m3, i32 1
  %m = call i32 @__min_uniform_int32(i32 %m3a, i32 %m3b)
  ret i32 %m


}

define i32 @__reduce_max_int32(<16 x i32>) nounwind readnone {
  
  %v1 = shufflevector <16 x i32> %0, <16 x i32> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i32> @__max_varying_int32(<16 x i32> %v1, <16 x i32> %0)
  %v2 = shufflevector <16 x i32> %m1, <16 x i32> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i32> @__max_varying_int32(<16 x i32> %v2, <16 x i32> %m1)
  %v3 = shufflevector <16 x i32> %m2, <16 x i32> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i32> @__max_varying_int32(<16 x i32> %v3, <16 x i32> %m2)

  %m3a = extractelement <16 x i32> %m3, i32 0
  %m3b = extractelement <16 x i32> %m3, i32 1
  %m = call i32 @__max_uniform_int32(i32 %m3a, i32 %m3b)
  ret i32 %m


}

define i32 @__reduce_min_uint32(<16 x i32>) nounwind readnone {
  
  %v1 = shufflevector <16 x i32> %0, <16 x i32> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i32> @__min_varying_uint32(<16 x i32> %v1, <16 x i32> %0)
  %v2 = shufflevector <16 x i32> %m1, <16 x i32> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i32> @__min_varying_uint32(<16 x i32> %v2, <16 x i32> %m1)
  %v3 = shufflevector <16 x i32> %m2, <16 x i32> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i32> @__min_varying_uint32(<16 x i32> %v3, <16 x i32> %m2)

  %m3a = extractelement <16 x i32> %m3, i32 0
  %m3b = extractelement <16 x i32> %m3, i32 1
  %m = call i32 @__min_uniform_uint32(i32 %m3a, i32 %m3b)
  ret i32 %m


}

define i32 @__reduce_max_uint32(<16 x i32>) nounwind readnone {
  
  %v1 = shufflevector <16 x i32> %0, <16 x i32> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i32> @__max_varying_uint32(<16 x i32> %v1, <16 x i32> %0)
  %v2 = shufflevector <16 x i32> %m1, <16 x i32> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i32> @__max_varying_uint32(<16 x i32> %v2, <16 x i32> %m1)
  %v3 = shufflevector <16 x i32> %m2, <16 x i32> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i32> @__max_varying_uint32(<16 x i32> %v3, <16 x i32> %m2)

  %m3a = extractelement <16 x i32> %m3, i32 0
  %m3b = extractelement <16 x i32> %m3, i32 1
  %m = call i32 @__max_uniform_uint32(i32 %m3a, i32 %m3b)
  ret i32 %m


}

define internal <16 x double> @__add_varying_double(<16 x double>, <16 x double>) {
  %r = fadd <16 x double> %0, %1
  ret <16 x double> %r
}

define internal double @__add_uniform_double(double, double) {
  %r = fadd double %0, %1
  ret double %r
}

define double @__reduce_add_double(<16 x double>) nounwind readnone {
  
  %v1 = shufflevector <16 x double> %0, <16 x double> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x double> @__add_varying_double(<16 x double> %v1, <16 x double> %0)
  %v2 = shufflevector <16 x double> %m1, <16 x double> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x double> @__add_varying_double(<16 x double> %v2, <16 x double> %m1)
  %v3 = shufflevector <16 x double> %m2, <16 x double> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x double> @__add_varying_double(<16 x double> %v3, <16 x double> %m2)

  %m3a = extractelement <16 x double> %m3, i32 0
  %m3b = extractelement <16 x double> %m3, i32 1
  %m = call double @__add_uniform_double(double %m3a, double %m3b)
  ret double %m


}

define double @__reduce_min_double(<16 x double>) nounwind readnone {
  
  %v1 = shufflevector <16 x double> %0, <16 x double> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x double> @__min_varying_double(<16 x double> %v1, <16 x double> %0)
  %v2 = shufflevector <16 x double> %m1, <16 x double> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x double> @__min_varying_double(<16 x double> %v2, <16 x double> %m1)
  %v3 = shufflevector <16 x double> %m2, <16 x double> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x double> @__min_varying_double(<16 x double> %v3, <16 x double> %m2)

  %m3a = extractelement <16 x double> %m3, i32 0
  %m3b = extractelement <16 x double> %m3, i32 1
  %m = call double @__min_uniform_double(double %m3a, double %m3b)
  ret double %m


}

define double @__reduce_max_double(<16 x double>) nounwind readnone {
  
  %v1 = shufflevector <16 x double> %0, <16 x double> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x double> @__max_varying_double(<16 x double> %v1, <16 x double> %0)
  %v2 = shufflevector <16 x double> %m1, <16 x double> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x double> @__max_varying_double(<16 x double> %v2, <16 x double> %m1)
  %v3 = shufflevector <16 x double> %m2, <16 x double> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x double> @__max_varying_double(<16 x double> %v3, <16 x double> %m2)

  %m3a = extractelement <16 x double> %m3, i32 0
  %m3b = extractelement <16 x double> %m3, i32 1
  %m = call double @__max_uniform_double(double %m3a, double %m3b)
  ret double %m


}

define internal <16 x i64> @__add_varying_int64(<16 x i64>, <16 x i64>) {
  %r = add <16 x i64> %0, %1
  ret <16 x i64> %r
}

define internal i64 @__add_uniform_int64(i64, i64) {
  %r = add i64 %0, %1
  ret i64 %r
}

define i64 @__reduce_add_int64(<16 x i64>) nounwind readnone {
  
  %v1 = shufflevector <16 x i64> %0, <16 x i64> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i64> @__add_varying_int64(<16 x i64> %v1, <16 x i64> %0)
  %v2 = shufflevector <16 x i64> %m1, <16 x i64> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i64> @__add_varying_int64(<16 x i64> %v2, <16 x i64> %m1)
  %v3 = shufflevector <16 x i64> %m2, <16 x i64> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i64> @__add_varying_int64(<16 x i64> %v3, <16 x i64> %m2)

  %m3a = extractelement <16 x i64> %m3, i32 0
  %m3b = extractelement <16 x i64> %m3, i32 1
  %m = call i64 @__add_uniform_int64(i64 %m3a, i64 %m3b)
  ret i64 %m


}

define i64 @__reduce_min_int64(<16 x i64>) nounwind readnone {
  
  %v1 = shufflevector <16 x i64> %0, <16 x i64> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i64> @__min_varying_int64(<16 x i64> %v1, <16 x i64> %0)
  %v2 = shufflevector <16 x i64> %m1, <16 x i64> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i64> @__min_varying_int64(<16 x i64> %v2, <16 x i64> %m1)
  %v3 = shufflevector <16 x i64> %m2, <16 x i64> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i64> @__min_varying_int64(<16 x i64> %v3, <16 x i64> %m2)

  %m3a = extractelement <16 x i64> %m3, i32 0
  %m3b = extractelement <16 x i64> %m3, i32 1
  %m = call i64 @__min_uniform_int64(i64 %m3a, i64 %m3b)
  ret i64 %m


}

define i64 @__reduce_max_int64(<16 x i64>) nounwind readnone {
  
  %v1 = shufflevector <16 x i64> %0, <16 x i64> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i64> @__max_varying_int64(<16 x i64> %v1, <16 x i64> %0)
  %v2 = shufflevector <16 x i64> %m1, <16 x i64> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i64> @__max_varying_int64(<16 x i64> %v2, <16 x i64> %m1)
  %v3 = shufflevector <16 x i64> %m2, <16 x i64> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i64> @__max_varying_int64(<16 x i64> %v3, <16 x i64> %m2)

  %m3a = extractelement <16 x i64> %m3, i32 0
  %m3b = extractelement <16 x i64> %m3, i32 1
  %m = call i64 @__max_uniform_int64(i64 %m3a, i64 %m3b)
  ret i64 %m


}

define i64 @__reduce_min_uint64(<16 x i64>) nounwind readnone {
  
  %v1 = shufflevector <16 x i64> %0, <16 x i64> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i64> @__min_varying_uint64(<16 x i64> %v1, <16 x i64> %0)
  %v2 = shufflevector <16 x i64> %m1, <16 x i64> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i64> @__min_varying_uint64(<16 x i64> %v2, <16 x i64> %m1)
  %v3 = shufflevector <16 x i64> %m2, <16 x i64> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i64> @__min_varying_uint64(<16 x i64> %v3, <16 x i64> %m2)

  %m3a = extractelement <16 x i64> %m3, i32 0
  %m3b = extractelement <16 x i64> %m3, i32 1
  %m = call i64 @__min_uniform_uint64(i64 %m3a, i64 %m3b)
  ret i64 %m


}

define i64 @__reduce_max_uint64(<16 x i64>) nounwind readnone {
  
  %v1 = shufflevector <16 x i64> %0, <16 x i64> undef,
        <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m1 = call <16 x i64> @__max_varying_uint64(<16 x i64> %v1, <16 x i64> %0)
  %v2 = shufflevector <16 x i64> %m1, <16 x i64> undef,
        <16 x i32> <i32 4, i32 5, i32 6, i32 7,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m2 = call <16 x i64> @__max_varying_uint64(<16 x i64> %v2, <16 x i64> %m1)
  %v3 = shufflevector <16 x i64> %m2, <16 x i64> undef,
        <16 x i32> <i32 2, i32 3, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef,
                    i32 undef, i32 undef, i32 undef, i32 undef>
  %m3 = call <16 x i64> @__max_varying_uint64(<16 x i64> %v3, <16 x i64> %m2)

  %m3a = extractelement <16 x i64> %m3, i32 0
  %m3b = extractelement <16 x i64> %m3, i32 1
  %m = call i64 @__max_uniform_uint64(i64 %m3a, i64 %m3b)
  ret i64 %m


}








define i1 @__reduce_equal_int32(<16 x i32> %v, i32 * %samevalue,
                             <16 x i8> %mask) nounwind alwaysinline {
entry:
   %mm = call i64 @__movmsk(<16 x i8> %mask)
   %allon = icmp eq i64 %mm, 65535
   br i1 %allon, label %check_neighbors, label %domixed

domixed:
  ; First, figure out which lane is the first active one
  %first = call i64 @llvm.cttz.i64(i64 %mm)
  %first32 = trunc i64 %first to i32
  %baseval = extractelement <16 x i32> %v, i32 %first32
  %basev1 = insertelement <16 x i32> undef, i32 %baseval, i32 0
  ; get a vector that is that value smeared across all elements
  %basesmear = shufflevector <16 x i32> %basev1, <16 x i32> undef,
        <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >

  ; now to a blend of that vector with the original vector, such that the
  ; result will be the original value for the active lanes, and the value
  ; from the first active lane for the inactive lanes.  Given that, we can
  ; just unconditionally check if the lanes are all equal in check_neighbors
  ; below without worrying about inactive lanes...
  %ptr = alloca <16 x i32>
  store <16 x i32> %basesmear, <16 x i32> * %ptr
  %castptr = bitcast <16 x i32> * %ptr to <16 x i32> *
  %castv = bitcast <16 x i32> %v to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %castptr, <16 x i32> %castv, <16 x i8> %mask)
  %blendvec = load <16 x i32>  , <16 x i32>  *
  %ptr
  br label %check_neighbors

check_neighbors:
  %vec = phi <16 x i32> [ %blendvec, %domixed ], [ %v, %entry ]
  
  ; For 32-bit elements, we rotate once and compare with the vector, which ends 
  ; up comparing each element to its neighbor on the right.  Then see if
  ; all of those values are true; if so, then all of the elements are equal..
  %castvec = bitcast <16 x i32> %vec to <16 x i32>
  %castvr = call <16 x i32> @__rotate_i32(<16 x i32> %castvec, i32 1)
  %vr = bitcast <16 x i32> %castvr to <16 x i32>
  %eq = icmp eq <16 x i32> %vec, %vr
  %eqm = sext <16 x i1> %eq to <16 x i8>
    %eqmm = call i64 @__movmsk(<16 x i8> %eqm)
  %alleq = icmp eq i64 %eqmm, 65535
  br i1 %alleq, label %all_equal, label %not_all_equal
  

all_equal:
  %the_value = extractelement <16 x i32> %vec, i32 0
  store i32 %the_value, i32 * %samevalue
  ret i1 true

not_all_equal:
  ret i1 false
}







define i1 @__reduce_equal_float(<16 x float> %v, float * %samevalue,
                             <16 x i8> %mask) nounwind alwaysinline {
entry:
   %mm = call i64 @__movmsk(<16 x i8> %mask)
   %allon = icmp eq i64 %mm, 65535
   br i1 %allon, label %check_neighbors, label %domixed

domixed:
  ; First, figure out which lane is the first active one
  %first = call i64 @llvm.cttz.i64(i64 %mm)
  %first32 = trunc i64 %first to i32
  %baseval = extractelement <16 x float> %v, i32 %first32
  %basev1 = insertelement <16 x float> undef, float %baseval, i32 0
  ; get a vector that is that value smeared across all elements
  %basesmear = shufflevector <16 x float> %basev1, <16 x float> undef,
        <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >

  ; now to a blend of that vector with the original vector, such that the
  ; result will be the original value for the active lanes, and the value
  ; from the first active lane for the inactive lanes.  Given that, we can
  ; just unconditionally check if the lanes are all equal in check_neighbors
  ; below without worrying about inactive lanes...
  %ptr = alloca <16 x float>
  store <16 x float> %basesmear, <16 x float> * %ptr
  %castptr = bitcast <16 x float> * %ptr to <16 x i32> *
  %castv = bitcast <16 x float> %v to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %castptr, <16 x i32> %castv, <16 x i8> %mask)
  %blendvec = load <16 x float>  , <16 x float>  *
  %ptr
  br label %check_neighbors

check_neighbors:
  %vec = phi <16 x float> [ %blendvec, %domixed ], [ %v, %entry ]
  
  ; For 32-bit elements, we rotate once and compare with the vector, which ends 
  ; up comparing each element to its neighbor on the right.  Then see if
  ; all of those values are true; if so, then all of the elements are equal..
  %castvec = bitcast <16 x float> %vec to <16 x i32>
  %castvr = call <16 x i32> @__rotate_i32(<16 x i32> %castvec, i32 1)
  %vr = bitcast <16 x i32> %castvr to <16 x float>
  %eq = fcmp oeq <16 x float> %vec, %vr
  %eqm = sext <16 x i1> %eq to <16 x i8>
    %eqmm = call i64 @__movmsk(<16 x i8> %eqm)
  %alleq = icmp eq i64 %eqmm, 65535
  br i1 %alleq, label %all_equal, label %not_all_equal
  

all_equal:
  %the_value = extractelement <16 x float> %vec, i32 0
  store float %the_value, float * %samevalue
  ret i1 true

not_all_equal:
  ret i1 false
}







define i1 @__reduce_equal_int64(<16 x i64> %v, i64 * %samevalue,
                             <16 x i8> %mask) nounwind alwaysinline {
entry:
   %mm = call i64 @__movmsk(<16 x i8> %mask)
   %allon = icmp eq i64 %mm, 65535
   br i1 %allon, label %check_neighbors, label %domixed

domixed:
  ; First, figure out which lane is the first active one
  %first = call i64 @llvm.cttz.i64(i64 %mm)
  %first32 = trunc i64 %first to i32
  %baseval = extractelement <16 x i64> %v, i32 %first32
  %basev1 = insertelement <16 x i64> undef, i64 %baseval, i32 0
  ; get a vector that is that value smeared across all elements
  %basesmear = shufflevector <16 x i64> %basev1, <16 x i64> undef,
        <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >

  ; now to a blend of that vector with the original vector, such that the
  ; result will be the original value for the active lanes, and the value
  ; from the first active lane for the inactive lanes.  Given that, we can
  ; just unconditionally check if the lanes are all equal in check_neighbors
  ; below without worrying about inactive lanes...
  %ptr = alloca <16 x i64>
  store <16 x i64> %basesmear, <16 x i64> * %ptr
  %castptr = bitcast <16 x i64> * %ptr to <16 x i64> *
  %castv = bitcast <16 x i64> %v to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %castptr, <16 x i64> %castv, <16 x i8> %mask)
  %blendvec = load <16 x i64>  , <16 x i64>  *
  %ptr
  br label %check_neighbors

check_neighbors:
  %vec = phi <16 x i64> [ %blendvec, %domixed ], [ %v, %entry ]
  
  ; But for 64-bit elements, it turns out to be more efficient to just
  ; scalarize and do a individual pairwise comparisons and AND those
  ; all together..
  
  %v0 = extractelement <16 x i64> %vec, i32 0
  %v1 = extractelement <16 x i64> %vec, i32 1
  %v2 = extractelement <16 x i64> %vec, i32 2
  %v3 = extractelement <16 x i64> %vec, i32 3
  %v4 = extractelement <16 x i64> %vec, i32 4
  %v5 = extractelement <16 x i64> %vec, i32 5
  %v6 = extractelement <16 x i64> %vec, i32 6
  %v7 = extractelement <16 x i64> %vec, i32 7
  %v8 = extractelement <16 x i64> %vec, i32 8
  %v9 = extractelement <16 x i64> %vec, i32 9
  %v10 = extractelement <16 x i64> %vec, i32 10
  %v11 = extractelement <16 x i64> %vec, i32 11
  %v12 = extractelement <16 x i64> %vec, i32 12
  %v13 = extractelement <16 x i64> %vec, i32 13
  %v14 = extractelement <16 x i64> %vec, i32 14
  %v15 = extractelement <16 x i64> %vec, i32 15

  
  %eq0 = icmp eq i64 %v0, %v1
  %eq1 = icmp eq i64 %v1, %v2
  %eq2 = icmp eq i64 %v2, %v3
  %eq3 = icmp eq i64 %v3, %v4
  %eq4 = icmp eq i64 %v4, %v5
  %eq5 = icmp eq i64 %v5, %v6
  %eq6 = icmp eq i64 %v6, %v7
  %eq7 = icmp eq i64 %v7, %v8
  %eq8 = icmp eq i64 %v8, %v9
  %eq9 = icmp eq i64 %v9, %v10
  %eq10 = icmp eq i64 %v10, %v11
  %eq11 = icmp eq i64 %v11, %v12
  %eq12 = icmp eq i64 %v12, %v13
  %eq13 = icmp eq i64 %v13, %v14
  %eq14 = icmp eq i64 %v14, %v15

  %and0 = and i1 %eq0, %eq1
  
  %and1 = and i1 %and0, %eq2
  %and2 = and i1 %and1, %eq3
  %and3 = and i1 %and2, %eq4
  %and4 = and i1 %and3, %eq5
  %and5 = and i1 %and4, %eq6
  %and6 = and i1 %and5, %eq7
  %and7 = and i1 %and6, %eq8
  %and8 = and i1 %and7, %eq9
  %and9 = and i1 %and8, %eq10
  %and10 = and i1 %and9, %eq11
  %and11 = and i1 %and10, %eq12
  %and12 = and i1 %and11, %eq13
  %and13 = and i1 %and12, %eq14

  br i1 %and13, label %all_equal, label %not_all_equal
  

all_equal:
  %the_value = extractelement <16 x i64> %vec, i32 0
  store i64 %the_value, i64 * %samevalue
  ret i1 true

not_all_equal:
  ret i1 false
}







define i1 @__reduce_equal_double(<16 x double> %v, double * %samevalue,
                             <16 x i8> %mask) nounwind alwaysinline {
entry:
   %mm = call i64 @__movmsk(<16 x i8> %mask)
   %allon = icmp eq i64 %mm, 65535
   br i1 %allon, label %check_neighbors, label %domixed

domixed:
  ; First, figure out which lane is the first active one
  %first = call i64 @llvm.cttz.i64(i64 %mm)
  %first32 = trunc i64 %first to i32
  %baseval = extractelement <16 x double> %v, i32 %first32
  %basev1 = insertelement <16 x double> undef, double %baseval, i32 0
  ; get a vector that is that value smeared across all elements
  %basesmear = shufflevector <16 x double> %basev1, <16 x double> undef,
        <16 x i32> < i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,  i32 0 >

  ; now to a blend of that vector with the original vector, such that the
  ; result will be the original value for the active lanes, and the value
  ; from the first active lane for the inactive lanes.  Given that, we can
  ; just unconditionally check if the lanes are all equal in check_neighbors
  ; below without worrying about inactive lanes...
  %ptr = alloca <16 x double>
  store <16 x double> %basesmear, <16 x double> * %ptr
  %castptr = bitcast <16 x double> * %ptr to <16 x i64> *
  %castv = bitcast <16 x double> %v to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %castptr, <16 x i64> %castv, <16 x i8> %mask)
  %blendvec = load <16 x double>  , <16 x double>  *
  %ptr
  br label %check_neighbors

check_neighbors:
  %vec = phi <16 x double> [ %blendvec, %domixed ], [ %v, %entry ]
  
  ; But for 64-bit elements, it turns out to be more efficient to just
  ; scalarize and do a individual pairwise comparisons and AND those
  ; all together..
  
  %v0 = extractelement <16 x double> %vec, i32 0
  %v1 = extractelement <16 x double> %vec, i32 1
  %v2 = extractelement <16 x double> %vec, i32 2
  %v3 = extractelement <16 x double> %vec, i32 3
  %v4 = extractelement <16 x double> %vec, i32 4
  %v5 = extractelement <16 x double> %vec, i32 5
  %v6 = extractelement <16 x double> %vec, i32 6
  %v7 = extractelement <16 x double> %vec, i32 7
  %v8 = extractelement <16 x double> %vec, i32 8
  %v9 = extractelement <16 x double> %vec, i32 9
  %v10 = extractelement <16 x double> %vec, i32 10
  %v11 = extractelement <16 x double> %vec, i32 11
  %v12 = extractelement <16 x double> %vec, i32 12
  %v13 = extractelement <16 x double> %vec, i32 13
  %v14 = extractelement <16 x double> %vec, i32 14
  %v15 = extractelement <16 x double> %vec, i32 15

  
  %eq0 = fcmp oeq double %v0, %v1
  %eq1 = fcmp oeq double %v1, %v2
  %eq2 = fcmp oeq double %v2, %v3
  %eq3 = fcmp oeq double %v3, %v4
  %eq4 = fcmp oeq double %v4, %v5
  %eq5 = fcmp oeq double %v5, %v6
  %eq6 = fcmp oeq double %v6, %v7
  %eq7 = fcmp oeq double %v7, %v8
  %eq8 = fcmp oeq double %v8, %v9
  %eq9 = fcmp oeq double %v9, %v10
  %eq10 = fcmp oeq double %v10, %v11
  %eq11 = fcmp oeq double %v11, %v12
  %eq12 = fcmp oeq double %v12, %v13
  %eq13 = fcmp oeq double %v13, %v14
  %eq14 = fcmp oeq double %v14, %v15

  %and0 = and i1 %eq0, %eq1
  
  %and1 = and i1 %and0, %eq2
  %and2 = and i1 %and1, %eq3
  %and3 = and i1 %and2, %eq4
  %and4 = and i1 %and3, %eq5
  %and5 = and i1 %and4, %eq6
  %and6 = and i1 %and5, %eq7
  %and7 = and i1 %and6, %eq8
  %and8 = and i1 %and7, %eq9
  %and9 = and i1 %and8, %eq10
  %and10 = and i1 %and9, %eq11
  %and11 = and i1 %and10, %eq12
  %and12 = and i1 %and11, %eq13
  %and13 = and i1 %and12, %eq14

  br i1 %and13, label %all_equal, label %not_all_equal
  

all_equal:
  %the_value = extractelement <16 x double> %vec, i32 0
  store double %the_value, double * %samevalue
  ret i1 true

not_all_equal:
  ret i1 false
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; masked store

define void @__masked_store_blend_i64(<16 x i64>* nocapture, <16 x i64>,
                                      <16 x i8> %mask) nounwind
                                      alwaysinline {
  %mask_as_i1 = trunc <16 x i8> %mask to <16 x i1>
  %old = load <16 x i64> , <16 x i64> *
  %0, align 4
  %blend = select <16 x i1> %mask_as_i1, <16 x i64> %1, <16 x i64> %old
  store <16 x i64> %blend, <16 x i64>* %0, align 4
  ret void
}

define void @__masked_store_blend_i32(<16 x i32>* nocapture, <16 x i32>, 
                                      <16 x i8> %mask) nounwind alwaysinline {
  %mask_as_i1 = trunc <16 x i8> %mask to <16 x i1>
  %old = load <16 x i32> , <16 x i32> *
  %0, align 4
  %blend = select <16 x i1> %mask_as_i1, <16 x i32> %1, <16 x i32> %old
  store <16 x i32> %blend, <16 x i32>* %0, align 4
  ret void
}

define void @__masked_store_blend_i16(<16 x i16>* nocapture, <16 x i16>,
                                     <16 x i8> %mask) nounwind alwaysinline {
  %mask_as_i1 = trunc <16 x i8> %mask to <16 x i1>
  %old = load <16 x i16> , <16 x i16> *
  %0, align 4
  %blend = select <16 x i1> %mask_as_i1, <16 x i16> %1, <16 x i16> %old
  store <16 x i16> %blend, <16 x i16>* %0, align 4
  ret void
}

declare <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone

define void @__masked_store_blend_i8(<16 x i8>* nocapture, <16 x i8>,
                                     <16 x i8> %mask) nounwind alwaysinline {
  %old = load <16 x i8> , <16 x i8> *
  %0, align 4
  %blend = call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %old, <16 x i8> %1,
                                                   <16 x i8> %mask)
  store <16 x i8> %blend, <16 x i8>* %0, align 4
  ret void
}


define void @__masked_store_i8(<16 x i8>* nocapture, <16 x i8>, <16 x i8>) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %2)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %2)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      %ptr_0_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 0
      %storeval_0_ID = extractelement <16 x i8> %1, i32 0
      store i8 %storeval_0_ID, i8 * %ptr_0_ID
      %ptr_1_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 1
      %storeval_1_ID = extractelement <16 x i8> %1, i32 1
      store i8 %storeval_1_ID, i8 * %ptr_1_ID
      %ptr_2_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 2
      %storeval_2_ID = extractelement <16 x i8> %1, i32 2
      store i8 %storeval_2_ID, i8 * %ptr_2_ID
      %ptr_3_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 3
      %storeval_3_ID = extractelement <16 x i8> %1, i32 3
      store i8 %storeval_3_ID, i8 * %ptr_3_ID
      %ptr_4_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 4
      %storeval_4_ID = extractelement <16 x i8> %1, i32 4
      store i8 %storeval_4_ID, i8 * %ptr_4_ID
      %ptr_5_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 5
      %storeval_5_ID = extractelement <16 x i8> %1, i32 5
      store i8 %storeval_5_ID, i8 * %ptr_5_ID
      %ptr_6_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 6
      %storeval_6_ID = extractelement <16 x i8> %1, i32 6
      store i8 %storeval_6_ID, i8 * %ptr_6_ID
      %ptr_7_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 7
      %storeval_7_ID = extractelement <16 x i8> %1, i32 7
      store i8 %storeval_7_ID, i8 * %ptr_7_ID
      %ptr_8_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 8
      %storeval_8_ID = extractelement <16 x i8> %1, i32 8
      store i8 %storeval_8_ID, i8 * %ptr_8_ID
      %ptr_9_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 9
      %storeval_9_ID = extractelement <16 x i8> %1, i32 9
      store i8 %storeval_9_ID, i8 * %ptr_9_ID
      %ptr_10_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 10
      %storeval_10_ID = extractelement <16 x i8> %1, i32 10
      store i8 %storeval_10_ID, i8 * %ptr_10_ID
      %ptr_11_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 11
      %storeval_11_ID = extractelement <16 x i8> %1, i32 11
      store i8 %storeval_11_ID, i8 * %ptr_11_ID
      %ptr_12_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 12
      %storeval_12_ID = extractelement <16 x i8> %1, i32 12
      store i8 %storeval_12_ID, i8 * %ptr_12_ID
      %ptr_13_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 13
      %storeval_13_ID = extractelement <16 x i8> %1, i32 13
      store i8 %storeval_13_ID, i8 * %ptr_13_ID
      %ptr_14_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 14
      %storeval_14_ID = extractelement <16 x i8> %1, i32 14
      store i8 %storeval_14_ID, i8 * %ptr_14_ID
      %ptr_15_ID = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 15
      %storeval_15_ID = extractelement <16 x i8> %1, i32 15
      store i8 %storeval_15_ID, i8 * %ptr_15_ID
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      %ptr__id = getelementptr <16 x i8> , <16 x i8> *
 %0, i32 0, i32 %pl_lane
      %storeval__id = extractelement <16 x i8> %1, i32 %pl_lane
      store i8 %storeval__id, i8 * %ptr__id
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}


define void @__masked_store_i16(<16 x i16>* nocapture, <16 x i16>, <16 x i8>) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %2)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %2)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      %ptr_0_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 0
      %storeval_0_ID = extractelement <16 x i16> %1, i32 0
      store i16 %storeval_0_ID, i16 * %ptr_0_ID
      %ptr_1_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 1
      %storeval_1_ID = extractelement <16 x i16> %1, i32 1
      store i16 %storeval_1_ID, i16 * %ptr_1_ID
      %ptr_2_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 2
      %storeval_2_ID = extractelement <16 x i16> %1, i32 2
      store i16 %storeval_2_ID, i16 * %ptr_2_ID
      %ptr_3_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 3
      %storeval_3_ID = extractelement <16 x i16> %1, i32 3
      store i16 %storeval_3_ID, i16 * %ptr_3_ID
      %ptr_4_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 4
      %storeval_4_ID = extractelement <16 x i16> %1, i32 4
      store i16 %storeval_4_ID, i16 * %ptr_4_ID
      %ptr_5_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 5
      %storeval_5_ID = extractelement <16 x i16> %1, i32 5
      store i16 %storeval_5_ID, i16 * %ptr_5_ID
      %ptr_6_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 6
      %storeval_6_ID = extractelement <16 x i16> %1, i32 6
      store i16 %storeval_6_ID, i16 * %ptr_6_ID
      %ptr_7_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 7
      %storeval_7_ID = extractelement <16 x i16> %1, i32 7
      store i16 %storeval_7_ID, i16 * %ptr_7_ID
      %ptr_8_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 8
      %storeval_8_ID = extractelement <16 x i16> %1, i32 8
      store i16 %storeval_8_ID, i16 * %ptr_8_ID
      %ptr_9_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 9
      %storeval_9_ID = extractelement <16 x i16> %1, i32 9
      store i16 %storeval_9_ID, i16 * %ptr_9_ID
      %ptr_10_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 10
      %storeval_10_ID = extractelement <16 x i16> %1, i32 10
      store i16 %storeval_10_ID, i16 * %ptr_10_ID
      %ptr_11_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 11
      %storeval_11_ID = extractelement <16 x i16> %1, i32 11
      store i16 %storeval_11_ID, i16 * %ptr_11_ID
      %ptr_12_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 12
      %storeval_12_ID = extractelement <16 x i16> %1, i32 12
      store i16 %storeval_12_ID, i16 * %ptr_12_ID
      %ptr_13_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 13
      %storeval_13_ID = extractelement <16 x i16> %1, i32 13
      store i16 %storeval_13_ID, i16 * %ptr_13_ID
      %ptr_14_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 14
      %storeval_14_ID = extractelement <16 x i16> %1, i32 14
      store i16 %storeval_14_ID, i16 * %ptr_14_ID
      %ptr_15_ID = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 15
      %storeval_15_ID = extractelement <16 x i16> %1, i32 15
      store i16 %storeval_15_ID, i16 * %ptr_15_ID
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      %ptr__id = getelementptr <16 x i16> , <16 x i16> *
 %0, i32 0, i32 %pl_lane
      %storeval__id = extractelement <16 x i16> %1, i32 %pl_lane
      store i16 %storeval__id, i16 * %ptr__id
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}


define void @__masked_store_i32(<16 x i32>* nocapture, <16 x i32>, <16 x i8>) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %2)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %2)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      %ptr_0_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 0
      %storeval_0_ID = extractelement <16 x i32> %1, i32 0
      store i32 %storeval_0_ID, i32 * %ptr_0_ID
      %ptr_1_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 1
      %storeval_1_ID = extractelement <16 x i32> %1, i32 1
      store i32 %storeval_1_ID, i32 * %ptr_1_ID
      %ptr_2_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 2
      %storeval_2_ID = extractelement <16 x i32> %1, i32 2
      store i32 %storeval_2_ID, i32 * %ptr_2_ID
      %ptr_3_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 3
      %storeval_3_ID = extractelement <16 x i32> %1, i32 3
      store i32 %storeval_3_ID, i32 * %ptr_3_ID
      %ptr_4_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 4
      %storeval_4_ID = extractelement <16 x i32> %1, i32 4
      store i32 %storeval_4_ID, i32 * %ptr_4_ID
      %ptr_5_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 5
      %storeval_5_ID = extractelement <16 x i32> %1, i32 5
      store i32 %storeval_5_ID, i32 * %ptr_5_ID
      %ptr_6_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 6
      %storeval_6_ID = extractelement <16 x i32> %1, i32 6
      store i32 %storeval_6_ID, i32 * %ptr_6_ID
      %ptr_7_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 7
      %storeval_7_ID = extractelement <16 x i32> %1, i32 7
      store i32 %storeval_7_ID, i32 * %ptr_7_ID
      %ptr_8_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 8
      %storeval_8_ID = extractelement <16 x i32> %1, i32 8
      store i32 %storeval_8_ID, i32 * %ptr_8_ID
      %ptr_9_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 9
      %storeval_9_ID = extractelement <16 x i32> %1, i32 9
      store i32 %storeval_9_ID, i32 * %ptr_9_ID
      %ptr_10_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 10
      %storeval_10_ID = extractelement <16 x i32> %1, i32 10
      store i32 %storeval_10_ID, i32 * %ptr_10_ID
      %ptr_11_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 11
      %storeval_11_ID = extractelement <16 x i32> %1, i32 11
      store i32 %storeval_11_ID, i32 * %ptr_11_ID
      %ptr_12_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 12
      %storeval_12_ID = extractelement <16 x i32> %1, i32 12
      store i32 %storeval_12_ID, i32 * %ptr_12_ID
      %ptr_13_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 13
      %storeval_13_ID = extractelement <16 x i32> %1, i32 13
      store i32 %storeval_13_ID, i32 * %ptr_13_ID
      %ptr_14_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 14
      %storeval_14_ID = extractelement <16 x i32> %1, i32 14
      store i32 %storeval_14_ID, i32 * %ptr_14_ID
      %ptr_15_ID = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 15
      %storeval_15_ID = extractelement <16 x i32> %1, i32 15
      store i32 %storeval_15_ID, i32 * %ptr_15_ID
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      %ptr__id = getelementptr <16 x i32> , <16 x i32> *
 %0, i32 0, i32 %pl_lane
      %storeval__id = extractelement <16 x i32> %1, i32 %pl_lane
      store i32 %storeval__id, i32 * %ptr__id
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}


define void @__masked_store_i64(<16 x i64>* nocapture, <16 x i64>, <16 x i8>) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %2)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %2)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      %ptr_0_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 0
      %storeval_0_ID = extractelement <16 x i64> %1, i32 0
      store i64 %storeval_0_ID, i64 * %ptr_0_ID
      %ptr_1_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 1
      %storeval_1_ID = extractelement <16 x i64> %1, i32 1
      store i64 %storeval_1_ID, i64 * %ptr_1_ID
      %ptr_2_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 2
      %storeval_2_ID = extractelement <16 x i64> %1, i32 2
      store i64 %storeval_2_ID, i64 * %ptr_2_ID
      %ptr_3_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 3
      %storeval_3_ID = extractelement <16 x i64> %1, i32 3
      store i64 %storeval_3_ID, i64 * %ptr_3_ID
      %ptr_4_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 4
      %storeval_4_ID = extractelement <16 x i64> %1, i32 4
      store i64 %storeval_4_ID, i64 * %ptr_4_ID
      %ptr_5_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 5
      %storeval_5_ID = extractelement <16 x i64> %1, i32 5
      store i64 %storeval_5_ID, i64 * %ptr_5_ID
      %ptr_6_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 6
      %storeval_6_ID = extractelement <16 x i64> %1, i32 6
      store i64 %storeval_6_ID, i64 * %ptr_6_ID
      %ptr_7_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 7
      %storeval_7_ID = extractelement <16 x i64> %1, i32 7
      store i64 %storeval_7_ID, i64 * %ptr_7_ID
      %ptr_8_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 8
      %storeval_8_ID = extractelement <16 x i64> %1, i32 8
      store i64 %storeval_8_ID, i64 * %ptr_8_ID
      %ptr_9_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 9
      %storeval_9_ID = extractelement <16 x i64> %1, i32 9
      store i64 %storeval_9_ID, i64 * %ptr_9_ID
      %ptr_10_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 10
      %storeval_10_ID = extractelement <16 x i64> %1, i32 10
      store i64 %storeval_10_ID, i64 * %ptr_10_ID
      %ptr_11_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 11
      %storeval_11_ID = extractelement <16 x i64> %1, i32 11
      store i64 %storeval_11_ID, i64 * %ptr_11_ID
      %ptr_12_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 12
      %storeval_12_ID = extractelement <16 x i64> %1, i32 12
      store i64 %storeval_12_ID, i64 * %ptr_12_ID
      %ptr_13_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 13
      %storeval_13_ID = extractelement <16 x i64> %1, i32 13
      store i64 %storeval_13_ID, i64 * %ptr_13_ID
      %ptr_14_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 14
      %storeval_14_ID = extractelement <16 x i64> %1, i32 14
      store i64 %storeval_14_ID, i64 * %ptr_14_ID
      %ptr_15_ID = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 15
      %storeval_15_ID = extractelement <16 x i64> %1, i32 15
      store i64 %storeval_15_ID, i64 * %ptr_15_ID
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      %ptr__id = getelementptr <16 x i64> , <16 x i64> *
 %0, i32 0, i32 %pl_lane
      %storeval__id = extractelement <16 x i64> %1, i32 %pl_lane
      store i64 %storeval__id, i64 * %ptr__id
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}



define void @__masked_store_float(<16 x float> * nocapture, <16 x float>,
                                  <16 x i8>) nounwind alwaysinline {
  %ptr = bitcast <16 x float> * %0 to <16 x i32> *
  %val = bitcast <16 x float> %1 to <16 x i32>
  call void @__masked_store_i32(<16 x i32> * %ptr, <16 x i32> %val, <16 x i8> %2)
  ret void
}


define void @__masked_store_double(<16 x double> * nocapture, <16 x double>,
                                   <16 x i8>) nounwind alwaysinline {
  %ptr = bitcast <16 x double> * %0 to <16 x i64> *
  %val = bitcast <16 x double> %1 to <16 x i64>
  call void @__masked_store_i64(<16 x i64> * %ptr, <16 x i64> %val, <16 x i8> %2)
  ret void
}

define void @__masked_store_blend_float(<16 x float> * nocapture, <16 x float>,
                                        <16 x i8>) nounwind alwaysinline {
  %ptr = bitcast <16 x float> * %0 to <16 x i32> *
  %val = bitcast <16 x float> %1 to <16 x i32>
  call void @__masked_store_blend_i32(<16 x i32> * %ptr, <16 x i32> %val, <16 x i8> %2)
  ret void
}


define void @__masked_store_blend_double(<16 x double> * nocapture, <16 x double>,
                                         <16 x i8>) nounwind alwaysinline {
  %ptr = bitcast <16 x double> * %0 to <16 x i64> *
  %val = bitcast <16 x double> %1 to <16 x i64>
  call void @__masked_store_blend_i64(<16 x i64> * %ptr, <16 x i64> %val, <16 x i8> %2)
  ret void
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unaligned loads/loads+broadcasts


define <16 x i8> @__masked_load_i8(i8 *, <16 x i8> %mask) nounwind alwaysinline {
entry:
  %mm = call i64 @__movmsk(<16 x i8> %mask)
  
  ; if the first lane and the last lane are on, then it is safe to do a vector load
  ; of the whole thing--what the lanes in the middle want turns out to not matter...
  %mm_and_low = and i64 %mm, 1
  %mm_and_high = and i64 %mm, 32768
  %mm_and_high_shift = lshr i64 %mm_and_high, 15
  %mm_and_low_i1 = trunc i64 %mm_and_low to i1
  %mm_and_high_shift_i1 = trunc i64 %mm_and_high_shift to i1
  %can_vload = and i1 %mm_and_low_i1, %mm_and_high_shift_i1

  %fast32 = call i32 @__fast_masked_vload()
  %fast_i1 = trunc i32 %fast32 to i1
  %can_vload_maybe_fast = or i1 %fast_i1, %can_vload

  ; if we are not able to do a singe vload, we will accumulate lanes in this memory..
  %retptr = alloca <16 x i8>
  %retptr32 = bitcast <16 x i8> * %retptr to i8 *
  br i1 %can_vload_maybe_fast, label %load, label %loop

load: 
  %ptr = bitcast i8 * %0 to <16 x i8> *
  %valall = load <16 x i8>  , <16 x i8>  *
  %ptr, align 1
  ret <16 x i8> %valall

loop:
  ; loop over the lanes and see if each one is on...
  %lane = phi i32 [ 0, %entry ], [ %next_lane, %lane_done ]
  %lane64 = zext i32 %lane to i64
  %lanemask = shl i64 1, %lane64
  %mask_and = and i64 %mm, %lanemask
  %do_lane = icmp ne i64 %mask_and, 0
  br i1 %do_lane, label %load_lane, label %lane_done

load_lane:
  ; yes!  do the load and store the result into the appropriate place in the
  ; allocaed memory above
  %ptr32 = bitcast i8 * %0 to i8 *
  %lane_ptr = getelementptr i8 , i8 *
 %ptr32, i32 %lane
  %val = load i8  , i8  *
  %lane_ptr
  %store_ptr = getelementptr i8 , i8 *
 %retptr32, i32 %lane
  store i8 %val, i8 * %store_ptr
  br label %lane_done

lane_done:
  %next_lane = add i32 %lane, 1
  %done = icmp eq i32 %lane, 15
  br i1 %done, label %return, label %loop

return:
  %r = load <16 x i8>  , <16 x i8>  *
  %retptr
  ret <16 x i8> %r
}


define <16 x i16> @__masked_load_i16(i8 *, <16 x i8> %mask) nounwind alwaysinline {
entry:
  %mm = call i64 @__movmsk(<16 x i8> %mask)
  
  ; if the first lane and the last lane are on, then it is safe to do a vector load
  ; of the whole thing--what the lanes in the middle want turns out to not matter...
  %mm_and_low = and i64 %mm, 1
  %mm_and_high = and i64 %mm, 32768
  %mm_and_high_shift = lshr i64 %mm_and_high, 15
  %mm_and_low_i1 = trunc i64 %mm_and_low to i1
  %mm_and_high_shift_i1 = trunc i64 %mm_and_high_shift to i1
  %can_vload = and i1 %mm_and_low_i1, %mm_and_high_shift_i1

  %fast32 = call i32 @__fast_masked_vload()
  %fast_i1 = trunc i32 %fast32 to i1
  %can_vload_maybe_fast = or i1 %fast_i1, %can_vload

  ; if we are not able to do a singe vload, we will accumulate lanes in this memory..
  %retptr = alloca <16 x i16>
  %retptr32 = bitcast <16 x i16> * %retptr to i16 *
  br i1 %can_vload_maybe_fast, label %load, label %loop

load: 
  %ptr = bitcast i8 * %0 to <16 x i16> *
  %valall = load <16 x i16>  , <16 x i16>  *
  %ptr, align 2
  ret <16 x i16> %valall

loop:
  ; loop over the lanes and see if each one is on...
  %lane = phi i32 [ 0, %entry ], [ %next_lane, %lane_done ]
  %lane64 = zext i32 %lane to i64
  %lanemask = shl i64 1, %lane64
  %mask_and = and i64 %mm, %lanemask
  %do_lane = icmp ne i64 %mask_and, 0
  br i1 %do_lane, label %load_lane, label %lane_done

load_lane:
  ; yes!  do the load and store the result into the appropriate place in the
  ; allocaed memory above
  %ptr32 = bitcast i8 * %0 to i16 *
  %lane_ptr = getelementptr i16 , i16 *
 %ptr32, i32 %lane
  %val = load i16  , i16  *
  %lane_ptr
  %store_ptr = getelementptr i16 , i16 *
 %retptr32, i32 %lane
  store i16 %val, i16 * %store_ptr
  br label %lane_done

lane_done:
  %next_lane = add i32 %lane, 1
  %done = icmp eq i32 %lane, 15
  br i1 %done, label %return, label %loop

return:
  %r = load <16 x i16>  , <16 x i16>  *
  %retptr
  ret <16 x i16> %r
}


define <16 x i32> @__masked_load_i32(i8 *, <16 x i8> %mask) nounwind alwaysinline {
entry:
  %mm = call i64 @__movmsk(<16 x i8> %mask)
  
  ; if the first lane and the last lane are on, then it is safe to do a vector load
  ; of the whole thing--what the lanes in the middle want turns out to not matter...
  %mm_and_low = and i64 %mm, 1
  %mm_and_high = and i64 %mm, 32768
  %mm_and_high_shift = lshr i64 %mm_and_high, 15
  %mm_and_low_i1 = trunc i64 %mm_and_low to i1
  %mm_and_high_shift_i1 = trunc i64 %mm_and_high_shift to i1
  %can_vload = and i1 %mm_and_low_i1, %mm_and_high_shift_i1

  %fast32 = call i32 @__fast_masked_vload()
  %fast_i1 = trunc i32 %fast32 to i1
  %can_vload_maybe_fast = or i1 %fast_i1, %can_vload

  ; if we are not able to do a singe vload, we will accumulate lanes in this memory..
  %retptr = alloca <16 x i32>
  %retptr32 = bitcast <16 x i32> * %retptr to i32 *
  br i1 %can_vload_maybe_fast, label %load, label %loop

load: 
  %ptr = bitcast i8 * %0 to <16 x i32> *
  %valall = load <16 x i32>  , <16 x i32>  *
  %ptr, align 4
  ret <16 x i32> %valall

loop:
  ; loop over the lanes and see if each one is on...
  %lane = phi i32 [ 0, %entry ], [ %next_lane, %lane_done ]
  %lane64 = zext i32 %lane to i64
  %lanemask = shl i64 1, %lane64
  %mask_and = and i64 %mm, %lanemask
  %do_lane = icmp ne i64 %mask_and, 0
  br i1 %do_lane, label %load_lane, label %lane_done

load_lane:
  ; yes!  do the load and store the result into the appropriate place in the
  ; allocaed memory above
  %ptr32 = bitcast i8 * %0 to i32 *
  %lane_ptr = getelementptr i32 , i32 *
 %ptr32, i32 %lane
  %val = load i32  , i32  *
  %lane_ptr
  %store_ptr = getelementptr i32 , i32 *
 %retptr32, i32 %lane
  store i32 %val, i32 * %store_ptr
  br label %lane_done

lane_done:
  %next_lane = add i32 %lane, 1
  %done = icmp eq i32 %lane, 15
  br i1 %done, label %return, label %loop

return:
  %r = load <16 x i32>  , <16 x i32>  *
  %retptr
  ret <16 x i32> %r
}


define <16 x float> @__masked_load_float(i8 *, <16 x i8> %mask) nounwind alwaysinline {
entry:
  %mm = call i64 @__movmsk(<16 x i8> %mask)
  
  ; if the first lane and the last lane are on, then it is safe to do a vector load
  ; of the whole thing--what the lanes in the middle want turns out to not matter...
  %mm_and_low = and i64 %mm, 1
  %mm_and_high = and i64 %mm, 32768
  %mm_and_high_shift = lshr i64 %mm_and_high, 15
  %mm_and_low_i1 = trunc i64 %mm_and_low to i1
  %mm_and_high_shift_i1 = trunc i64 %mm_and_high_shift to i1
  %can_vload = and i1 %mm_and_low_i1, %mm_and_high_shift_i1

  %fast32 = call i32 @__fast_masked_vload()
  %fast_i1 = trunc i32 %fast32 to i1
  %can_vload_maybe_fast = or i1 %fast_i1, %can_vload

  ; if we are not able to do a singe vload, we will accumulate lanes in this memory..
  %retptr = alloca <16 x float>
  %retptr32 = bitcast <16 x float> * %retptr to float *
  br i1 %can_vload_maybe_fast, label %load, label %loop

load: 
  %ptr = bitcast i8 * %0 to <16 x float> *
  %valall = load <16 x float>  , <16 x float>  *
  %ptr, align 4
  ret <16 x float> %valall

loop:
  ; loop over the lanes and see if each one is on...
  %lane = phi i32 [ 0, %entry ], [ %next_lane, %lane_done ]
  %lane64 = zext i32 %lane to i64
  %lanemask = shl i64 1, %lane64
  %mask_and = and i64 %mm, %lanemask
  %do_lane = icmp ne i64 %mask_and, 0
  br i1 %do_lane, label %load_lane, label %lane_done

load_lane:
  ; yes!  do the load and store the result into the appropriate place in the
  ; allocaed memory above
  %ptr32 = bitcast i8 * %0 to float *
  %lane_ptr = getelementptr float , float *
 %ptr32, i32 %lane
  %val = load float  , float  *
  %lane_ptr
  %store_ptr = getelementptr float , float *
 %retptr32, i32 %lane
  store float %val, float * %store_ptr
  br label %lane_done

lane_done:
  %next_lane = add i32 %lane, 1
  %done = icmp eq i32 %lane, 15
  br i1 %done, label %return, label %loop

return:
  %r = load <16 x float>  , <16 x float>  *
  %retptr
  ret <16 x float> %r
}


define <16 x i64> @__masked_load_i64(i8 *, <16 x i8> %mask) nounwind alwaysinline {
entry:
  %mm = call i64 @__movmsk(<16 x i8> %mask)
  
  ; if the first lane and the last lane are on, then it is safe to do a vector load
  ; of the whole thing--what the lanes in the middle want turns out to not matter...
  %mm_and_low = and i64 %mm, 1
  %mm_and_high = and i64 %mm, 32768
  %mm_and_high_shift = lshr i64 %mm_and_high, 15
  %mm_and_low_i1 = trunc i64 %mm_and_low to i1
  %mm_and_high_shift_i1 = trunc i64 %mm_and_high_shift to i1
  %can_vload = and i1 %mm_and_low_i1, %mm_and_high_shift_i1

  %fast32 = call i32 @__fast_masked_vload()
  %fast_i1 = trunc i32 %fast32 to i1
  %can_vload_maybe_fast = or i1 %fast_i1, %can_vload

  ; if we are not able to do a singe vload, we will accumulate lanes in this memory..
  %retptr = alloca <16 x i64>
  %retptr32 = bitcast <16 x i64> * %retptr to i64 *
  br i1 %can_vload_maybe_fast, label %load, label %loop

load: 
  %ptr = bitcast i8 * %0 to <16 x i64> *
  %valall = load <16 x i64>  , <16 x i64>  *
  %ptr, align 8
  ret <16 x i64> %valall

loop:
  ; loop over the lanes and see if each one is on...
  %lane = phi i32 [ 0, %entry ], [ %next_lane, %lane_done ]
  %lane64 = zext i32 %lane to i64
  %lanemask = shl i64 1, %lane64
  %mask_and = and i64 %mm, %lanemask
  %do_lane = icmp ne i64 %mask_and, 0
  br i1 %do_lane, label %load_lane, label %lane_done

load_lane:
  ; yes!  do the load and store the result into the appropriate place in the
  ; allocaed memory above
  %ptr32 = bitcast i8 * %0 to i64 *
  %lane_ptr = getelementptr i64 , i64 *
 %ptr32, i32 %lane
  %val = load i64  , i64  *
  %lane_ptr
  %store_ptr = getelementptr i64 , i64 *
 %retptr32, i32 %lane
  store i64 %val, i64 * %store_ptr
  br label %lane_done

lane_done:
  %next_lane = add i32 %lane, 1
  %done = icmp eq i32 %lane, 15
  br i1 %done, label %return, label %loop

return:
  %r = load <16 x i64>  , <16 x i64>  *
  %retptr
  ret <16 x i64> %r
}


define <16 x double> @__masked_load_double(i8 *, <16 x i8> %mask) nounwind alwaysinline {
entry:
  %mm = call i64 @__movmsk(<16 x i8> %mask)
  
  ; if the first lane and the last lane are on, then it is safe to do a vector load
  ; of the whole thing--what the lanes in the middle want turns out to not matter...
  %mm_and_low = and i64 %mm, 1
  %mm_and_high = and i64 %mm, 32768
  %mm_and_high_shift = lshr i64 %mm_and_high, 15
  %mm_and_low_i1 = trunc i64 %mm_and_low to i1
  %mm_and_high_shift_i1 = trunc i64 %mm_and_high_shift to i1
  %can_vload = and i1 %mm_and_low_i1, %mm_and_high_shift_i1

  %fast32 = call i32 @__fast_masked_vload()
  %fast_i1 = trunc i32 %fast32 to i1
  %can_vload_maybe_fast = or i1 %fast_i1, %can_vload

  ; if we are not able to do a singe vload, we will accumulate lanes in this memory..
  %retptr = alloca <16 x double>
  %retptr32 = bitcast <16 x double> * %retptr to double *
  br i1 %can_vload_maybe_fast, label %load, label %loop

load: 
  %ptr = bitcast i8 * %0 to <16 x double> *
  %valall = load <16 x double>  , <16 x double>  *
  %ptr, align 8
  ret <16 x double> %valall

loop:
  ; loop over the lanes and see if each one is on...
  %lane = phi i32 [ 0, %entry ], [ %next_lane, %lane_done ]
  %lane64 = zext i32 %lane to i64
  %lanemask = shl i64 1, %lane64
  %mask_and = and i64 %mm, %lanemask
  %do_lane = icmp ne i64 %mask_and, 0
  br i1 %do_lane, label %load_lane, label %lane_done

load_lane:
  ; yes!  do the load and store the result into the appropriate place in the
  ; allocaed memory above
  %ptr32 = bitcast i8 * %0 to double *
  %lane_ptr = getelementptr double , double *
 %ptr32, i32 %lane
  %val = load double  , double  *
  %lane_ptr
  %store_ptr = getelementptr double , double *
 %retptr32, i32 %lane
  store double %val, double * %store_ptr
  br label %lane_done

lane_done:
  %next_lane = add i32 %lane, 1
  %done = icmp eq i32 %lane, 15
  br i1 %done, label %return, label %loop

return:
  %r = load <16 x double>  , <16 x double>  *
  %retptr
  ret <16 x double> %r
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gather/scatter

; define these with the macros from stdlib.m4


;; Define the utility function to do the gather operation for a single element
;; of the type
define <16 x i8> @__gather_elt32_i8(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i8 *
  %val = load i8  , i8  *
 %ptrcast
  %updatedret = insertelement <16 x i8> %ret, i8 %val, i32 %lane
  ret <16 x i8> %updatedret
}

define <16 x i8> @__gather_elt64_i8(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset_scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %offset_scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i8 *
  %val = load i8  , i8  *
 %ptrcast
  %updatedret = insertelement <16 x i8> %ret, i8 %val, i32 %lane
  ret <16 x i8> %updatedret
}


define <16 x i8> @__gather_factored_base_offsets32_i8(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                             <16 x i32> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %offsetsPtr
  call void @__masked_store_blend_i32(<16 x i32> * %offsetsPtr, <16 x i32> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i32>  , <16 x i32>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %deltaPtr
  call void @__masked_store_blend_i32(<16 x i32> * %deltaPtr, <16 x i32> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i32>  , <16 x i32>  *
  %deltaPtr

  %ret0 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, <16 x i32> %newOffsets,
                                            i32 %offset_scale, <16 x i32> %newDelta,
                                            <16 x i8> undef, i32 0)
  %ret1 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret0, i32 1)
                    %ret2 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret1, i32 2)
                    %ret3 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret2, i32 3)
                    %ret4 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret3, i32 4)
                    %ret5 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret4, i32 5)
                    %ret6 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret5, i32 6)
                    %ret7 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret6, i32 7)
                    %ret8 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret7, i32 8)
                    %ret9 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret8, i32 9)
                    %ret10 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret9, i32 10)
                    %ret11 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret10, i32 11)
                    %ret12 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret11, i32 12)
                    %ret13 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret12, i32 13)
                    %ret14 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret13, i32 14)
                    %ret15 = call <16 x i8> @__gather_elt32_i8(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i8> %ret14, i32 15)
                    
  ret <16 x i8> %ret15
}

define <16 x i8> @__gather_factored_base_offsets64_i8(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                             <16 x i64> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %offsetsPtr
  call void @__masked_store_blend_i64(<16 x i64> * %offsetsPtr, <16 x i64> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i64>  , <16 x i64>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %deltaPtr
  call void @__masked_store_blend_i64(<16 x i64> * %deltaPtr, <16 x i64> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i64>  , <16 x i64>  *
  %deltaPtr

  %ret0 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, <16 x i64> %newOffsets,
                                            i32 %offset_scale, <16 x i64> %newDelta,
                                            <16 x i8> undef, i32 0)
  %ret1 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret0, i32 1)
                    %ret2 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret1, i32 2)
                    %ret3 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret2, i32 3)
                    %ret4 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret3, i32 4)
                    %ret5 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret4, i32 5)
                    %ret6 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret5, i32 6)
                    %ret7 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret6, i32 7)
                    %ret8 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret7, i32 8)
                    %ret9 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret8, i32 9)
                    %ret10 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret9, i32 10)
                    %ret11 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret10, i32 11)
                    %ret12 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret11, i32 12)
                    %ret13 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret12, i32 13)
                    %ret14 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret13, i32 14)
                    %ret15 = call <16 x i8> @__gather_elt64_i8(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i8> %ret14, i32 15)
                    
  ret <16 x i8> %ret15
}


; fully general 32-bit gather, takes array of pointers encoded as vector of i32s
define <16 x i8> @__gather32_i8(<16 x i32> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i8>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i8 *
  %val_0_ID = load i8  , i8  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 0
  store i8 %val_0_ID, i8 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i8 *
  %val_1_ID = load i8  , i8  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 1
  store i8 %val_1_ID, i8 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i8 *
  %val_2_ID = load i8  , i8  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 2
  store i8 %val_2_ID, i8 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i8 *
  %val_3_ID = load i8  , i8  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 3
  store i8 %val_3_ID, i8 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i8 *
  %val_4_ID = load i8  , i8  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 4
  store i8 %val_4_ID, i8 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i8 *
  %val_5_ID = load i8  , i8  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 5
  store i8 %val_5_ID, i8 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i8 *
  %val_6_ID = load i8  , i8  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 6
  store i8 %val_6_ID, i8 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i8 *
  %val_7_ID = load i8  , i8  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 7
  store i8 %val_7_ID, i8 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i8 *
  %val_8_ID = load i8  , i8  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 8
  store i8 %val_8_ID, i8 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i8 *
  %val_9_ID = load i8  , i8  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 9
  store i8 %val_9_ID, i8 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i8 *
  %val_10_ID = load i8  , i8  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 10
  store i8 %val_10_ID, i8 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i8 *
  %val_11_ID = load i8  , i8  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 11
  store i8 %val_11_ID, i8 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i8 *
  %val_12_ID = load i8  , i8  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 12
  store i8 %val_12_ID, i8 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i8 *
  %val_13_ID = load i8  , i8  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 13
  store i8 %val_13_ID, i8 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i8 *
  %val_14_ID = load i8  , i8  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 14
  store i8 %val_14_ID, i8 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i8 *
  %val_15_ID = load i8  , i8  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 15
  store i8 %val_15_ID, i8 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i8 *
  %val__id = load i8  , i8  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i8 %val__id, i8 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i8>  , <16 x i8>  *
  %ret_ptr
  ret <16 x i8> %ret
}

; fully general 64-bit gather, takes array of pointers encoded as vector of i64s
define <16 x i8> @__gather64_i8(<16 x i64> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i8>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8 *
  %val_0_ID = load i8  , i8  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 0
  store i8 %val_0_ID, i8 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8 *
  %val_1_ID = load i8  , i8  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 1
  store i8 %val_1_ID, i8 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8 *
  %val_2_ID = load i8  , i8  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 2
  store i8 %val_2_ID, i8 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8 *
  %val_3_ID = load i8  , i8  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 3
  store i8 %val_3_ID, i8 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8 *
  %val_4_ID = load i8  , i8  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 4
  store i8 %val_4_ID, i8 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8 *
  %val_5_ID = load i8  , i8  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 5
  store i8 %val_5_ID, i8 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8 *
  %val_6_ID = load i8  , i8  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 6
  store i8 %val_6_ID, i8 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8 *
  %val_7_ID = load i8  , i8  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 7
  store i8 %val_7_ID, i8 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8 *
  %val_8_ID = load i8  , i8  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 8
  store i8 %val_8_ID, i8 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8 *
  %val_9_ID = load i8  , i8  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 9
  store i8 %val_9_ID, i8 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8 *
  %val_10_ID = load i8  , i8  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 10
  store i8 %val_10_ID, i8 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8 *
  %val_11_ID = load i8  , i8  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 11
  store i8 %val_11_ID, i8 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8 *
  %val_12_ID = load i8  , i8  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 12
  store i8 %val_12_ID, i8 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8 *
  %val_13_ID = load i8  , i8  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 13
  store i8 %val_13_ID, i8 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8 *
  %val_14_ID = load i8  , i8  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 14
  store i8 %val_14_ID, i8 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8 *
  %val_15_ID = load i8  , i8  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 15
  store i8 %val_15_ID, i8 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i8 *
  %val__id = load i8  , i8  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i8> , <16 x i8> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i8 %val__id, i8 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i8>  , <16 x i8>  *
  %ret_ptr
  ret <16 x i8> %ret
}




;; Define the utility function to do the gather operation for a single element
;; of the type
define <16 x i16> @__gather_elt32_i16(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i16 *
  %val = load i16  , i16  *
 %ptrcast
  %updatedret = insertelement <16 x i16> %ret, i16 %val, i32 %lane
  ret <16 x i16> %updatedret
}

define <16 x i16> @__gather_elt64_i16(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset_scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %offset_scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i16 *
  %val = load i16  , i16  *
 %ptrcast
  %updatedret = insertelement <16 x i16> %ret, i16 %val, i32 %lane
  ret <16 x i16> %updatedret
}


define <16 x i16> @__gather_factored_base_offsets32_i16(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                             <16 x i32> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %offsetsPtr
  call void @__masked_store_blend_i32(<16 x i32> * %offsetsPtr, <16 x i32> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i32>  , <16 x i32>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %deltaPtr
  call void @__masked_store_blend_i32(<16 x i32> * %deltaPtr, <16 x i32> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i32>  , <16 x i32>  *
  %deltaPtr

  %ret0 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, <16 x i32> %newOffsets,
                                            i32 %offset_scale, <16 x i32> %newDelta,
                                            <16 x i16> undef, i32 0)
  %ret1 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret0, i32 1)
                    %ret2 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret1, i32 2)
                    %ret3 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret2, i32 3)
                    %ret4 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret3, i32 4)
                    %ret5 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret4, i32 5)
                    %ret6 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret5, i32 6)
                    %ret7 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret6, i32 7)
                    %ret8 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret7, i32 8)
                    %ret9 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret8, i32 9)
                    %ret10 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret9, i32 10)
                    %ret11 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret10, i32 11)
                    %ret12 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret11, i32 12)
                    %ret13 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret12, i32 13)
                    %ret14 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret13, i32 14)
                    %ret15 = call <16 x i16> @__gather_elt32_i16(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i16> %ret14, i32 15)
                    
  ret <16 x i16> %ret15
}

define <16 x i16> @__gather_factored_base_offsets64_i16(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                             <16 x i64> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %offsetsPtr
  call void @__masked_store_blend_i64(<16 x i64> * %offsetsPtr, <16 x i64> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i64>  , <16 x i64>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %deltaPtr
  call void @__masked_store_blend_i64(<16 x i64> * %deltaPtr, <16 x i64> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i64>  , <16 x i64>  *
  %deltaPtr

  %ret0 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, <16 x i64> %newOffsets,
                                            i32 %offset_scale, <16 x i64> %newDelta,
                                            <16 x i16> undef, i32 0)
  %ret1 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret0, i32 1)
                    %ret2 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret1, i32 2)
                    %ret3 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret2, i32 3)
                    %ret4 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret3, i32 4)
                    %ret5 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret4, i32 5)
                    %ret6 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret5, i32 6)
                    %ret7 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret6, i32 7)
                    %ret8 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret7, i32 8)
                    %ret9 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret8, i32 9)
                    %ret10 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret9, i32 10)
                    %ret11 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret10, i32 11)
                    %ret12 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret11, i32 12)
                    %ret13 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret12, i32 13)
                    %ret14 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret13, i32 14)
                    %ret15 = call <16 x i16> @__gather_elt64_i16(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i16> %ret14, i32 15)
                    
  ret <16 x i16> %ret15
}


; fully general 32-bit gather, takes array of pointers encoded as vector of i32s
define <16 x i16> @__gather32_i16(<16 x i32> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i16>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i16 *
  %val_0_ID = load i16  , i16  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 0
  store i16 %val_0_ID, i16 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i16 *
  %val_1_ID = load i16  , i16  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 1
  store i16 %val_1_ID, i16 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i16 *
  %val_2_ID = load i16  , i16  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 2
  store i16 %val_2_ID, i16 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i16 *
  %val_3_ID = load i16  , i16  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 3
  store i16 %val_3_ID, i16 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i16 *
  %val_4_ID = load i16  , i16  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 4
  store i16 %val_4_ID, i16 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i16 *
  %val_5_ID = load i16  , i16  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 5
  store i16 %val_5_ID, i16 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i16 *
  %val_6_ID = load i16  , i16  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 6
  store i16 %val_6_ID, i16 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i16 *
  %val_7_ID = load i16  , i16  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 7
  store i16 %val_7_ID, i16 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i16 *
  %val_8_ID = load i16  , i16  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 8
  store i16 %val_8_ID, i16 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i16 *
  %val_9_ID = load i16  , i16  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 9
  store i16 %val_9_ID, i16 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i16 *
  %val_10_ID = load i16  , i16  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 10
  store i16 %val_10_ID, i16 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i16 *
  %val_11_ID = load i16  , i16  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 11
  store i16 %val_11_ID, i16 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i16 *
  %val_12_ID = load i16  , i16  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 12
  store i16 %val_12_ID, i16 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i16 *
  %val_13_ID = load i16  , i16  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 13
  store i16 %val_13_ID, i16 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i16 *
  %val_14_ID = load i16  , i16  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 14
  store i16 %val_14_ID, i16 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i16 *
  %val_15_ID = load i16  , i16  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 15
  store i16 %val_15_ID, i16 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i16 *
  %val__id = load i16  , i16  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i16 %val__id, i16 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i16>  , <16 x i16>  *
  %ret_ptr
  ret <16 x i16> %ret
}

; fully general 64-bit gather, takes array of pointers encoded as vector of i64s
define <16 x i16> @__gather64_i16(<16 x i64> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i16>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i16 *
  %val_0_ID = load i16  , i16  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 0
  store i16 %val_0_ID, i16 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i16 *
  %val_1_ID = load i16  , i16  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 1
  store i16 %val_1_ID, i16 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i16 *
  %val_2_ID = load i16  , i16  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 2
  store i16 %val_2_ID, i16 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i16 *
  %val_3_ID = load i16  , i16  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 3
  store i16 %val_3_ID, i16 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i16 *
  %val_4_ID = load i16  , i16  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 4
  store i16 %val_4_ID, i16 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i16 *
  %val_5_ID = load i16  , i16  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 5
  store i16 %val_5_ID, i16 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i16 *
  %val_6_ID = load i16  , i16  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 6
  store i16 %val_6_ID, i16 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i16 *
  %val_7_ID = load i16  , i16  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 7
  store i16 %val_7_ID, i16 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i16 *
  %val_8_ID = load i16  , i16  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 8
  store i16 %val_8_ID, i16 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i16 *
  %val_9_ID = load i16  , i16  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 9
  store i16 %val_9_ID, i16 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i16 *
  %val_10_ID = load i16  , i16  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 10
  store i16 %val_10_ID, i16 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i16 *
  %val_11_ID = load i16  , i16  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 11
  store i16 %val_11_ID, i16 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i16 *
  %val_12_ID = load i16  , i16  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 12
  store i16 %val_12_ID, i16 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i16 *
  %val_13_ID = load i16  , i16  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 13
  store i16 %val_13_ID, i16 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i16 *
  %val_14_ID = load i16  , i16  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 14
  store i16 %val_14_ID, i16 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i16 *
  %val_15_ID = load i16  , i16  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 15
  store i16 %val_15_ID, i16 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i16 *
  %val__id = load i16  , i16  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i16> , <16 x i16> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i16 %val__id, i16 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i16>  , <16 x i16>  *
  %ret_ptr
  ret <16 x i16> %ret
}




;; Define the utility function to do the gather operation for a single element
;; of the type
define <16 x i32> @__gather_elt32_i32(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i32 *
  %val = load i32  , i32  *
 %ptrcast
  %updatedret = insertelement <16 x i32> %ret, i32 %val, i32 %lane
  ret <16 x i32> %updatedret
}

define <16 x i32> @__gather_elt64_i32(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset_scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %offset_scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i32 *
  %val = load i32  , i32  *
 %ptrcast
  %updatedret = insertelement <16 x i32> %ret, i32 %val, i32 %lane
  ret <16 x i32> %updatedret
}


define <16 x i32> @__gather_factored_base_offsets32_i32(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                             <16 x i32> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %offsetsPtr
  call void @__masked_store_blend_i32(<16 x i32> * %offsetsPtr, <16 x i32> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i32>  , <16 x i32>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %deltaPtr
  call void @__masked_store_blend_i32(<16 x i32> * %deltaPtr, <16 x i32> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i32>  , <16 x i32>  *
  %deltaPtr

  %ret0 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, <16 x i32> %newOffsets,
                                            i32 %offset_scale, <16 x i32> %newDelta,
                                            <16 x i32> undef, i32 0)
  %ret1 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret0, i32 1)
                    %ret2 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret1, i32 2)
                    %ret3 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret2, i32 3)
                    %ret4 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret3, i32 4)
                    %ret5 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret4, i32 5)
                    %ret6 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret5, i32 6)
                    %ret7 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret6, i32 7)
                    %ret8 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret7, i32 8)
                    %ret9 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret8, i32 9)
                    %ret10 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret9, i32 10)
                    %ret11 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret10, i32 11)
                    %ret12 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret11, i32 12)
                    %ret13 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret12, i32 13)
                    %ret14 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret13, i32 14)
                    %ret15 = call <16 x i32> @__gather_elt32_i32(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i32> %ret14, i32 15)
                    
  ret <16 x i32> %ret15
}

define <16 x i32> @__gather_factored_base_offsets64_i32(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                             <16 x i64> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %offsetsPtr
  call void @__masked_store_blend_i64(<16 x i64> * %offsetsPtr, <16 x i64> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i64>  , <16 x i64>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %deltaPtr
  call void @__masked_store_blend_i64(<16 x i64> * %deltaPtr, <16 x i64> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i64>  , <16 x i64>  *
  %deltaPtr

  %ret0 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, <16 x i64> %newOffsets,
                                            i32 %offset_scale, <16 x i64> %newDelta,
                                            <16 x i32> undef, i32 0)
  %ret1 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret0, i32 1)
                    %ret2 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret1, i32 2)
                    %ret3 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret2, i32 3)
                    %ret4 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret3, i32 4)
                    %ret5 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret4, i32 5)
                    %ret6 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret5, i32 6)
                    %ret7 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret6, i32 7)
                    %ret8 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret7, i32 8)
                    %ret9 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret8, i32 9)
                    %ret10 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret9, i32 10)
                    %ret11 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret10, i32 11)
                    %ret12 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret11, i32 12)
                    %ret13 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret12, i32 13)
                    %ret14 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret13, i32 14)
                    %ret15 = call <16 x i32> @__gather_elt64_i32(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i32> %ret14, i32 15)
                    
  ret <16 x i32> %ret15
}


; fully general 32-bit gather, takes array of pointers encoded as vector of i32s
define <16 x i32> @__gather32_i32(<16 x i32> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i32>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i32 *
  %val_0_ID = load i32  , i32  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 0
  store i32 %val_0_ID, i32 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i32 *
  %val_1_ID = load i32  , i32  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 1
  store i32 %val_1_ID, i32 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i32 *
  %val_2_ID = load i32  , i32  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 2
  store i32 %val_2_ID, i32 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i32 *
  %val_3_ID = load i32  , i32  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 3
  store i32 %val_3_ID, i32 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i32 *
  %val_4_ID = load i32  , i32  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 4
  store i32 %val_4_ID, i32 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i32 *
  %val_5_ID = load i32  , i32  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 5
  store i32 %val_5_ID, i32 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i32 *
  %val_6_ID = load i32  , i32  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 6
  store i32 %val_6_ID, i32 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i32 *
  %val_7_ID = load i32  , i32  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 7
  store i32 %val_7_ID, i32 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i32 *
  %val_8_ID = load i32  , i32  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 8
  store i32 %val_8_ID, i32 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i32 *
  %val_9_ID = load i32  , i32  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 9
  store i32 %val_9_ID, i32 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i32 *
  %val_10_ID = load i32  , i32  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 10
  store i32 %val_10_ID, i32 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i32 *
  %val_11_ID = load i32  , i32  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 11
  store i32 %val_11_ID, i32 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i32 *
  %val_12_ID = load i32  , i32  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 12
  store i32 %val_12_ID, i32 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i32 *
  %val_13_ID = load i32  , i32  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 13
  store i32 %val_13_ID, i32 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i32 *
  %val_14_ID = load i32  , i32  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 14
  store i32 %val_14_ID, i32 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i32 *
  %val_15_ID = load i32  , i32  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 15
  store i32 %val_15_ID, i32 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i32 *
  %val__id = load i32  , i32  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i32 %val__id, i32 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i32>  , <16 x i32>  *
  %ret_ptr
  ret <16 x i32> %ret
}

; fully general 64-bit gather, takes array of pointers encoded as vector of i64s
define <16 x i32> @__gather64_i32(<16 x i64> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i32>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i32 *
  %val_0_ID = load i32  , i32  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 0
  store i32 %val_0_ID, i32 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i32 *
  %val_1_ID = load i32  , i32  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 1
  store i32 %val_1_ID, i32 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i32 *
  %val_2_ID = load i32  , i32  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 2
  store i32 %val_2_ID, i32 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i32 *
  %val_3_ID = load i32  , i32  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 3
  store i32 %val_3_ID, i32 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i32 *
  %val_4_ID = load i32  , i32  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 4
  store i32 %val_4_ID, i32 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i32 *
  %val_5_ID = load i32  , i32  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 5
  store i32 %val_5_ID, i32 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i32 *
  %val_6_ID = load i32  , i32  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 6
  store i32 %val_6_ID, i32 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i32 *
  %val_7_ID = load i32  , i32  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 7
  store i32 %val_7_ID, i32 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i32 *
  %val_8_ID = load i32  , i32  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 8
  store i32 %val_8_ID, i32 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i32 *
  %val_9_ID = load i32  , i32  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 9
  store i32 %val_9_ID, i32 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i32 *
  %val_10_ID = load i32  , i32  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 10
  store i32 %val_10_ID, i32 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i32 *
  %val_11_ID = load i32  , i32  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 11
  store i32 %val_11_ID, i32 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i32 *
  %val_12_ID = load i32  , i32  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 12
  store i32 %val_12_ID, i32 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i32 *
  %val_13_ID = load i32  , i32  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 13
  store i32 %val_13_ID, i32 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i32 *
  %val_14_ID = load i32  , i32  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 14
  store i32 %val_14_ID, i32 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i32 *
  %val_15_ID = load i32  , i32  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 15
  store i32 %val_15_ID, i32 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i32 *
  %val__id = load i32  , i32  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i32> , <16 x i32> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i32 %val__id, i32 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i32>  , <16 x i32>  *
  %ret_ptr
  ret <16 x i32> %ret
}




;; Define the utility function to do the gather operation for a single element
;; of the type
define <16 x float> @__gather_elt32_float(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to float *
  %val = load float  , float  *
 %ptrcast
  %updatedret = insertelement <16 x float> %ret, float %val, i32 %lane
  ret <16 x float> %updatedret
}

define <16 x float> @__gather_elt64_float(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset_scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %offset_scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to float *
  %val = load float  , float  *
 %ptrcast
  %updatedret = insertelement <16 x float> %ret, float %val, i32 %lane
  ret <16 x float> %updatedret
}


define <16 x float> @__gather_factored_base_offsets32_float(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                             <16 x i32> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %offsetsPtr
  call void @__masked_store_blend_i32(<16 x i32> * %offsetsPtr, <16 x i32> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i32>  , <16 x i32>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %deltaPtr
  call void @__masked_store_blend_i32(<16 x i32> * %deltaPtr, <16 x i32> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i32>  , <16 x i32>  *
  %deltaPtr

  %ret0 = call <16 x float> @__gather_elt32_float(i8 * %ptr, <16 x i32> %newOffsets,
                                            i32 %offset_scale, <16 x i32> %newDelta,
                                            <16 x float> undef, i32 0)
  %ret1 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret0, i32 1)
                    %ret2 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret1, i32 2)
                    %ret3 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret2, i32 3)
                    %ret4 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret3, i32 4)
                    %ret5 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret4, i32 5)
                    %ret6 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret5, i32 6)
                    %ret7 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret6, i32 7)
                    %ret8 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret7, i32 8)
                    %ret9 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret8, i32 9)
                    %ret10 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret9, i32 10)
                    %ret11 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret10, i32 11)
                    %ret12 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret11, i32 12)
                    %ret13 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret12, i32 13)
                    %ret14 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret13, i32 14)
                    %ret15 = call <16 x float> @__gather_elt32_float(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x float> %ret14, i32 15)
                    
  ret <16 x float> %ret15
}

define <16 x float> @__gather_factored_base_offsets64_float(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                             <16 x i64> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %offsetsPtr
  call void @__masked_store_blend_i64(<16 x i64> * %offsetsPtr, <16 x i64> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i64>  , <16 x i64>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %deltaPtr
  call void @__masked_store_blend_i64(<16 x i64> * %deltaPtr, <16 x i64> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i64>  , <16 x i64>  *
  %deltaPtr

  %ret0 = call <16 x float> @__gather_elt64_float(i8 * %ptr, <16 x i64> %newOffsets,
                                            i32 %offset_scale, <16 x i64> %newDelta,
                                            <16 x float> undef, i32 0)
  %ret1 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret0, i32 1)
                    %ret2 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret1, i32 2)
                    %ret3 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret2, i32 3)
                    %ret4 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret3, i32 4)
                    %ret5 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret4, i32 5)
                    %ret6 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret5, i32 6)
                    %ret7 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret6, i32 7)
                    %ret8 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret7, i32 8)
                    %ret9 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret8, i32 9)
                    %ret10 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret9, i32 10)
                    %ret11 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret10, i32 11)
                    %ret12 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret11, i32 12)
                    %ret13 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret12, i32 13)
                    %ret14 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret13, i32 14)
                    %ret15 = call <16 x float> @__gather_elt64_float(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x float> %ret14, i32 15)
                    
  ret <16 x float> %ret15
}


; fully general 32-bit gather, takes array of pointers encoded as vector of i32s
define <16 x float> @__gather32_float(<16 x i32> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x float>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to float *
  %val_0_ID = load float  , float  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 0
  store float %val_0_ID, float * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to float *
  %val_1_ID = load float  , float  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 1
  store float %val_1_ID, float * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to float *
  %val_2_ID = load float  , float  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 2
  store float %val_2_ID, float * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to float *
  %val_3_ID = load float  , float  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 3
  store float %val_3_ID, float * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to float *
  %val_4_ID = load float  , float  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 4
  store float %val_4_ID, float * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to float *
  %val_5_ID = load float  , float  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 5
  store float %val_5_ID, float * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to float *
  %val_6_ID = load float  , float  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 6
  store float %val_6_ID, float * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to float *
  %val_7_ID = load float  , float  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 7
  store float %val_7_ID, float * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to float *
  %val_8_ID = load float  , float  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 8
  store float %val_8_ID, float * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to float *
  %val_9_ID = load float  , float  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 9
  store float %val_9_ID, float * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to float *
  %val_10_ID = load float  , float  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 10
  store float %val_10_ID, float * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to float *
  %val_11_ID = load float  , float  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 11
  store float %val_11_ID, float * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to float *
  %val_12_ID = load float  , float  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 12
  store float %val_12_ID, float * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to float *
  %val_13_ID = load float  , float  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 13
  store float %val_13_ID, float * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to float *
  %val_14_ID = load float  , float  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 14
  store float %val_14_ID, float * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to float *
  %val_15_ID = load float  , float  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 15
  store float %val_15_ID, float * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to float *
  %val__id = load float  , float  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 %pl_lane
  store float %val__id, float * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x float>  , <16 x float>  *
  %ret_ptr
  ret <16 x float> %ret
}

; fully general 64-bit gather, takes array of pointers encoded as vector of i64s
define <16 x float> @__gather64_float(<16 x i64> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x float>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to float *
  %val_0_ID = load float  , float  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 0
  store float %val_0_ID, float * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to float *
  %val_1_ID = load float  , float  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 1
  store float %val_1_ID, float * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to float *
  %val_2_ID = load float  , float  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 2
  store float %val_2_ID, float * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to float *
  %val_3_ID = load float  , float  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 3
  store float %val_3_ID, float * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to float *
  %val_4_ID = load float  , float  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 4
  store float %val_4_ID, float * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to float *
  %val_5_ID = load float  , float  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 5
  store float %val_5_ID, float * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to float *
  %val_6_ID = load float  , float  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 6
  store float %val_6_ID, float * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to float *
  %val_7_ID = load float  , float  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 7
  store float %val_7_ID, float * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to float *
  %val_8_ID = load float  , float  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 8
  store float %val_8_ID, float * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to float *
  %val_9_ID = load float  , float  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 9
  store float %val_9_ID, float * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to float *
  %val_10_ID = load float  , float  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 10
  store float %val_10_ID, float * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to float *
  %val_11_ID = load float  , float  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 11
  store float %val_11_ID, float * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to float *
  %val_12_ID = load float  , float  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 12
  store float %val_12_ID, float * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to float *
  %val_13_ID = load float  , float  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 13
  store float %val_13_ID, float * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to float *
  %val_14_ID = load float  , float  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 14
  store float %val_14_ID, float * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to float *
  %val_15_ID = load float  , float  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 15
  store float %val_15_ID, float * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to float *
  %val__id = load float  , float  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x float> , <16 x float> *
 %ret_ptr, i32 0, i32 %pl_lane
  store float %val__id, float * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x float>  , <16 x float>  *
  %ret_ptr
  ret <16 x float> %ret
}




;; Define the utility function to do the gather operation for a single element
;; of the type
define <16 x i64> @__gather_elt32_i64(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i64 *
  %val = load i64  , i64  *
 %ptrcast
  %updatedret = insertelement <16 x i64> %ret, i64 %val, i32 %lane
  ret <16 x i64> %updatedret
}

define <16 x i64> @__gather_elt64_i64(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset_scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %offset_scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to i64 *
  %val = load i64  , i64  *
 %ptrcast
  %updatedret = insertelement <16 x i64> %ret, i64 %val, i32 %lane
  ret <16 x i64> %updatedret
}


define <16 x i64> @__gather_factored_base_offsets32_i64(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                             <16 x i32> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %offsetsPtr
  call void @__masked_store_blend_i32(<16 x i32> * %offsetsPtr, <16 x i32> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i32>  , <16 x i32>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %deltaPtr
  call void @__masked_store_blend_i32(<16 x i32> * %deltaPtr, <16 x i32> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i32>  , <16 x i32>  *
  %deltaPtr

  %ret0 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, <16 x i32> %newOffsets,
                                            i32 %offset_scale, <16 x i32> %newDelta,
                                            <16 x i64> undef, i32 0)
  %ret1 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret0, i32 1)
                    %ret2 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret1, i32 2)
                    %ret3 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret2, i32 3)
                    %ret4 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret3, i32 4)
                    %ret5 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret4, i32 5)
                    %ret6 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret5, i32 6)
                    %ret7 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret6, i32 7)
                    %ret8 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret7, i32 8)
                    %ret9 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret8, i32 9)
                    %ret10 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret9, i32 10)
                    %ret11 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret10, i32 11)
                    %ret12 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret11, i32 12)
                    %ret13 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret12, i32 13)
                    %ret14 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret13, i32 14)
                    %ret15 = call <16 x i64> @__gather_elt32_i64(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x i64> %ret14, i32 15)
                    
  ret <16 x i64> %ret15
}

define <16 x i64> @__gather_factored_base_offsets64_i64(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                             <16 x i64> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %offsetsPtr
  call void @__masked_store_blend_i64(<16 x i64> * %offsetsPtr, <16 x i64> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i64>  , <16 x i64>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %deltaPtr
  call void @__masked_store_blend_i64(<16 x i64> * %deltaPtr, <16 x i64> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i64>  , <16 x i64>  *
  %deltaPtr

  %ret0 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, <16 x i64> %newOffsets,
                                            i32 %offset_scale, <16 x i64> %newDelta,
                                            <16 x i64> undef, i32 0)
  %ret1 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret0, i32 1)
                    %ret2 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret1, i32 2)
                    %ret3 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret2, i32 3)
                    %ret4 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret3, i32 4)
                    %ret5 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret4, i32 5)
                    %ret6 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret5, i32 6)
                    %ret7 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret6, i32 7)
                    %ret8 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret7, i32 8)
                    %ret9 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret8, i32 9)
                    %ret10 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret9, i32 10)
                    %ret11 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret10, i32 11)
                    %ret12 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret11, i32 12)
                    %ret13 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret12, i32 13)
                    %ret14 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret13, i32 14)
                    %ret15 = call <16 x i64> @__gather_elt64_i64(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x i64> %ret14, i32 15)
                    
  ret <16 x i64> %ret15
}


; fully general 32-bit gather, takes array of pointers encoded as vector of i32s
define <16 x i64> @__gather32_i64(<16 x i32> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i64>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i64 *
  %val_0_ID = load i64  , i64  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 0
  store i64 %val_0_ID, i64 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i64 *
  %val_1_ID = load i64  , i64  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 1
  store i64 %val_1_ID, i64 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i64 *
  %val_2_ID = load i64  , i64  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 2
  store i64 %val_2_ID, i64 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i64 *
  %val_3_ID = load i64  , i64  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 3
  store i64 %val_3_ID, i64 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i64 *
  %val_4_ID = load i64  , i64  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 4
  store i64 %val_4_ID, i64 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i64 *
  %val_5_ID = load i64  , i64  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 5
  store i64 %val_5_ID, i64 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i64 *
  %val_6_ID = load i64  , i64  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 6
  store i64 %val_6_ID, i64 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i64 *
  %val_7_ID = load i64  , i64  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 7
  store i64 %val_7_ID, i64 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i64 *
  %val_8_ID = load i64  , i64  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 8
  store i64 %val_8_ID, i64 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i64 *
  %val_9_ID = load i64  , i64  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 9
  store i64 %val_9_ID, i64 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i64 *
  %val_10_ID = load i64  , i64  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 10
  store i64 %val_10_ID, i64 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i64 *
  %val_11_ID = load i64  , i64  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 11
  store i64 %val_11_ID, i64 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i64 *
  %val_12_ID = load i64  , i64  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 12
  store i64 %val_12_ID, i64 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i64 *
  %val_13_ID = load i64  , i64  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 13
  store i64 %val_13_ID, i64 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i64 *
  %val_14_ID = load i64  , i64  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 14
  store i64 %val_14_ID, i64 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i64 *
  %val_15_ID = load i64  , i64  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 15
  store i64 %val_15_ID, i64 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i64 *
  %val__id = load i64  , i64  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i64 %val__id, i64 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i64>  , <16 x i64>  *
  %ret_ptr
  ret <16 x i64> %ret
}

; fully general 64-bit gather, takes array of pointers encoded as vector of i64s
define <16 x i64> @__gather64_i64(<16 x i64> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x i64>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i64 *
  %val_0_ID = load i64  , i64  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 0
  store i64 %val_0_ID, i64 * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i64 *
  %val_1_ID = load i64  , i64  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 1
  store i64 %val_1_ID, i64 * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i64 *
  %val_2_ID = load i64  , i64  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 2
  store i64 %val_2_ID, i64 * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i64 *
  %val_3_ID = load i64  , i64  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 3
  store i64 %val_3_ID, i64 * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i64 *
  %val_4_ID = load i64  , i64  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 4
  store i64 %val_4_ID, i64 * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i64 *
  %val_5_ID = load i64  , i64  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 5
  store i64 %val_5_ID, i64 * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i64 *
  %val_6_ID = load i64  , i64  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 6
  store i64 %val_6_ID, i64 * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i64 *
  %val_7_ID = load i64  , i64  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 7
  store i64 %val_7_ID, i64 * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i64 *
  %val_8_ID = load i64  , i64  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 8
  store i64 %val_8_ID, i64 * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i64 *
  %val_9_ID = load i64  , i64  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 9
  store i64 %val_9_ID, i64 * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i64 *
  %val_10_ID = load i64  , i64  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 10
  store i64 %val_10_ID, i64 * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i64 *
  %val_11_ID = load i64  , i64  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 11
  store i64 %val_11_ID, i64 * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i64 *
  %val_12_ID = load i64  , i64  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 12
  store i64 %val_12_ID, i64 * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i64 *
  %val_13_ID = load i64  , i64  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 13
  store i64 %val_13_ID, i64 * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i64 *
  %val_14_ID = load i64  , i64  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 14
  store i64 %val_14_ID, i64 * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i64 *
  %val_15_ID = load i64  , i64  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 15
  store i64 %val_15_ID, i64 * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i64 *
  %val__id = load i64  , i64  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x i64> , <16 x i64> *
 %ret_ptr, i32 0, i32 %pl_lane
  store i64 %val__id, i64 * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x i64>  , <16 x i64>  *
  %ret_ptr
  ret <16 x i64> %ret
}




;; Define the utility function to do the gather operation for a single element
;; of the type
define <16 x double> @__gather_elt32_double(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to double *
  %val = load double  , double  *
 %ptrcast
  %updatedret = insertelement <16 x double> %ret, double %val, i32 %lane
  ret <16 x double> %updatedret
}

define <16 x double> @__gather_elt64_double(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %ret,
                                    i32 %lane) nounwind readonly alwaysinline {
  ; compute address for this one from the base
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset_scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %offset_scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  ; load value and insert into returned value
  %ptrcast = bitcast i8 * %finalptr to double *
  %val = load double  , double  *
 %ptrcast
  %updatedret = insertelement <16 x double> %ret, double %val, i32 %lane
  ret <16 x double> %updatedret
}


define <16 x double> @__gather_factored_base_offsets32_double(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                             <16 x i32> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %offsetsPtr
  call void @__masked_store_blend_i32(<16 x i32> * %offsetsPtr, <16 x i32> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i32>  , <16 x i32>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i32>
  store <16 x i32> zeroinitializer, <16 x i32> * %deltaPtr
  call void @__masked_store_blend_i32(<16 x i32> * %deltaPtr, <16 x i32> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i32>  , <16 x i32>  *
  %deltaPtr

  %ret0 = call <16 x double> @__gather_elt32_double(i8 * %ptr, <16 x i32> %newOffsets,
                                            i32 %offset_scale, <16 x i32> %newDelta,
                                            <16 x double> undef, i32 0)
  %ret1 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret0, i32 1)
                    %ret2 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret1, i32 2)
                    %ret3 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret2, i32 3)
                    %ret4 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret3, i32 4)
                    %ret5 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret4, i32 5)
                    %ret6 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret5, i32 6)
                    %ret7 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret6, i32 7)
                    %ret8 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret7, i32 8)
                    %ret9 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret8, i32 9)
                    %ret10 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret9, i32 10)
                    %ret11 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret10, i32 11)
                    %ret12 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret11, i32 12)
                    %ret13 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret12, i32 13)
                    %ret14 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret13, i32 14)
                    %ret15 = call <16 x double> @__gather_elt32_double(i8 * %ptr, 
                                <16 x i32> %newOffsets, i32 %offset_scale, <16 x i32> %newDelta,
                                <16 x double> %ret14, i32 15)
                    
  ret <16 x double> %ret15
}

define <16 x double> @__gather_factored_base_offsets64_double(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                             <16 x i64> %offset_delta,
                                             <16 x i8> %vecmask) nounwind readonly alwaysinline {
  ; We can be clever and avoid the per-lane stuff for gathers if we are willing
  ; to require that the 0th element of the array being gathered from is always
  ; legal to read from (and we do indeed require that, given the benefits!) 
  ;
  ; Set the offset to zero for lanes that are off
  %offsetsPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %offsetsPtr
  call void @__masked_store_blend_i64(<16 x i64> * %offsetsPtr, <16 x i64> %offsets, 
                                      <16 x i8> %vecmask)
  %newOffsets = load <16 x i64>  , <16 x i64>  *
  %offsetsPtr

  %deltaPtr = alloca <16 x i64>
  store <16 x i64> zeroinitializer, <16 x i64> * %deltaPtr
  call void @__masked_store_blend_i64(<16 x i64> * %deltaPtr, <16 x i64> %offset_delta, 
                                      <16 x i8> %vecmask)
  %newDelta = load <16 x i64>  , <16 x i64>  *
  %deltaPtr

  %ret0 = call <16 x double> @__gather_elt64_double(i8 * %ptr, <16 x i64> %newOffsets,
                                            i32 %offset_scale, <16 x i64> %newDelta,
                                            <16 x double> undef, i32 0)
  %ret1 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret0, i32 1)
                    %ret2 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret1, i32 2)
                    %ret3 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret2, i32 3)
                    %ret4 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret3, i32 4)
                    %ret5 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret4, i32 5)
                    %ret6 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret5, i32 6)
                    %ret7 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret6, i32 7)
                    %ret8 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret7, i32 8)
                    %ret9 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret8, i32 9)
                    %ret10 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret9, i32 10)
                    %ret11 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret10, i32 11)
                    %ret12 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret11, i32 12)
                    %ret13 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret12, i32 13)
                    %ret14 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret13, i32 14)
                    %ret15 = call <16 x double> @__gather_elt64_double(i8 * %ptr, 
                                <16 x i64> %newOffsets, i32 %offset_scale, <16 x i64> %newDelta,
                                <16 x double> %ret14, i32 15)
                    
  ret <16 x double> %ret15
}


; fully general 32-bit gather, takes array of pointers encoded as vector of i32s
define <16 x double> @__gather32_double(<16 x i32> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x double>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to double *
  %val_0_ID = load double  , double  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 0
  store double %val_0_ID, double * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to double *
  %val_1_ID = load double  , double  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 1
  store double %val_1_ID, double * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to double *
  %val_2_ID = load double  , double  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 2
  store double %val_2_ID, double * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to double *
  %val_3_ID = load double  , double  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 3
  store double %val_3_ID, double * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to double *
  %val_4_ID = load double  , double  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 4
  store double %val_4_ID, double * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to double *
  %val_5_ID = load double  , double  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 5
  store double %val_5_ID, double * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to double *
  %val_6_ID = load double  , double  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 6
  store double %val_6_ID, double * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to double *
  %val_7_ID = load double  , double  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 7
  store double %val_7_ID, double * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to double *
  %val_8_ID = load double  , double  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 8
  store double %val_8_ID, double * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to double *
  %val_9_ID = load double  , double  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 9
  store double %val_9_ID, double * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to double *
  %val_10_ID = load double  , double  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 10
  store double %val_10_ID, double * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to double *
  %val_11_ID = load double  , double  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 11
  store double %val_11_ID, double * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to double *
  %val_12_ID = load double  , double  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 12
  store double %val_12_ID, double * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to double *
  %val_13_ID = load double  , double  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 13
  store double %val_13_ID, double * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to double *
  %val_14_ID = load double  , double  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 14
  store double %val_14_ID, double * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to double *
  %val_15_ID = load double  , double  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 15
  store double %val_15_ID, double * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to double *
  %val__id = load double  , double  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 %pl_lane
  store double %val__id, double * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x double>  , <16 x double>  *
  %ret_ptr
  ret <16 x double> %ret
}

; fully general 64-bit gather, takes array of pointers encoded as vector of i64s
define <16 x double> @__gather64_double(<16 x i64> %ptrs, 
                                   <16 x i8> %vecmask) nounwind readonly alwaysinline {
  %ret_ptr = alloca <16 x double>
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %vecmask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %vecmask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to double *
  %val_0_ID = load double  , double  *
  %ptr_0_ID
  %store_ptr_0_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 0
  store double %val_0_ID, double * %store_ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to double *
  %val_1_ID = load double  , double  *
  %ptr_1_ID
  %store_ptr_1_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 1
  store double %val_1_ID, double * %store_ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to double *
  %val_2_ID = load double  , double  *
  %ptr_2_ID
  %store_ptr_2_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 2
  store double %val_2_ID, double * %store_ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to double *
  %val_3_ID = load double  , double  *
  %ptr_3_ID
  %store_ptr_3_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 3
  store double %val_3_ID, double * %store_ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to double *
  %val_4_ID = load double  , double  *
  %ptr_4_ID
  %store_ptr_4_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 4
  store double %val_4_ID, double * %store_ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to double *
  %val_5_ID = load double  , double  *
  %ptr_5_ID
  %store_ptr_5_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 5
  store double %val_5_ID, double * %store_ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to double *
  %val_6_ID = load double  , double  *
  %ptr_6_ID
  %store_ptr_6_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 6
  store double %val_6_ID, double * %store_ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to double *
  %val_7_ID = load double  , double  *
  %ptr_7_ID
  %store_ptr_7_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 7
  store double %val_7_ID, double * %store_ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to double *
  %val_8_ID = load double  , double  *
  %ptr_8_ID
  %store_ptr_8_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 8
  store double %val_8_ID, double * %store_ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to double *
  %val_9_ID = load double  , double  *
  %ptr_9_ID
  %store_ptr_9_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 9
  store double %val_9_ID, double * %store_ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to double *
  %val_10_ID = load double  , double  *
  %ptr_10_ID
  %store_ptr_10_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 10
  store double %val_10_ID, double * %store_ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to double *
  %val_11_ID = load double  , double  *
  %ptr_11_ID
  %store_ptr_11_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 11
  store double %val_11_ID, double * %store_ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to double *
  %val_12_ID = load double  , double  *
  %ptr_12_ID
  %store_ptr_12_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 12
  store double %val_12_ID, double * %store_ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to double *
  %val_13_ID = load double  , double  *
  %ptr_13_ID
  %store_ptr_13_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 13
  store double %val_13_ID, double * %store_ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to double *
  %val_14_ID = load double  , double  *
  %ptr_14_ID
  %store_ptr_14_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 14
  store double %val_14_ID, double * %store_ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to double *
  %val_15_ID = load double  , double  *
  %ptr_15_ID
  %store_ptr_15_ID = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 15
  store double %val_15_ID, double * %store_ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to double *
  %val__id = load double  , double  *
  %ptr__id
  %store_ptr__id = getelementptr <16 x double> , <16 x double> *
 %ret_ptr, i32 0, i32 %pl_lane
  store double %val__id, double * %store_ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:


  %ret = load <16 x double>  , <16 x double>  *
  %ret_ptr
  ret <16 x double> %ret
}





;; Define the function that descripes the work to do to scatter a single
;; value
define void @__scatter_elt32_i8(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                <16 x i32> %offset_delta, <16 x i8> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i8 *
  %storeval = extractelement <16 x i8> %values, i32 %lane
  store i8 %storeval, i8 * %ptrcast
  ret void
}

define void @__scatter_elt64_i8(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                <16 x i64> %offset_delta, <16 x i8> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i8 *
  %storeval = extractelement <16 x i8> %values, i32 %lane
  store i8 %storeval, i8 * %ptrcast
  ret void
}

define void @__scatter_factored_base_offsets32_i8(i8* %base, <16 x i32> %offsets, i32 %offset_scale,
                                         <16 x i32> %offset_delta, <16 x i8> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 0)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 1)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 2)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 3)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 4)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 5)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 6)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 7)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 8)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 9)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 10)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 11)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 12)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 13)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 14)
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt32_i8(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i8> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

define void @__scatter_factored_base_offsets64_i8(i8* %base, <16 x i64> %offsets, i32 %offset_scale,
                                         <16 x i64> %offset_delta, <16 x i8> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 0)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 1)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 2)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 3)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 4)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 5)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 6)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 7)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 8)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 9)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 10)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 11)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 12)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 13)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 14)
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt64_i8(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i8> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 32-bit scatter, takes array of pointers encoded as vector of i32s
define void @__scatter32_i8(<16 x i32> %ptrs, <16 x i8> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i8 *
  %val_0_ID = extractelement <16 x i8> %values, i32 0
  store i8 %val_0_ID, i8 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i8 *
  %val_1_ID = extractelement <16 x i8> %values, i32 1
  store i8 %val_1_ID, i8 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i8 *
  %val_2_ID = extractelement <16 x i8> %values, i32 2
  store i8 %val_2_ID, i8 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i8 *
  %val_3_ID = extractelement <16 x i8> %values, i32 3
  store i8 %val_3_ID, i8 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i8 *
  %val_4_ID = extractelement <16 x i8> %values, i32 4
  store i8 %val_4_ID, i8 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i8 *
  %val_5_ID = extractelement <16 x i8> %values, i32 5
  store i8 %val_5_ID, i8 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i8 *
  %val_6_ID = extractelement <16 x i8> %values, i32 6
  store i8 %val_6_ID, i8 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i8 *
  %val_7_ID = extractelement <16 x i8> %values, i32 7
  store i8 %val_7_ID, i8 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i8 *
  %val_8_ID = extractelement <16 x i8> %values, i32 8
  store i8 %val_8_ID, i8 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i8 *
  %val_9_ID = extractelement <16 x i8> %values, i32 9
  store i8 %val_9_ID, i8 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i8 *
  %val_10_ID = extractelement <16 x i8> %values, i32 10
  store i8 %val_10_ID, i8 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i8 *
  %val_11_ID = extractelement <16 x i8> %values, i32 11
  store i8 %val_11_ID, i8 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i8 *
  %val_12_ID = extractelement <16 x i8> %values, i32 12
  store i8 %val_12_ID, i8 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i8 *
  %val_13_ID = extractelement <16 x i8> %values, i32 13
  store i8 %val_13_ID, i8 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i8 *
  %val_14_ID = extractelement <16 x i8> %values, i32 14
  store i8 %val_14_ID, i8 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i8 *
  %val_15_ID = extractelement <16 x i8> %values, i32 15
  store i8 %val_15_ID, i8 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i8 *
  %val__id = extractelement <16 x i8> %values, i32 %pl_lane
  store i8 %val__id, i8 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 64-bit scatter, takes array of pointers encoded as vector of i64s
define void @__scatter64_i8(<16 x i64> %ptrs, <16 x i8> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i8 *
  %val_0_ID = extractelement <16 x i8> %values, i32 0
  store i8 %val_0_ID, i8 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i8 *
  %val_1_ID = extractelement <16 x i8> %values, i32 1
  store i8 %val_1_ID, i8 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i8 *
  %val_2_ID = extractelement <16 x i8> %values, i32 2
  store i8 %val_2_ID, i8 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i8 *
  %val_3_ID = extractelement <16 x i8> %values, i32 3
  store i8 %val_3_ID, i8 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i8 *
  %val_4_ID = extractelement <16 x i8> %values, i32 4
  store i8 %val_4_ID, i8 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i8 *
  %val_5_ID = extractelement <16 x i8> %values, i32 5
  store i8 %val_5_ID, i8 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i8 *
  %val_6_ID = extractelement <16 x i8> %values, i32 6
  store i8 %val_6_ID, i8 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i8 *
  %val_7_ID = extractelement <16 x i8> %values, i32 7
  store i8 %val_7_ID, i8 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i8 *
  %val_8_ID = extractelement <16 x i8> %values, i32 8
  store i8 %val_8_ID, i8 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i8 *
  %val_9_ID = extractelement <16 x i8> %values, i32 9
  store i8 %val_9_ID, i8 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i8 *
  %val_10_ID = extractelement <16 x i8> %values, i32 10
  store i8 %val_10_ID, i8 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i8 *
  %val_11_ID = extractelement <16 x i8> %values, i32 11
  store i8 %val_11_ID, i8 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i8 *
  %val_12_ID = extractelement <16 x i8> %values, i32 12
  store i8 %val_12_ID, i8 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i8 *
  %val_13_ID = extractelement <16 x i8> %values, i32 13
  store i8 %val_13_ID, i8 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i8 *
  %val_14_ID = extractelement <16 x i8> %values, i32 14
  store i8 %val_14_ID, i8 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i8 *
  %val_15_ID = extractelement <16 x i8> %values, i32 15
  store i8 %val_15_ID, i8 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i8 *
  %val__id = extractelement <16 x i8> %values, i32 %pl_lane
  store i8 %val__id, i8 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}




;; Define the function that descripes the work to do to scatter a single
;; value
define void @__scatter_elt32_i16(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                <16 x i32> %offset_delta, <16 x i16> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i16 *
  %storeval = extractelement <16 x i16> %values, i32 %lane
  store i16 %storeval, i16 * %ptrcast
  ret void
}

define void @__scatter_elt64_i16(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                <16 x i64> %offset_delta, <16 x i16> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i16 *
  %storeval = extractelement <16 x i16> %values, i32 %lane
  store i16 %storeval, i16 * %ptrcast
  ret void
}

define void @__scatter_factored_base_offsets32_i16(i8* %base, <16 x i32> %offsets, i32 %offset_scale,
                                         <16 x i32> %offset_delta, <16 x i16> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 0)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 1)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 2)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 3)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 4)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 5)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 6)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 7)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 8)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 9)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 10)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 11)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 12)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 13)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 14)
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt32_i16(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i16> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

define void @__scatter_factored_base_offsets64_i16(i8* %base, <16 x i64> %offsets, i32 %offset_scale,
                                         <16 x i64> %offset_delta, <16 x i16> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 0)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 1)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 2)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 3)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 4)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 5)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 6)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 7)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 8)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 9)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 10)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 11)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 12)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 13)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 14)
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt64_i16(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i16> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 32-bit scatter, takes array of pointers encoded as vector of i32s
define void @__scatter32_i16(<16 x i32> %ptrs, <16 x i16> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i16 *
  %val_0_ID = extractelement <16 x i16> %values, i32 0
  store i16 %val_0_ID, i16 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i16 *
  %val_1_ID = extractelement <16 x i16> %values, i32 1
  store i16 %val_1_ID, i16 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i16 *
  %val_2_ID = extractelement <16 x i16> %values, i32 2
  store i16 %val_2_ID, i16 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i16 *
  %val_3_ID = extractelement <16 x i16> %values, i32 3
  store i16 %val_3_ID, i16 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i16 *
  %val_4_ID = extractelement <16 x i16> %values, i32 4
  store i16 %val_4_ID, i16 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i16 *
  %val_5_ID = extractelement <16 x i16> %values, i32 5
  store i16 %val_5_ID, i16 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i16 *
  %val_6_ID = extractelement <16 x i16> %values, i32 6
  store i16 %val_6_ID, i16 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i16 *
  %val_7_ID = extractelement <16 x i16> %values, i32 7
  store i16 %val_7_ID, i16 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i16 *
  %val_8_ID = extractelement <16 x i16> %values, i32 8
  store i16 %val_8_ID, i16 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i16 *
  %val_9_ID = extractelement <16 x i16> %values, i32 9
  store i16 %val_9_ID, i16 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i16 *
  %val_10_ID = extractelement <16 x i16> %values, i32 10
  store i16 %val_10_ID, i16 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i16 *
  %val_11_ID = extractelement <16 x i16> %values, i32 11
  store i16 %val_11_ID, i16 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i16 *
  %val_12_ID = extractelement <16 x i16> %values, i32 12
  store i16 %val_12_ID, i16 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i16 *
  %val_13_ID = extractelement <16 x i16> %values, i32 13
  store i16 %val_13_ID, i16 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i16 *
  %val_14_ID = extractelement <16 x i16> %values, i32 14
  store i16 %val_14_ID, i16 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i16 *
  %val_15_ID = extractelement <16 x i16> %values, i32 15
  store i16 %val_15_ID, i16 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i16 *
  %val__id = extractelement <16 x i16> %values, i32 %pl_lane
  store i16 %val__id, i16 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 64-bit scatter, takes array of pointers encoded as vector of i64s
define void @__scatter64_i16(<16 x i64> %ptrs, <16 x i16> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i16 *
  %val_0_ID = extractelement <16 x i16> %values, i32 0
  store i16 %val_0_ID, i16 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i16 *
  %val_1_ID = extractelement <16 x i16> %values, i32 1
  store i16 %val_1_ID, i16 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i16 *
  %val_2_ID = extractelement <16 x i16> %values, i32 2
  store i16 %val_2_ID, i16 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i16 *
  %val_3_ID = extractelement <16 x i16> %values, i32 3
  store i16 %val_3_ID, i16 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i16 *
  %val_4_ID = extractelement <16 x i16> %values, i32 4
  store i16 %val_4_ID, i16 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i16 *
  %val_5_ID = extractelement <16 x i16> %values, i32 5
  store i16 %val_5_ID, i16 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i16 *
  %val_6_ID = extractelement <16 x i16> %values, i32 6
  store i16 %val_6_ID, i16 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i16 *
  %val_7_ID = extractelement <16 x i16> %values, i32 7
  store i16 %val_7_ID, i16 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i16 *
  %val_8_ID = extractelement <16 x i16> %values, i32 8
  store i16 %val_8_ID, i16 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i16 *
  %val_9_ID = extractelement <16 x i16> %values, i32 9
  store i16 %val_9_ID, i16 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i16 *
  %val_10_ID = extractelement <16 x i16> %values, i32 10
  store i16 %val_10_ID, i16 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i16 *
  %val_11_ID = extractelement <16 x i16> %values, i32 11
  store i16 %val_11_ID, i16 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i16 *
  %val_12_ID = extractelement <16 x i16> %values, i32 12
  store i16 %val_12_ID, i16 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i16 *
  %val_13_ID = extractelement <16 x i16> %values, i32 13
  store i16 %val_13_ID, i16 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i16 *
  %val_14_ID = extractelement <16 x i16> %values, i32 14
  store i16 %val_14_ID, i16 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i16 *
  %val_15_ID = extractelement <16 x i16> %values, i32 15
  store i16 %val_15_ID, i16 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i16 *
  %val__id = extractelement <16 x i16> %values, i32 %pl_lane
  store i16 %val__id, i16 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}




;; Define the function that descripes the work to do to scatter a single
;; value
define void @__scatter_elt32_i32(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                <16 x i32> %offset_delta, <16 x i32> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i32 *
  %storeval = extractelement <16 x i32> %values, i32 %lane
  store i32 %storeval, i32 * %ptrcast
  ret void
}

define void @__scatter_elt64_i32(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                <16 x i64> %offset_delta, <16 x i32> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i32 *
  %storeval = extractelement <16 x i32> %values, i32 %lane
  store i32 %storeval, i32 * %ptrcast
  ret void
}

define void @__scatter_factored_base_offsets32_i32(i8* %base, <16 x i32> %offsets, i32 %offset_scale,
                                         <16 x i32> %offset_delta, <16 x i32> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 0)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 1)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 2)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 3)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 4)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 5)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 6)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 7)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 8)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 9)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 10)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 11)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 12)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 13)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 14)
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt32_i32(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i32> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

define void @__scatter_factored_base_offsets64_i32(i8* %base, <16 x i64> %offsets, i32 %offset_scale,
                                         <16 x i64> %offset_delta, <16 x i32> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 0)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 1)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 2)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 3)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 4)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 5)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 6)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 7)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 8)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 9)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 10)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 11)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 12)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 13)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 14)
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt64_i32(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i32> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 32-bit scatter, takes array of pointers encoded as vector of i32s
define void @__scatter32_i32(<16 x i32> %ptrs, <16 x i32> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i32 *
  %val_0_ID = extractelement <16 x i32> %values, i32 0
  store i32 %val_0_ID, i32 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i32 *
  %val_1_ID = extractelement <16 x i32> %values, i32 1
  store i32 %val_1_ID, i32 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i32 *
  %val_2_ID = extractelement <16 x i32> %values, i32 2
  store i32 %val_2_ID, i32 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i32 *
  %val_3_ID = extractelement <16 x i32> %values, i32 3
  store i32 %val_3_ID, i32 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i32 *
  %val_4_ID = extractelement <16 x i32> %values, i32 4
  store i32 %val_4_ID, i32 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i32 *
  %val_5_ID = extractelement <16 x i32> %values, i32 5
  store i32 %val_5_ID, i32 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i32 *
  %val_6_ID = extractelement <16 x i32> %values, i32 6
  store i32 %val_6_ID, i32 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i32 *
  %val_7_ID = extractelement <16 x i32> %values, i32 7
  store i32 %val_7_ID, i32 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i32 *
  %val_8_ID = extractelement <16 x i32> %values, i32 8
  store i32 %val_8_ID, i32 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i32 *
  %val_9_ID = extractelement <16 x i32> %values, i32 9
  store i32 %val_9_ID, i32 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i32 *
  %val_10_ID = extractelement <16 x i32> %values, i32 10
  store i32 %val_10_ID, i32 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i32 *
  %val_11_ID = extractelement <16 x i32> %values, i32 11
  store i32 %val_11_ID, i32 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i32 *
  %val_12_ID = extractelement <16 x i32> %values, i32 12
  store i32 %val_12_ID, i32 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i32 *
  %val_13_ID = extractelement <16 x i32> %values, i32 13
  store i32 %val_13_ID, i32 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i32 *
  %val_14_ID = extractelement <16 x i32> %values, i32 14
  store i32 %val_14_ID, i32 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i32 *
  %val_15_ID = extractelement <16 x i32> %values, i32 15
  store i32 %val_15_ID, i32 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i32 *
  %val__id = extractelement <16 x i32> %values, i32 %pl_lane
  store i32 %val__id, i32 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 64-bit scatter, takes array of pointers encoded as vector of i64s
define void @__scatter64_i32(<16 x i64> %ptrs, <16 x i32> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i32 *
  %val_0_ID = extractelement <16 x i32> %values, i32 0
  store i32 %val_0_ID, i32 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i32 *
  %val_1_ID = extractelement <16 x i32> %values, i32 1
  store i32 %val_1_ID, i32 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i32 *
  %val_2_ID = extractelement <16 x i32> %values, i32 2
  store i32 %val_2_ID, i32 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i32 *
  %val_3_ID = extractelement <16 x i32> %values, i32 3
  store i32 %val_3_ID, i32 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i32 *
  %val_4_ID = extractelement <16 x i32> %values, i32 4
  store i32 %val_4_ID, i32 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i32 *
  %val_5_ID = extractelement <16 x i32> %values, i32 5
  store i32 %val_5_ID, i32 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i32 *
  %val_6_ID = extractelement <16 x i32> %values, i32 6
  store i32 %val_6_ID, i32 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i32 *
  %val_7_ID = extractelement <16 x i32> %values, i32 7
  store i32 %val_7_ID, i32 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i32 *
  %val_8_ID = extractelement <16 x i32> %values, i32 8
  store i32 %val_8_ID, i32 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i32 *
  %val_9_ID = extractelement <16 x i32> %values, i32 9
  store i32 %val_9_ID, i32 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i32 *
  %val_10_ID = extractelement <16 x i32> %values, i32 10
  store i32 %val_10_ID, i32 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i32 *
  %val_11_ID = extractelement <16 x i32> %values, i32 11
  store i32 %val_11_ID, i32 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i32 *
  %val_12_ID = extractelement <16 x i32> %values, i32 12
  store i32 %val_12_ID, i32 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i32 *
  %val_13_ID = extractelement <16 x i32> %values, i32 13
  store i32 %val_13_ID, i32 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i32 *
  %val_14_ID = extractelement <16 x i32> %values, i32 14
  store i32 %val_14_ID, i32 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i32 *
  %val_15_ID = extractelement <16 x i32> %values, i32 15
  store i32 %val_15_ID, i32 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i32 *
  %val__id = extractelement <16 x i32> %values, i32 %pl_lane
  store i32 %val__id, i32 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}




;; Define the function that descripes the work to do to scatter a single
;; value
define void @__scatter_elt32_float(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                <16 x i32> %offset_delta, <16 x float> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to float *
  %storeval = extractelement <16 x float> %values, i32 %lane
  store float %storeval, float * %ptrcast
  ret void
}

define void @__scatter_elt64_float(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                <16 x i64> %offset_delta, <16 x float> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to float *
  %storeval = extractelement <16 x float> %values, i32 %lane
  store float %storeval, float * %ptrcast
  ret void
}

define void @__scatter_factored_base_offsets32_float(i8* %base, <16 x i32> %offsets, i32 %offset_scale,
                                         <16 x i32> %offset_delta, <16 x float> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 0)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 1)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 2)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 3)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 4)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 5)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 6)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 7)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 8)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 9)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 10)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 11)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 12)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 13)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 14)
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt32_float(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x float> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

define void @__scatter_factored_base_offsets64_float(i8* %base, <16 x i64> %offsets, i32 %offset_scale,
                                         <16 x i64> %offset_delta, <16 x float> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 0)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 1)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 2)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 3)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 4)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 5)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 6)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 7)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 8)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 9)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 10)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 11)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 12)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 13)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 14)
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt64_float(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x float> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 32-bit scatter, takes array of pointers encoded as vector of i32s
define void @__scatter32_float(<16 x i32> %ptrs, <16 x float> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to float *
  %val_0_ID = extractelement <16 x float> %values, i32 0
  store float %val_0_ID, float * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to float *
  %val_1_ID = extractelement <16 x float> %values, i32 1
  store float %val_1_ID, float * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to float *
  %val_2_ID = extractelement <16 x float> %values, i32 2
  store float %val_2_ID, float * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to float *
  %val_3_ID = extractelement <16 x float> %values, i32 3
  store float %val_3_ID, float * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to float *
  %val_4_ID = extractelement <16 x float> %values, i32 4
  store float %val_4_ID, float * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to float *
  %val_5_ID = extractelement <16 x float> %values, i32 5
  store float %val_5_ID, float * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to float *
  %val_6_ID = extractelement <16 x float> %values, i32 6
  store float %val_6_ID, float * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to float *
  %val_7_ID = extractelement <16 x float> %values, i32 7
  store float %val_7_ID, float * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to float *
  %val_8_ID = extractelement <16 x float> %values, i32 8
  store float %val_8_ID, float * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to float *
  %val_9_ID = extractelement <16 x float> %values, i32 9
  store float %val_9_ID, float * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to float *
  %val_10_ID = extractelement <16 x float> %values, i32 10
  store float %val_10_ID, float * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to float *
  %val_11_ID = extractelement <16 x float> %values, i32 11
  store float %val_11_ID, float * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to float *
  %val_12_ID = extractelement <16 x float> %values, i32 12
  store float %val_12_ID, float * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to float *
  %val_13_ID = extractelement <16 x float> %values, i32 13
  store float %val_13_ID, float * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to float *
  %val_14_ID = extractelement <16 x float> %values, i32 14
  store float %val_14_ID, float * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to float *
  %val_15_ID = extractelement <16 x float> %values, i32 15
  store float %val_15_ID, float * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to float *
  %val__id = extractelement <16 x float> %values, i32 %pl_lane
  store float %val__id, float * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 64-bit scatter, takes array of pointers encoded as vector of i64s
define void @__scatter64_float(<16 x i64> %ptrs, <16 x float> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to float *
  %val_0_ID = extractelement <16 x float> %values, i32 0
  store float %val_0_ID, float * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to float *
  %val_1_ID = extractelement <16 x float> %values, i32 1
  store float %val_1_ID, float * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to float *
  %val_2_ID = extractelement <16 x float> %values, i32 2
  store float %val_2_ID, float * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to float *
  %val_3_ID = extractelement <16 x float> %values, i32 3
  store float %val_3_ID, float * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to float *
  %val_4_ID = extractelement <16 x float> %values, i32 4
  store float %val_4_ID, float * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to float *
  %val_5_ID = extractelement <16 x float> %values, i32 5
  store float %val_5_ID, float * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to float *
  %val_6_ID = extractelement <16 x float> %values, i32 6
  store float %val_6_ID, float * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to float *
  %val_7_ID = extractelement <16 x float> %values, i32 7
  store float %val_7_ID, float * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to float *
  %val_8_ID = extractelement <16 x float> %values, i32 8
  store float %val_8_ID, float * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to float *
  %val_9_ID = extractelement <16 x float> %values, i32 9
  store float %val_9_ID, float * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to float *
  %val_10_ID = extractelement <16 x float> %values, i32 10
  store float %val_10_ID, float * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to float *
  %val_11_ID = extractelement <16 x float> %values, i32 11
  store float %val_11_ID, float * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to float *
  %val_12_ID = extractelement <16 x float> %values, i32 12
  store float %val_12_ID, float * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to float *
  %val_13_ID = extractelement <16 x float> %values, i32 13
  store float %val_13_ID, float * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to float *
  %val_14_ID = extractelement <16 x float> %values, i32 14
  store float %val_14_ID, float * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to float *
  %val_15_ID = extractelement <16 x float> %values, i32 15
  store float %val_15_ID, float * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to float *
  %val__id = extractelement <16 x float> %values, i32 %pl_lane
  store float %val__id, float * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}




;; Define the function that descripes the work to do to scatter a single
;; value
define void @__scatter_elt32_i64(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                <16 x i32> %offset_delta, <16 x i64> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i64 *
  %storeval = extractelement <16 x i64> %values, i32 %lane
  store i64 %storeval, i64 * %ptrcast
  ret void
}

define void @__scatter_elt64_i64(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                <16 x i64> %offset_delta, <16 x i64> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to i64 *
  %storeval = extractelement <16 x i64> %values, i32 %lane
  store i64 %storeval, i64 * %ptrcast
  ret void
}

define void @__scatter_factored_base_offsets32_i64(i8* %base, <16 x i32> %offsets, i32 %offset_scale,
                                         <16 x i32> %offset_delta, <16 x i64> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 0)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 1)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 2)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 3)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 4)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 5)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 6)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 7)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 8)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 9)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 10)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 11)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 12)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 13)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 14)
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt32_i64(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x i64> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

define void @__scatter_factored_base_offsets64_i64(i8* %base, <16 x i64> %offsets, i32 %offset_scale,
                                         <16 x i64> %offset_delta, <16 x i64> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 0)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 1)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 2)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 3)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 4)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 5)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 6)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 7)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 8)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 9)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 10)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 11)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 12)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 13)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 14)
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt64_i64(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x i64> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 32-bit scatter, takes array of pointers encoded as vector of i32s
define void @__scatter32_i64(<16 x i32> %ptrs, <16 x i64> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to i64 *
  %val_0_ID = extractelement <16 x i64> %values, i32 0
  store i64 %val_0_ID, i64 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to i64 *
  %val_1_ID = extractelement <16 x i64> %values, i32 1
  store i64 %val_1_ID, i64 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to i64 *
  %val_2_ID = extractelement <16 x i64> %values, i32 2
  store i64 %val_2_ID, i64 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to i64 *
  %val_3_ID = extractelement <16 x i64> %values, i32 3
  store i64 %val_3_ID, i64 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to i64 *
  %val_4_ID = extractelement <16 x i64> %values, i32 4
  store i64 %val_4_ID, i64 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to i64 *
  %val_5_ID = extractelement <16 x i64> %values, i32 5
  store i64 %val_5_ID, i64 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to i64 *
  %val_6_ID = extractelement <16 x i64> %values, i32 6
  store i64 %val_6_ID, i64 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to i64 *
  %val_7_ID = extractelement <16 x i64> %values, i32 7
  store i64 %val_7_ID, i64 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to i64 *
  %val_8_ID = extractelement <16 x i64> %values, i32 8
  store i64 %val_8_ID, i64 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to i64 *
  %val_9_ID = extractelement <16 x i64> %values, i32 9
  store i64 %val_9_ID, i64 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to i64 *
  %val_10_ID = extractelement <16 x i64> %values, i32 10
  store i64 %val_10_ID, i64 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to i64 *
  %val_11_ID = extractelement <16 x i64> %values, i32 11
  store i64 %val_11_ID, i64 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to i64 *
  %val_12_ID = extractelement <16 x i64> %values, i32 12
  store i64 %val_12_ID, i64 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to i64 *
  %val_13_ID = extractelement <16 x i64> %values, i32 13
  store i64 %val_13_ID, i64 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to i64 *
  %val_14_ID = extractelement <16 x i64> %values, i32 14
  store i64 %val_14_ID, i64 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to i64 *
  %val_15_ID = extractelement <16 x i64> %values, i32 15
  store i64 %val_15_ID, i64 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to i64 *
  %val__id = extractelement <16 x i64> %values, i32 %pl_lane
  store i64 %val__id, i64 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 64-bit scatter, takes array of pointers encoded as vector of i64s
define void @__scatter64_i64(<16 x i64> %ptrs, <16 x i64> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to i64 *
  %val_0_ID = extractelement <16 x i64> %values, i32 0
  store i64 %val_0_ID, i64 * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to i64 *
  %val_1_ID = extractelement <16 x i64> %values, i32 1
  store i64 %val_1_ID, i64 * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to i64 *
  %val_2_ID = extractelement <16 x i64> %values, i32 2
  store i64 %val_2_ID, i64 * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to i64 *
  %val_3_ID = extractelement <16 x i64> %values, i32 3
  store i64 %val_3_ID, i64 * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to i64 *
  %val_4_ID = extractelement <16 x i64> %values, i32 4
  store i64 %val_4_ID, i64 * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to i64 *
  %val_5_ID = extractelement <16 x i64> %values, i32 5
  store i64 %val_5_ID, i64 * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to i64 *
  %val_6_ID = extractelement <16 x i64> %values, i32 6
  store i64 %val_6_ID, i64 * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to i64 *
  %val_7_ID = extractelement <16 x i64> %values, i32 7
  store i64 %val_7_ID, i64 * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to i64 *
  %val_8_ID = extractelement <16 x i64> %values, i32 8
  store i64 %val_8_ID, i64 * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to i64 *
  %val_9_ID = extractelement <16 x i64> %values, i32 9
  store i64 %val_9_ID, i64 * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to i64 *
  %val_10_ID = extractelement <16 x i64> %values, i32 10
  store i64 %val_10_ID, i64 * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to i64 *
  %val_11_ID = extractelement <16 x i64> %values, i32 11
  store i64 %val_11_ID, i64 * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to i64 *
  %val_12_ID = extractelement <16 x i64> %values, i32 12
  store i64 %val_12_ID, i64 * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to i64 *
  %val_13_ID = extractelement <16 x i64> %values, i32 13
  store i64 %val_13_ID, i64 * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to i64 *
  %val_14_ID = extractelement <16 x i64> %values, i32 14
  store i64 %val_14_ID, i64 * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to i64 *
  %val_15_ID = extractelement <16 x i64> %values, i32 15
  store i64 %val_15_ID, i64 * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to i64 *
  %val__id = extractelement <16 x i64> %values, i32 %pl_lane
  store i64 %val__id, i64 * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}




;; Define the function that descripes the work to do to scatter a single
;; value
define void @__scatter_elt32_double(i8 * %ptr, <16 x i32> %offsets, i32 %offset_scale,
                                <16 x i32> %offset_delta, <16 x double> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset32 = extractelement <16 x i32> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %offset64 = sext i32 %offset32 to i64
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta = extractelement <16 x i32> %offset_delta, i32 %lane
  %delta64 = sext i32 %delta to i64
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to double *
  %storeval = extractelement <16 x double> %values, i32 %lane
  store double %storeval, double * %ptrcast
  ret void
}

define void @__scatter_elt64_double(i8 * %ptr, <16 x i64> %offsets, i32 %offset_scale,
                                <16 x i64> %offset_delta, <16 x double> %values,
                                i32 %lane) nounwind alwaysinline {
  %offset64 = extractelement <16 x i64> %offsets, i32 %lane
  ; the order and details of the next 4 lines are important--they match LLVMs 
  ; patterns that apply the free x86 2x/4x/8x scaling in addressing calculations
  %scale64 = sext i32 %offset_scale to i64
  %offset = mul i64 %offset64, %scale64
  %ptroffset = getelementptr i8 , i8 *
 %ptr, i64 %offset

  %delta64 = extractelement <16 x i64> %offset_delta, i32 %lane
  %finalptr = getelementptr i8 , i8 *
 %ptroffset, i64 %delta64

  %ptrcast = bitcast i8 * %finalptr to double *
  %storeval = extractelement <16 x double> %values, i32 %lane
  store double %storeval, double * %ptrcast
  ret void
}

define void @__scatter_factored_base_offsets32_double(i8* %base, <16 x i32> %offsets, i32 %offset_scale,
                                         <16 x i32> %offset_delta, <16 x double> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 0)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 1)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 2)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 3)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 4)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 5)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 6)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 7)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 8)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 9)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 10)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 11)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 12)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 13)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 14)
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt32_double(i8 * %base, <16 x i32> %offsets, i32 %offset_scale,
                                    <16 x i32> %offset_delta, <16 x double> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

define void @__scatter_factored_base_offsets64_double(i8* %base, <16 x i64> %offsets, i32 %offset_scale,
                                         <16 x i64> %offset_delta, <16 x double> %values,
                                         <16 x i8> %mask) nounwind alwaysinline {
  ;; And use the per_lane macro to do all of the per-lane work for scatter...
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 0)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 1)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 2)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 3)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 4)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 5)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 6)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 7)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 8)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 9)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 10)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 11)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 12)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 13)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 14)
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 15)
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
      call void @__scatter_elt64_double(i8 * %base, <16 x i64> %offsets, i32 %offset_scale,
                                    <16 x i64> %offset_delta, <16 x double> %values, i32 %pl_lane)
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 32-bit scatter, takes array of pointers encoded as vector of i32s
define void @__scatter32_double(<16 x i32> %ptrs, <16 x double> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i32> %ptrs, i32 0
  %ptr_0_ID = inttoptr i32 %iptr_0_ID to double *
  %val_0_ID = extractelement <16 x double> %values, i32 0
  store double %val_0_ID, double * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i32> %ptrs, i32 1
  %ptr_1_ID = inttoptr i32 %iptr_1_ID to double *
  %val_1_ID = extractelement <16 x double> %values, i32 1
  store double %val_1_ID, double * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i32> %ptrs, i32 2
  %ptr_2_ID = inttoptr i32 %iptr_2_ID to double *
  %val_2_ID = extractelement <16 x double> %values, i32 2
  store double %val_2_ID, double * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i32> %ptrs, i32 3
  %ptr_3_ID = inttoptr i32 %iptr_3_ID to double *
  %val_3_ID = extractelement <16 x double> %values, i32 3
  store double %val_3_ID, double * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i32> %ptrs, i32 4
  %ptr_4_ID = inttoptr i32 %iptr_4_ID to double *
  %val_4_ID = extractelement <16 x double> %values, i32 4
  store double %val_4_ID, double * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i32> %ptrs, i32 5
  %ptr_5_ID = inttoptr i32 %iptr_5_ID to double *
  %val_5_ID = extractelement <16 x double> %values, i32 5
  store double %val_5_ID, double * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i32> %ptrs, i32 6
  %ptr_6_ID = inttoptr i32 %iptr_6_ID to double *
  %val_6_ID = extractelement <16 x double> %values, i32 6
  store double %val_6_ID, double * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i32> %ptrs, i32 7
  %ptr_7_ID = inttoptr i32 %iptr_7_ID to double *
  %val_7_ID = extractelement <16 x double> %values, i32 7
  store double %val_7_ID, double * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i32> %ptrs, i32 8
  %ptr_8_ID = inttoptr i32 %iptr_8_ID to double *
  %val_8_ID = extractelement <16 x double> %values, i32 8
  store double %val_8_ID, double * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i32> %ptrs, i32 9
  %ptr_9_ID = inttoptr i32 %iptr_9_ID to double *
  %val_9_ID = extractelement <16 x double> %values, i32 9
  store double %val_9_ID, double * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i32> %ptrs, i32 10
  %ptr_10_ID = inttoptr i32 %iptr_10_ID to double *
  %val_10_ID = extractelement <16 x double> %values, i32 10
  store double %val_10_ID, double * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i32> %ptrs, i32 11
  %ptr_11_ID = inttoptr i32 %iptr_11_ID to double *
  %val_11_ID = extractelement <16 x double> %values, i32 11
  store double %val_11_ID, double * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i32> %ptrs, i32 12
  %ptr_12_ID = inttoptr i32 %iptr_12_ID to double *
  %val_12_ID = extractelement <16 x double> %values, i32 12
  store double %val_12_ID, double * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i32> %ptrs, i32 13
  %ptr_13_ID = inttoptr i32 %iptr_13_ID to double *
  %val_13_ID = extractelement <16 x double> %values, i32 13
  store double %val_13_ID, double * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i32> %ptrs, i32 14
  %ptr_14_ID = inttoptr i32 %iptr_14_ID to double *
  %val_14_ID = extractelement <16 x double> %values, i32 14
  store double %val_14_ID, double * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i32> %ptrs, i32 15
  %ptr_15_ID = inttoptr i32 %iptr_15_ID to double *
  %val_15_ID = extractelement <16 x double> %values, i32 15
  store double %val_15_ID, double * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i32> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i32 %iptr__id to double *
  %val__id = extractelement <16 x double> %values, i32 %pl_lane
  store double %val__id, double * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}

; fully general 64-bit scatter, takes array of pointers encoded as vector of i64s
define void @__scatter64_double(<16 x i64> %ptrs, <16 x double> %values,
                            <16 x i8> %mask) nounwind alwaysinline {
  
  br label %pl_entry

pl_entry:
  %pl_mask = call i64 @__movmsk(<16 x i8> %mask)
  %pl_mask_known = call i1 @__is_compile_time_constant_mask(<16 x i8> %mask)
  br i1 %pl_mask_known, label %pl_known_mask, label %pl_unknown_mask

pl_known_mask:
  ;; the mask is known at compile time; see if it is something we can
  ;; handle more efficiently
  %pl_is_allon = icmp eq i64 %pl_mask, 65535
  br i1 %pl_is_allon, label %pl_all_on, label %pl_unknown_mask

pl_all_on:
  ;; the mask is all on--just expand the code for each lane sequentially
  
  %iptr_0_ID = extractelement <16 x i64> %ptrs, i32 0
  %ptr_0_ID = inttoptr i64 %iptr_0_ID to double *
  %val_0_ID = extractelement <16 x double> %values, i32 0
  store double %val_0_ID, double * %ptr_0_ID
 
  %iptr_1_ID = extractelement <16 x i64> %ptrs, i32 1
  %ptr_1_ID = inttoptr i64 %iptr_1_ID to double *
  %val_1_ID = extractelement <16 x double> %values, i32 1
  store double %val_1_ID, double * %ptr_1_ID
 
  %iptr_2_ID = extractelement <16 x i64> %ptrs, i32 2
  %ptr_2_ID = inttoptr i64 %iptr_2_ID to double *
  %val_2_ID = extractelement <16 x double> %values, i32 2
  store double %val_2_ID, double * %ptr_2_ID
 
  %iptr_3_ID = extractelement <16 x i64> %ptrs, i32 3
  %ptr_3_ID = inttoptr i64 %iptr_3_ID to double *
  %val_3_ID = extractelement <16 x double> %values, i32 3
  store double %val_3_ID, double * %ptr_3_ID
 
  %iptr_4_ID = extractelement <16 x i64> %ptrs, i32 4
  %ptr_4_ID = inttoptr i64 %iptr_4_ID to double *
  %val_4_ID = extractelement <16 x double> %values, i32 4
  store double %val_4_ID, double * %ptr_4_ID
 
  %iptr_5_ID = extractelement <16 x i64> %ptrs, i32 5
  %ptr_5_ID = inttoptr i64 %iptr_5_ID to double *
  %val_5_ID = extractelement <16 x double> %values, i32 5
  store double %val_5_ID, double * %ptr_5_ID
 
  %iptr_6_ID = extractelement <16 x i64> %ptrs, i32 6
  %ptr_6_ID = inttoptr i64 %iptr_6_ID to double *
  %val_6_ID = extractelement <16 x double> %values, i32 6
  store double %val_6_ID, double * %ptr_6_ID
 
  %iptr_7_ID = extractelement <16 x i64> %ptrs, i32 7
  %ptr_7_ID = inttoptr i64 %iptr_7_ID to double *
  %val_7_ID = extractelement <16 x double> %values, i32 7
  store double %val_7_ID, double * %ptr_7_ID
 
  %iptr_8_ID = extractelement <16 x i64> %ptrs, i32 8
  %ptr_8_ID = inttoptr i64 %iptr_8_ID to double *
  %val_8_ID = extractelement <16 x double> %values, i32 8
  store double %val_8_ID, double * %ptr_8_ID
 
  %iptr_9_ID = extractelement <16 x i64> %ptrs, i32 9
  %ptr_9_ID = inttoptr i64 %iptr_9_ID to double *
  %val_9_ID = extractelement <16 x double> %values, i32 9
  store double %val_9_ID, double * %ptr_9_ID
 
  %iptr_10_ID = extractelement <16 x i64> %ptrs, i32 10
  %ptr_10_ID = inttoptr i64 %iptr_10_ID to double *
  %val_10_ID = extractelement <16 x double> %values, i32 10
  store double %val_10_ID, double * %ptr_10_ID
 
  %iptr_11_ID = extractelement <16 x i64> %ptrs, i32 11
  %ptr_11_ID = inttoptr i64 %iptr_11_ID to double *
  %val_11_ID = extractelement <16 x double> %values, i32 11
  store double %val_11_ID, double * %ptr_11_ID
 
  %iptr_12_ID = extractelement <16 x i64> %ptrs, i32 12
  %ptr_12_ID = inttoptr i64 %iptr_12_ID to double *
  %val_12_ID = extractelement <16 x double> %values, i32 12
  store double %val_12_ID, double * %ptr_12_ID
 
  %iptr_13_ID = extractelement <16 x i64> %ptrs, i32 13
  %ptr_13_ID = inttoptr i64 %iptr_13_ID to double *
  %val_13_ID = extractelement <16 x double> %values, i32 13
  store double %val_13_ID, double * %ptr_13_ID
 
  %iptr_14_ID = extractelement <16 x i64> %ptrs, i32 14
  %ptr_14_ID = inttoptr i64 %iptr_14_ID to double *
  %val_14_ID = extractelement <16 x double> %values, i32 14
  store double %val_14_ID, double * %ptr_14_ID
 
  %iptr_15_ID = extractelement <16 x i64> %ptrs, i32 15
  %ptr_15_ID = inttoptr i64 %iptr_15_ID to double *
  %val_15_ID = extractelement <16 x double> %values, i32 15
  store double %val_15_ID, double * %ptr_15_ID
 
  br label %pl_done

pl_unknown_mask:
  ;; we just run the general case, though we could
  ;; try to be smart and just emit the code based on what it actually is,
  ;; for example by emitting the code straight-line without a loop and doing 
  ;; the lane tests explicitly, leaving later optimization passes to eliminate
  ;; the stuff that is definitely not needed.  Not clear if we will frequently 
  ;; encounter a mask that is known at compile-time but is not either all on or
  ;; all off...
  br label %pl_loop

pl_loop:
  ;; Loop over each lane and see if we want to do the work for this lane
  %pl_lane = phi i32 [ 0, %pl_unknown_mask ], [ %pl_nextlane, %pl_loopend ]
  %pl_lanemask = phi i64 [ 1, %pl_unknown_mask ], [ %pl_nextlanemask, %pl_loopend ]

  ; is the current lane on?  if so, goto do work, otherwise to end of loop
  %pl_and = and i64 %pl_mask, %pl_lanemask
  %pl_doit = icmp eq i64 %pl_and, %pl_lanemask
  br i1 %pl_doit, label %pl_dolane, label %pl_loopend 

pl_dolane:
  ;; If so, substitute in the code from the caller and replace the LANE
  ;; stuff with the current lane number
  
  %iptr__id = extractelement <16 x i64> %ptrs, i32 %pl_lane
  %ptr__id = inttoptr i64 %iptr__id to double *
  %val__id = extractelement <16 x double> %values, i32 %pl_lane
  store double %val__id, double * %ptr__id
 
  br label %pl_loopend

pl_loopend:
  %pl_nextlane = add i32 %pl_lane, 1
  %pl_nextlanemask = mul i64 %pl_lanemask, 2

  ; are we done yet?
  %pl_test = icmp ne i32 %pl_nextlane, 16
  br i1 %pl_test, label %pl_loop, label %pl_done

pl_done:

  ret void
}




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; int8/int16 builtins

declare <16 x i8> @llvm.x86.sse2.pavg.b(<16 x i8>, <16 x i8>) nounwind readnone

define <16 x i8> @__avg_up_uint8(<16 x i8>, <16 x i8>) nounwind readnone {
  %r = call <16 x i8> @llvm.x86.sse2.pavg.b(<16 x i8> %0, <16 x i8> %1)
  ret <16 x i8> %r
}

declare <8 x i16> @llvm.x86.sse2.pavg.w(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i16> @__avg_up_uint16(<16 x i16>, <16 x i16>) nounwind readnone {
  
  %a0 = shufflevector <16 x i16> %0, <16 x i16> undef,
    <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %b0 = shufflevector <16 x i16> %0, <16 x i16> undef,
    <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  
  %a1 = shufflevector <16 x i16> %1, <16 x i16> undef,
    <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %b1 = shufflevector <16 x i16> %1, <16 x i16> undef,
    <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %r0 = call <8 x i16> @llvm.x86.sse2.pavg.w(<8 x i16> %a0, <8 x i16> %a1)
  %r1 = call <8 x i16> @llvm.x86.sse2.pavg.w(<8 x i16> %b0, <8 x i16> %b1)
  
  %r = shufflevector <8 x i16> %r0, <8 x i16> %r1,
    <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x i16> %r
}


define <16 x i8> @__avg_up_int8(<16 x i8>, <16 x i8>) {
  %a16 = sext <16 x i8> %0 to <16 x i16>
  %b16 = sext <16 x i8> %1 to <16 x i16>
  %sum1 = add <16 x i16> %a16, %b16
  %sum = add <16 x i16> %sum1, < i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1,  i16 1 >
  %avg = sdiv <16 x i16> %sum, < i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2,  i16 2 >
  %r = trunc <16 x i16> %avg to <16 x i8>
  ret <16 x i8> %r
}

define <16 x i16> @__avg_up_int16(<16 x i16>, <16 x i16>) {
  %a32 = sext <16 x i16> %0 to <16 x i32>
  %b32 = sext <16 x i16> %1 to <16 x i32>
  %sum1 = add <16 x i32> %a32, %b32
  %sum = add <16 x i32> %sum1, < i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1,  i32 1 >
  %avg = sdiv <16 x i32> %sum, < i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2,  i32 2 >
  %r = trunc <16 x i32> %avg to <16 x i16>
  ret <16 x i16> %r
}


define <16 x i8> @__avg_down_uint8(<16 x i8>, <16 x i8>) {
  %a16 = zext <16 x i8> %0 to <16 x i16>
  %b16 = zext <16 x i8> %1 to <16 x i16>
  %sum = add <16 x i16> %a16, %b16
  %avg = lshr <16 x i16> %sum, < i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1,  i16 1 >
  %r = trunc <16 x i16> %avg to <16 x i8>
  ret <16 x i8> %r
}

define <16 x i8> @__avg_down_int8(<16 x i8>, <16 x i8>) {
  %a16 = sext <16 x i8> %0 to <16 x i16>
  %b16 = sext <16 x i8> %1 to <16 x i16>
  %sum = add <16 x i16> %a16, %b16
  %avg = sdiv <16 x i16> %sum, < i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2,  i16 2 >
  %r = trunc <16 x i16> %avg to <16 x i8>
  ret <16 x i8> %r
}

define <16 x i16> @__avg_down_uint16(<16 x i16>, <16 x i16>) {
  %a32 = zext <16 x i16> %0 to <16 x i32>
  %b32 = zext <16 x i16> %1 to <16 x i32>
  %sum = add <16 x i32> %a32, %b32
  %avg = lshr <16 x i32> %sum, < i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1,  i32 1 >
  %r = trunc <16 x i32> %avg to <16 x i16>
  ret <16 x i16> %r
}

define <16 x i16> @__avg_down_int16(<16 x i16>, <16 x i16>) {
  %a32 = sext <16 x i16> %0 to <16 x i32>
  %b32 = sext <16 x i16> %1 to <16 x i32>
  %sum = add <16 x i32> %a32, %b32
  %avg = sdiv <16 x i32> %sum, < i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2,  i32 2 >
  %r = trunc <16 x i32> %avg to <16 x i16>
  ret <16 x i16> %r
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; reciprocals in double precision, if supported


declare  double @__rsqrt_uniform_double(double)
declare <16 x double> @__rsqrt_varying_double(<16 x double>)


declare  double @__rcp_uniform_double(double)
declare <16 x double> @__rcp_varying_double(<16 x double>)



    declare float @__log_uniform_float(float) nounwind readnone
    declare <16 x float> @__log_varying_float(<16 x float>) nounwind readnone
    declare float @__exp_uniform_float(float) nounwind readnone
    declare <16 x float> @__exp_varying_float(<16 x float>) nounwind readnone
    declare float @__pow_uniform_float(float, float) nounwind readnone
    declare <16 x float> @__pow_varying_float(<16 x float>, <16 x float>) nounwind readnone

    declare double @__log_uniform_double(double) nounwind readnone
    declare <16 x double> @__log_varying_double(<16 x double>) nounwind readnone
    declare double @__exp_uniform_double(double) nounwind readnone
    declare <16 x double> @__exp_varying_double(<16 x double>) nounwind readnone
    declare double @__pow_uniform_double(double, double) nounwind readnone
    declare <16 x double> @__pow_varying_double(<16 x double>, <16 x double>) nounwind readnone


    declare <16 x float> @__sin_varying_float(<16 x float>) nounwind readnone
    declare <16 x float> @__asin_varying_float(<16 x float>) nounwind readnone
    declare <16 x float> @__cos_varying_float(<16 x float>) nounwind readnone
    declare <16 x float> @__acos_varying_float(<16 x float>) nounwind readnone
    declare void @__sincos_varying_float(<16 x float>, <16 x float>*, <16 x float>*) nounwind 
    declare <16 x float> @__tan_varying_float(<16 x float>) nounwind readnone
    declare <16 x float> @__atan_varying_float(<16 x float>) nounwind readnone
    declare <16 x float> @__atan2_varying_float(<16 x float>,<16 x float>) nounwind readnone

    declare float @__sin_uniform_float(float) nounwind readnone
    declare float @__asin_uniform_float(float) nounwind readnone
    declare float @__cos_uniform_float(float) nounwind readnone
    declare float @__acos_uniform_float(float) nounwind readnone
    declare void @__sincos_uniform_float(float, float*, float*) nounwind 
    declare float @__tan_uniform_float(float) nounwind readnone
    declare float @__atan_uniform_float(float) nounwind readnone
    declare float @__atan2_uniform_float(float,float) nounwind readnone

    declare <16 x double> @__sin_varying_double(<16 x double>) nounwind readnone
    declare <16 x double> @__asin_varying_double(<16 x double>) nounwind readnone
    declare <16 x double> @__cos_varying_double(<16 x double>) nounwind readnone
    declare <16 x double> @__acos_varying_double(<16 x double>) nounwind readnone
    declare void @__sincos_varying_double(<16 x double>, <16 x double>*, <16 x double>*) nounwind 
    declare <16 x double> @__tan_varying_double(<16 x double>) nounwind readnone
    declare <16 x double> @__atan_varying_double(<16 x double>) nounwind readnone
    declare <16 x double> @__atan2_varying_double(<16 x double>,<16 x double>) nounwind readnone

    declare double @__sin_uniform_double(double) nounwind readnone
    declare double @__asin_uniform_double(double) nounwind readnone
    declare double @__cos_uniform_double(double) nounwind readnone
    declare double @__acos_uniform_double(double) nounwind readnone
    declare void @__sincos_uniform_double(double, double*, double*) nounwind 
    declare double @__tan_uniform_double(double) nounwind readnone
    declare double @__atan_uniform_double(double) nounwind readnone
    declare double @__atan2_uniform_double(double,double) nounwind readnone

