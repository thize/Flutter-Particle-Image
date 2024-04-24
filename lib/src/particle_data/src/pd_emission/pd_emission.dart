part of particle_image;

class PD_Emission {
  final double ratePerSecond;
  final int rateOverDuration;
  final List<PD_Burst> bursts;
  final PD_EmissionShape shape;

  const PD_Emission({
    this.ratePerSecond = 0,
    this.rateOverDuration = 0,
    this.bursts = const [],
    this.shape = const PD_EmissionShapeCircle(),
  });
}

class PD_Burst {
  final Duration time;
  final int count;

  const PD_Burst({
    this.time = const Duration(seconds: 1),
    this.count = 0,
  });
}
