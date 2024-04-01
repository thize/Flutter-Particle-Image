part of particle_image;

abstract class PD_Offset<T> extends PD_Progress<PD_Offset<T>, Offset> {
  final T x;
  final T y;

  const PD_Offset({
    required this.x,
    required this.y,
  });
}

class PD_OffsetNumber extends PD_Offset<PD_Number> {
  const PD_OffsetNumber({
    super.x = const PD_NumberConstant(0),
    super.y = const PD_NumberConstant(0),
  });

  @override
  Offset value(double progress) {
    return Offset(x.value(progress), y.value(progress));
  }

  @override
  PD_OffsetNumber clone() {
    return PD_OffsetNumber(x: x.clone(), y: y.clone());
  }
}

class PD_OffsetDouble extends PD_Offset<double> {
  const PD_OffsetDouble({
    super.x = 0,
    super.y = 0,
  });

  @override
  Offset value(double progress) {
    return Offset(x, y);
  }

  @override
  PD_OffsetDouble clone() {
    return PD_OffsetDouble(x: x, y: y);
  }
}

class PD_OffsetNumberRandomBetweenTwoConstants extends PD_OffsetNumber {
  final PD_Offset min;
  final PD_Offset max;

  PD_Number _randomX = const PD_NumberConstant(0);
  PD_Number _randomY = const PD_NumberConstant(0);

  PD_OffsetNumberRandomBetweenTwoConstants({
    required this.min,
    required this.max,
  }) : super(
          x: const PD_NumberConstant(0),
          y: const PD_NumberConstant(0),
        ) {
    _randomX = PD_NumberRandomBetweenTwoConstants(min.x, max.x);
    _randomY = PD_NumberRandomBetweenTwoConstants(min.y, max.y);
  }

  @override
  PD_Number get x => _randomX;

  @override
  PD_Number get y => _randomY;

  @override
  Offset value(double progress) {
    return Offset(x.value(progress), y.value(progress));
  }

  @override
  PD_OffsetNumberRandomBetweenTwoConstants clone() {
    return PD_OffsetNumberRandomBetweenTwoConstants(min: min, max: max);
  }
}

class PD_OffsetDoubleRandomBetweenTwoConstants extends PD_OffsetDouble {
  final PD_Offset min;
  final PD_Offset max;

  double _randomX = 0;
  double _randomY = 0;

  PD_OffsetDoubleRandomBetweenTwoConstants({
    required this.min,
    required this.max,
  }) : super(x: 0, y: 0) {
    _randomX = ParticleUtils.randomBetween(min.x, max.x);
    _randomY = ParticleUtils.randomBetween(min.y, max.y);
  }

  @override
  double get x => _randomX;

  @override
  double get y => _randomY;

  @override
  Offset value(double progress) {
    return Offset(x, y);
  }

  @override
  PD_OffsetDoubleRandomBetweenTwoConstants clone() {
    return PD_OffsetDoubleRandomBetweenTwoConstants(min: min, max: max);
  }
}
