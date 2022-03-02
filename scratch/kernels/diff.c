#include <stdint.h>
void func(short* restrict s, short* restrict t, int n) {
  for (int i = 0 ; i < n; i +=2) {
    t[i] = s[i] - s[i + 1];
  }
}

