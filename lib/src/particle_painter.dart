part of particle_image;

class ParticleImagePainter extends CustomPainter {
  final List<Particle> particles;
  final ui.Image shapesSpriteSheet;

  ParticleImagePainter({
    required this.particles,
    required this.shapesSpriteSheet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      _drawParticle(canvas, particle, size);
      particle.drawExtra(canvas);
    }
  }

  void _drawParticle(Canvas canvas, Particle particle, Size size) {
    final (image, rect, transform, color) =
        particle.computeTransformation(shapesSpriteSheet);
    final paint = Paint()
      ..color = color
      ..blendMode = BlendMode.src;
    final matrix = _createMatrix(transform, size);

    canvas.save();
    canvas.transform(matrix.storage);

    final rectDest = Rect.fromLTWH(
      0,
      0,
      rect.width / 2,
      rect.height / 2,
    );

    canvas.saveLayer(rectDest, Paint());
    canvas.drawImageRect(
      image,
      rect,
      rectDest,
      paint,
    );
    canvas.restore(); // Restoring the saveLayer
    canvas.restore(); // Restoring the initial save
  }

  Matrix4 _createMatrix(RSTransform transform, Size size) {
    return Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..rotateX(ParticleUtils.toRadians(0))
      ..rotateY(ParticleUtils.toRadians(0))
      ..rotateZ(ParticleUtils.toRadians(0))
      ..translate(transform.tx, transform.ty);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return particles.isNotEmpty;
  }
}
