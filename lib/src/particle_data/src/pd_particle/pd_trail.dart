part of particle_image;

class PD_Trail {
  final double ratio;
  final double vertexDistance;
  final double lifetime;
  final PD_Number width;
  final PD_Color colorOverTrail;
  final bool dieWithParticle;

  PD_Trail({
    this.ratio = 1,
    this.vertexDistance = 10,
    this.lifetime = 1,
    this.width = const PD_NumberConstant(1),
    this.colorOverTrail = const PD_ColorSingle(),
    this.dieWithParticle = false,
  }) : assert(ratio >= 0 && ratio <= 1);

  void draw(Canvas canvas, double currentProgress, Particle particle) {
    List<TrailPoint> trailPoints = particle.trailPoints;
    // remove old points
    while (trailPoints.isNotEmpty &&
        particle._totalElapsedMillis - trailPoints.first.startElapsedMillis >
            lifetime * 1000) {
      trailPoints.removeAt(0);
    }

    if (trailPoints.length < 2) {
      return; // No trail to draw
    }

    Path path = Path();
    Paint trailPaint = Paint()..style = PaintingStyle.fill;

    // Add the first point as the starting point
    TrailPoint firstPoint = trailPoints[0];
    Offset start = firstPoint.position;
    path.moveTo(start.dx, start.dy);

    // Add points to form one side of the trail
    for (int i = 1; i < trailPoints.length; i++) {
      TrailPoint point = trailPoints[i];
      Offset position = point.position;

      double lerpProgress = i / (trailPoints.length - 1);
      double currentWidth = width.value(0) * (1 - lerpProgress);
      Offset direction = position - start;

      // Calculate the perpendicular direction for width
      Offset perpendicular =
          Offset(-direction.dy, direction.dx) * currentWidth / 2;

      path.lineTo(
          position.dx + perpendicular.dx, position.dy + perpendicular.dy);
    }

    // Add points to form the other side of the trail (in reverse order)
    for (int i = trailPoints.length - 1; i >= 0; i--) {
      TrailPoint point = trailPoints[i];
      Offset position = point.position;

      double lerpProgress = i / (trailPoints.length - 1);
      double currentWidth = width.value(0) * (1 - lerpProgress);
      Offset direction = position - start;

      // Calculate the perpendicular direction for width
      Offset perpendicular =
          Offset(direction.dy, -direction.dx) * currentWidth / 2;

      path.lineTo(
          position.dx + perpendicular.dx, position.dy + perpendicular.dy);
    }

    // Close the path to form the triangle shape
    path.close();

    // Calculate the color for the trail
    Color startColor = colorOverTrail.value(0);
    Color endColor = colorOverTrail.value(1);
    trailPaint.color = Color.lerp(startColor, endColor, currentProgress)!;

    // Draw the path
    canvas.drawPath(path, trailPaint);
  }
}

class TrailPoint {
  Offset position;
  int startElapsedMillis;

  TrailPoint(this.position, this.startElapsedMillis);
}
