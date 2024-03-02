; CHECK: rewrite: (fadd <2 x double> (var <2 x double> %3) (reservedconst <2 x double> <2 x double> <double 4.000000e+00, double 0.000000e+00>))
define <2 x double> @src(double %0, double %1, i1 %2, i1 %3, i1 %4) {
if.end:
  %5 = fadd double %1, -1.0
  %6 = insertelement <2 x double> poison, double %0, i64 0
  %7 = insertelement <2 x double> %6, double %5, i64 1
  %8 = fadd <2 x double> %7, <double 4.0, double poison>
  ret <2 x double> %8
}
