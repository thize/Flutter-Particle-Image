part of particle_image;

class CurvePoints extends Curve {
  final List<double> controlPoints;

  CurvePoints(List<CurvePoint> points)
      : controlPoints = points.expand((e) => e.toList).toList();

  @override
  double transformInternal(double t) {
    final int n = controlPoints.length - 1;
    double yVal = 0;

    for (int i = 0; i <= n; ++i) {
      yVal += _bezierBasis(n, i, t) * controlPoints.elementAt(i);
    }

    return yVal;
  }

  double _bezierBasis(int n, int i, double t) {
    return _binomialCoeff(n, i) * pow(t, i) * pow(1 - t, n - i);
  }

  double _binomialCoeff(int n, int k) {
    return _factorial(n) / (_factorial(k) * _factorial(n - k));
  }

  double _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }
}

class CurvePoint {
  final int force;
  final double y;

  const CurvePoint({
    this.force = 1,
    required this.y,
  });

  List<double> get toList {
    return List.filled(force, y);
  }
}
