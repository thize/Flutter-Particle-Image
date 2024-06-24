part of particle_image;

/// The `ParticleImagePainter` class is a custom painter responsible for rendering particles on a canvas.
/// It utilizes a `ParticleEmitter` to retrieve and draw the particles based on their current state and properties.
class ParticleImagePainter extends CustomPainter {
  final ParticleEmitter? emitter;

  final Paint _paint = Paint()
    ..color = const Color(0xff6FFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  ParticleImagePainter({super.repaint, required this.emitter});

  @override
  void paint(Canvas canvas, Size size) {
    if (emitter == null || emitter!.isKilled) return;

    for (final particleData in emitter!.particles.keys) {
      ParticleDraw? draw = emitter!.particlesDraw[particleData];
      if (draw == null) continue;
      // if (ParticleImage.withDebug) {
      //   particleData.emission.shape.paint(
      //     canvas,
      //     Offset.zero + size.center(Offset.zero),
      //     _paint,
      //     size,
      //   );
      // }

      for (final particle in emitter!.particles[particleData]!) {
        particle.drawExtra(canvas);
        canvas.drawAtlas(
          draw.image,
          draw.transforms,
          draw.rectangles,
          draw.colors,
          BlendMode.modulate,
          null,
          _paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
