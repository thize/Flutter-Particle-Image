part of particle_image;

class PD_Trail {
  final double ratio;
  final double vertexDistance;
  final double lifetime;
  final PD_Number width;
  final bool inheritParticleColor;
  final PD_Color colorOverLifetime;
  final PD_Color colorOverTrail;
  final bool dieWithParticle;

  PD_Trail({
    this.ratio = 1,
    this.vertexDistance = 10,
    this.lifetime = 1,
    this.width = const PD_NumberConstant(1),
    this.colorOverLifetime = const PD_ColorSingle(),
    this.colorOverTrail = const PD_ColorSingle(),
    this.inheritParticleColor = false,
    this.dieWithParticle = false,
  }) : assert(ratio >= 0 && ratio <= 1);

  void draw(
    Canvas canvas,
    double currentProgress,
    Particle particle,
  ) {
    List<TrailPoint> trailPoints = particle.trailPoints;

    if (trailPoints.length < 2) {
      return; // No trail to draw
    }

    Paint trailPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width.value(0);

    for (int i = 1; i < trailPoints.length; i++) {
      TrailPoint startPoint = trailPoints[i - 1];
      TrailPoint endPoint = trailPoints[i];

      double startTime = startPoint.time;
      double endTime = endPoint.time;

      Color startColor = colorOverTrail.value(0);
      Color endColor = colorOverTrail.value(1);

      double lerpProgress =
          (currentProgress - startTime) / (endTime - startTime);
      Color color = Color.lerp(startColor, endColor, lerpProgress)!;
      trailPaint.color = color;

      Offset start = startPoint.position;
      Offset end = endPoint.position;

      canvas.drawLine(start, end, trailPaint);
    }
  }
}

class TrailPoint {
  Offset position;
  double time;

  TrailPoint(this.position, this.time);
}
