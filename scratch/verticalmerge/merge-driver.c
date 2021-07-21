#include <immintrin.h>


__m512i interleaved_merge2(__m256i a, __m256i b);
// not correct

int main() {

    __m256i tmp1 = _mm256_set_epi8( 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31);
    __m256i tmp2 = _mm256_set_epi8(40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71);

    __m512i res;
    for (int i = 0 ; i < 1000000000; i ++) {
      res = interleaved_merge2(tmp1, tmp2);
    }
    for (int i = 0 ; i < 8; i ++) {
        printf("0x%llx\n", res[i]);
    }

    return 0;
}