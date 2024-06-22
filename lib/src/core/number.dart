part of particle_image;

abstract class PD_Number extends PD_Progress<PD_Number, double> {
  const PD_Number();
}

class PD_NumberConstant extends PD_Number {
  final double constValue;

  const PD_NumberConstant(this.constValue);

  @override
  double value(double progress) => constValue;

  @override
  PD_NumberConstant clone() {
    return PD_NumberConstant(constValue);
  }
}

class PD_NumberRandomBetweenTwoConstants extends PD_Number {
  final double min;
  final double max;
  double _result = 0;

  PD_NumberRandomBetweenTwoConstants(this.min, this.max) {
    _result = ParticleUtils.randomBetween(min, max);
  }

  @override
  double value(double progress) {
    return _result;
  }

  @override
  PD_NumberRandomBetweenTwoConstants clone() {
    return PD_NumberRandomBetweenTwoConstants(min, max);
  }
}

class PD_NumberCurve extends PD_Number {
  final Curve curve;
  final double begin;
  final double end;

  const PD_NumberCurve({
    required this.curve,
    required this.begin,
    required this.end,
  });

  @override
  double value(double progress) {
    double res = begin + (end - begin) * curve.transform(progress);
    return res;
  }

  @override
  PD_NumberCurve clone() {
    return PD_NumberCurve(
      curve: curve,
      begin: begin,
      end: end,
    );
  }
}

class PD_NumberNumberCurve extends PD_Number {
  final Curve curve;
  final PD_Number begin;
  final PD_Number end;

  const PD_NumberNumberCurve({
    required this.curve,
    required this.begin,
    required this.end,
  });

  @override
  double value(double progress) {
    double res = begin.value(progress) +
        (end.value(progress) - begin.value(progress)) *
            curve.transform(progress);
    return res;
  }

  @override
  PD_NumberNumberCurve clone() {
    return PD_NumberNumberCurve(
      curve: curve,
      begin: begin.clone(),
      end: end.clone(),
    );
  }
}
