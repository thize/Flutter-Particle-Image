part of particle_image;

class PD_Vector3 extends PD_Progress<PD_Vector3, Vector3> {
  final PD_Number x;
  final PD_Number y;
  final PD_Number z;

  const PD_Vector3({
    this.x = const PD_NumberConstant(0),
    this.y = const PD_NumberConstant(0),
    this.z = const PD_NumberConstant(0),
  });

  @override
  Vector3 value(double progress) {
    return Vector3(
      x.value(progress),
      y.value(progress),
      z.value(progress),
    );
  }

  @override
  PD_Vector3 clone() {
    return PD_Vector3(
      x: x.clone(),
      y: y.clone(),
      z: z.clone(),
    );
  }
}

class PD_Vector3RandomBetweenTwoConstants extends PD_Vector3 {
  final Vector3 min;
  final Vector3 max;
  Vector3 _result = Vector3(0, 0, 0);

  PD_Vector3RandomBetweenTwoConstants(this.min, this.max) {
    _result = Vector3(
      ParticleUtils.randomBetween(min.x, max.x),
      ParticleUtils.randomBetween(min.y, max.y),
      ParticleUtils.randomBetween(min.z, max.z),
    );
  }

  @override
  Vector3 value(double progress) {
    return _result;
  }

  @override
  PD_Vector3RandomBetweenTwoConstants clone() {
    return PD_Vector3RandomBetweenTwoConstants(min, max);
  }
}

class PD_Vector3Curve extends PD_Vector3 {
  final Curve curve;
  final PD_Vector3 begin;
  final PD_Vector3 end;

  const PD_Vector3Curve({
    required this.curve,
    required this.begin,
    required this.end,
  });

  @override
  Vector3 value(double progress) {
    return Vector3(
      lerpDouble(begin.x.value(0), end.x.value(0), curve.transform(progress))!,
      lerpDouble(begin.y.value(0), end.y.value(0), curve.transform(progress))!,
      lerpDouble(begin.z.value(0), end.z.value(0), curve.transform(progress))!,
    );
  }

  @override
  PD_Vector3Curve clone() {
    return PD_Vector3Curve(
      curve: curve,
      begin: begin.clone(),
      end: end.clone(),
    );
  }
}
