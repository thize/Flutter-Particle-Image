part of particle_image;

abstract class PD_EmissionShape {
  final double? uniformLoop;

  const PD_EmissionShape({required this.uniformLoop});

  Random get _random => Random();

  void paint(Canvas canvas, Offset offset, Paint paint, Size totalSize) {}

  (Offset position, Offset direction) apply(Size totalSize) {
    var position = _position(totalSize);
    return (position, _direction(position));
  }

  Offset _position(Size totalSize) => Offset.zero;

  Offset _direction(Offset position) {
    return ParticleUtils.normalized(position - Offset.zero);
  }
}

abstract class PD_FitRect extends PD_EmissionShape {
  final bool fitRect;

  const PD_FitRect({
    this.fitRect = false,
    super.uniformLoop,
  });
}

abstract class PD_EmitOnSurface extends PD_FitRect {
  final bool emitOnSurface;

  const PD_EmitOnSurface({
    this.emitOnSurface = true,
    super.fitRect = false,
    super.uniformLoop,
  });
}

class PD_EmissionShapePoint extends PD_EmissionShape {
  const PD_EmissionShapePoint({
    super.uniformLoop,
  });

  @override
  Offset _direction(Offset position) {
    return Offset(
      _random.nextDouble() * 2 - 1,
      _random.nextDouble() * 2 - 1,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, Paint paint, Size totalSize) {
    paint.strokeWidth = 3;
    canvas.drawCircle(
      offset,
      2,
      paint,
    );
  }
}

class PD_EmissionShapeCircle extends PD_EmitOnSurface {
  final double radius;

  const PD_EmissionShapeCircle({
    this.radius = 50,
    super.fitRect = false,
    super.emitOnSurface = true,
    super.uniformLoop,
  });

  @override
  Offset _position(Size totalSize) {
    double toUseRadius = radius;
    if (fitRect) {
      toUseRadius = min(totalSize.width, totalSize.height) / 2;
    }

    if (emitOnSurface) {
      toUseRadius = _random.nextDouble() * toUseRadius;
    }

    double randomAngle = _random.nextDouble() * 2 * pi;
    double x = toUseRadius * cos(randomAngle);
    double y = toUseRadius * sin(randomAngle);

    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Offset offset, Paint paint, Size totalSize) {
    final toUseRadius =
        fitRect ? min(totalSize.width, totalSize.height) / 2 : radius;
    canvas.drawCircle(
      offset,
      toUseRadius,
      paint,
    );
  }
}

class PD_EmissionShapeRectangle extends PD_EmitOnSurface {
  final Size size;

  const PD_EmissionShapeRectangle({
    this.size = const Size(100, 100),
    super.fitRect = false,
    super.emitOnSurface = true,
  });

  @override
  Offset _position(Size totalSize) {
    Size toUseSize = size;
    if (fitRect) {
      toUseSize = totalSize;
    }
    if (emitOnSurface) {
      return _applyOnSurface(toUseSize);
    }
    return _applyOnBounds(toUseSize);
  }

  Offset _applyOnSurface(Size size) {
    double x = _random.nextDouble() * size.width - size.width / 2;
    double y = _random.nextDouble() * size.height - size.height / 2;
    return Offset(x, y);
  }

  Offset _applyOnBounds(Size size) {
    int edge = _random.nextInt(4);

    // Gerar uma posição aleatória ao longo da borda escolhida
    double x = 0, y = 0;
    switch (edge) {
      case 0: // Top edge
        x = _random.nextDouble() * size.width;
        y = 0.0;
        break;
      case 1: // Right edge
        x = size.width;
        y = _random.nextDouble() * size.height;
        break;
      case 2: // Bottom edge
        x = _random.nextDouble() * size.width;
        y = size.height;
        break;
      case 3: // Left edge
        x = 0.0;
        y = _random.nextDouble() * size.height;
        break;
    }
    return Offset(x - size.width / 2, y - size.height / 2);
  }

  @override
  void paint(Canvas canvas, Offset offset, Paint paint, Size totalSize) {
    final toUseSize = fitRect ? totalSize : size;
    canvas.drawRect(
      Rect.fromCenter(
        center: offset,
        width: toUseSize.width,
        height: toUseSize.height,
      ),
      paint,
    );
  }
}

class PD_EmissionShapeLine extends PD_FitRect {
  final double length;

  const PD_EmissionShapeLine({
    this.length = 100,
    super.fitRect = false,
  });

  @override
  Offset _direction(Offset position) {
    return const Offset(0, -1);
  }

  @override
  Offset _position(Size totalSize) {
    final toUseLength = fitRect ? totalSize.width : length;
    final mid = toUseLength / 2;
    double x = _random.nextDouble() * toUseLength - mid;
    return Offset(x, 0);
  }

  @override
  void paint(Canvas canvas, Offset offset, Paint paint, Size totalSize) {
    final toUseLength = fitRect ? totalSize.width : length;
    final mid = Offset(toUseLength / 2, 0);
    canvas.drawLine(
      offset - mid,
      offset + mid,
      paint,
    );
  }
}

class PD_EmissionShapeDirectional extends PD_EmissionShape {
  final double angle;

  const PD_EmissionShapeDirectional({
    this.angle = 45,
    super.uniformLoop,
  });

  @override
  Offset _direction(Offset position) {
    final randomAngle = _random.nextDouble() * angle - (angle / 2);
    final radiansAngle = _toRadians(randomAngle - 90);
    final x = cos(radiansAngle);
    final y = sin(radiansAngle);
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Offset offset, Paint paint, Size totalSize) {
    const double radius = 100;
    final double centerX = offset.dx;
    final double centerY = offset.dy;

    final halfAngle = angle / 2;

    final double radiansAngle = _toRadians(halfAngle);

    final double startAngle = _toRadians(-90 - halfAngle);
    final sweepAngle = radiansAngle * 2;

    final rect =
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    final path = Path()
      ..moveTo(centerX, centerY)
      ..lineTo(centerX + cos(startAngle) * radius,
          centerY + sin(startAngle) * radius)
      ..moveTo(
        centerX + cos(startAngle + sweepAngle) * radius,
        centerY + sin(startAngle + sweepAngle) * radius,
      )
      ..lineTo(centerX, centerY);

    canvas.drawPath(path, paint);
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

class EmissionDebugPainter extends CustomPainter {
  final ParticleData particle;
  final Size totalSize;

  const EmissionDebugPainter({
    required this.particle,
    required this.totalSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xff6FFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    Offset center = size.center(Offset.zero);
    particle.emission.shape.paint(canvas, center, paint, totalSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
