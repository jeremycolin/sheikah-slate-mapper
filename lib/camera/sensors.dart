import 'dart:math' as math;

double getRoll({double x, double y, double z}) =>
    math.atan(x / math.sqrt(math.pow(y, 2) + math.pow(z, 2)));
double getPitch({double x, double y, double z}) =>
    z.sign * (math.atan(y / math.sqrt(math.pow(x, 2) + math.pow(z, 2))) - math.pi / 2);
