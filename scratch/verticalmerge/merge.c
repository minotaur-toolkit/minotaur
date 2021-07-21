#include <immintrin.h>

// not correct
/*
__m512i interleaved_merge1(__m256i a, __m256i b) {
  // multiply 2 adjacent elements with the filter and add the result
  __m256i hi = _mm256_unpackhi_epi8 (a, b);
  __m256i lo = _mm256_unpacklo_epi8 (a, b);
  __m512i zmm_lo = _mm512_castsi256_si512(lo);
  __m512i merge = _mm512_inserti64x4(zmm_lo, hi, 1);
  return merge;
}*/


__m512i interleaved_merge2(__m256i a, __m256i b) {
  // multiply 2 adjacent elements with the filter and add the result
  __m512i ta = _mm512_cvtepu8_epi16 (a);
  __m512i tb = _mm512_cvtepu8_epi16 (b);
  __m512i shift = _mm512_slli_epi16 (tb, 8);
  __m512i merge = _mm512_or_epi64 (shift, ta);
  return merge;
}