#include "x86intrin.h"

__m256i convolve8_16_avx2(const __m256i *const s,
                          const __m256i *const f) {
  // multiply 2 adjacent elements with the filter and add the result
  const __m256i k_64 = _mm256_set1_epi16(1 << 6);
  const __m256i x0 = _mm256_maddubs_epi16(s[0], f[0]);
  const __m256i x1 = _mm256_maddubs_epi16(s[1], f[1]);

  const __m256i x2 = _mm256_maddubs_epi16(s[2], f[2]);
  const __m256i x3 = _mm256_maddubs_epi16(s[3], f[3]);
  __m256i sum1, sum2;

  // sum the results together, saturating only on the final step
  // adding x0 with x2 and x1 with x3 is the only order that prevents
  // outranges for all filters
  sum1 = _mm256_add_epi16(x0, x2);
  sum2 = _mm256_add_epi16(x1, x3);
  // add the rounding offset early to avoid another saturated add
  sum1 = _mm256_add_epi16(sum1, k_64);
  sum1 = _mm256_adds_epi16(sum1, sum2);

  //sum_z = _mm512_dpbusds_epi32 ((__m512i) s[0], (__m512i) f[0])
  // round and shift by 7 bit each 16 bit
  sum1 = _mm256_srai_epi16(sum1, 7);


  return sum1;
}



 __m256i convolve8_16_avx2_opt(const __m256i *const s,
                                        const __m256i *const f) {
  // multiply 2 adjacent elements with the filter and add the result
  const __m256i k_64 = _mm256_set1_epi16(1 << 6);


  const __m512i x = _mm512_maddubs_epi16(((__m512i *)s)[0], ((__m512i *)f)[0]);
  const __m512i y = _mm512_maddubs_epi16(((__m512i *)s)[1], ((__m512i *)f)[1]);
  const __m256i x0 = _mm256_set_epi64x(x[3], x[2], x[1], x[0]);
  const __m256i x1 = _mm256_set_epi64x(x[7], x[6], x[5], x[4]);
  const __m256i x2 = _mm256_set_epi64x(y[3], y[2], y[1], y[0]);
  const __m256i x3 = _mm256_set_epi64x(y[7], y[6], y[5], y[4]);

    __m256i sum1, sum2;

  // sum the results together, saturating only on the final step
  // adding x0 with x2 and x1 with x3 is the only order that prevents
  // outranges for all filters
  sum1 = _mm256_add_epi16(x0, x2);
  sum2 = _mm256_add_epi16(x1, x3);
  // add the rounding offset early to avoid another saturated add
  sum1 = _mm256_add_epi16(sum1, k_64);
  sum1 = _mm256_adds_epi16(sum1, sum2);
  // round and shift by 7 bit each 16 bit
  sum1 = _mm256_srai_epi16(sum1, 7);
  return sum1;
}
