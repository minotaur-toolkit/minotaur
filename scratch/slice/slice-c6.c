#include <stdbool.h>
bool loop2d(int a, int b, int c, int d, int e, bool f)  {
  for (int aa = 0; aa < a; aa++) {
    for (int bb = 0; bb < b; bb++) {
      for (int cc = 0; cc < c; cc++) {
        for (int dd = 0; dd < d; dd++) {
          if (f)
            break;
          for (int ee = 0; ee < e; ee++) {
            return 1;
          }
        }
      }
    }
  }
}