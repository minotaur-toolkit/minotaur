#include "x86intrin.h"
__m256i convolve8_16_avx2(__m256 s,
                          __m256i f) {
  // multiply 2 adjacent elements with the filter and add the result
  __m256i hi = _mm256_unpackhi_epi8 (s, f);
  __m256i lo = _mm256_unpacklo_epi8 (s, f);
  __m512i 

