#include <stdint.h>
void func(short*  s, int*  t, int n) {
  for (int i = 0 ; i < n; i +=2) {
    t[i/2] = s[i] - s[i + 1];
  }
}