part of particle_image;

class ParticleImagePainter extends CustomPainter {
  final List<Particle> particles;

  final ui.Image shapesSpriteSheet;

  final Set<ui.Image> _allImages = {};
  final Map<ui.Image, List<RSTransform>> _transformsPerImage = {};
  final Map<ui.Image, List<Rect>> _rectsPerImage = {};
  final Map<ui.Image, List<Color>> _colorsPerImage = {};

  ParticleImagePainter({
    required this.particles,
    required this.shapesSpriteSheet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _clearTransformations();
    for (var activeParticle in particles) {
      _updateTransformations(activeParticle, size);
      activeParticle.drawExtra(canvas);
    }
    for (var image in _allImages) {
      canvas.drawAtlas(
        image,
        _transformsPerImage[image] ?? [],
        _rectsPerImage[image] ?? [],
        _colorsPerImage[image] ?? [],
        BlendMode.dstIn,
        null,
        Paint(),
      );
    }
  }

  void _clearTransformations() {
    _transformsPerImage.clear();
    _rectsPerImage.clear();
    _colorsPerImage.clear();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return particles.isNotEmpty;
  }

  void _updateTransformations(Particle particle, Size size) {
    final (image, rect, transform, color) =
        particle.computeTransformation(shapesSpriteSheet);
    _allImages.add(image);
    _rectsPerImage.update(
      image,
      (rects) => rects..add(rect),
      ifAbsent: () => [rect],
    );
    _transformsPerImage.update(
      image,
      (transforms) => transforms..add(_bySize(transform, size)),
      ifAbsent: () => [_bySize(transform, size)],
    );
    if (particle.data.settings.shape is! PD_ShapeImage) {
      _colorsPerImage.update(
        image,
        (colors) => colors..add(color),
        ifAbsent: () => [color],
      );
    }
  }

  RSTransform _bySize(RSTransform transform, Size size) {
    return RSTransform(
      transform.scos,
      transform.ssin,
      transform.tx + size.width / 2,
      transform.ty + size.height / 2,
    );
  }
}
