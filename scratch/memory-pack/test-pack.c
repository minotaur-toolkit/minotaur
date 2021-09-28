#include <immintrin.h>

long long test_pack(__m256i a, __m256i b, int index) {
  // multiply 2 adjacent elements with the filter and add the result
  __m256i res = _mm256_unpacklo_epi8 (a, b);
  return res[index];
}

int main() {
    __m256i tmp1 = _mm256_set_epi8(0, 1,  2,    3,  4,  5,   6,  7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17, 18, 19, 20, 21, 22,23, 24, 25,26, 27,28,29,30,31);
    __m256i tmp2 = _mm256_set_epi8(40, 41,  42,    43,  44,  45,   46,  47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62,63, 64, 65,66, 67,68,69,70,71);
    printf("%llx\n", tmp2[0]);
    printf("0x%llx\n", test_pack(tmp1, tmp2, 0));
    for (int i = 0 ; i < 4; i ++) {

        printf("0x%llx\n", test_pack(tmp1, tmp2, i));
    }
    return 0;
}