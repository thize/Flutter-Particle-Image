part of particle_image;

abstract class PD_Duration extends PD_Progress<PD_Duration, Duration> {
  const PD_Duration();
}

class PD_DurationConstant extends PD_Duration {
  final Duration constValue;

  const PD_DurationConstant(this.constValue);

  @override
  Duration value(double progress) => constValue;

  @override
  PD_Duration clone() {
    return PD_DurationConstant(constValue);
  }
}

class PD_DurationRandom extends PD_Duration {
  final Duration min;
  final Duration max;
  Duration _result = Duration.zero;

  PD_DurationRandom(this.min, this.max) {
    _result = Duration(
        milliseconds: ParticleUtils.randomBetweenInt(
            min.inMilliseconds, max.inMilliseconds));
  }

  @override
  Duration value(double progress) => _result;

  @override
  PD_Duration clone() {
    return PD_DurationRandom(min, max);
  }
}
