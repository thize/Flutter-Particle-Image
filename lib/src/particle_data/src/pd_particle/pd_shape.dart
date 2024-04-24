part of particle_image;

abstract class PD_Shape {
  final String shapePath;

  const PD_Shape(this.shapePath);

  Future<ui.Image> buildShape() => rootBundle.loadImage(shapePath);

  (ui.Image, Rect, RSTransform, Color) computeTransformation(Particle particle,
      ui.Image image, double progress, int totalElapsedMillis);

  PD_Shape clone();
}

abstract class _PD_ShapeImage extends PD_Shape {
  final PD_Tile? tile;

  static const _shapeSpriteSheetPath =
      "packages/particle_image/assets/images/default.png";

  const _PD_ShapeImage({
    required String shapePath,
    this.tile,
  }) : super(shapePath);

  Size _getSpriteSize(ui.Image image, Particle particle, double progress) {
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();
    return Size(imageWidth, imageHeight);
  }

  Size _processSize(Particle particle, double progress) {
    Size scale = particle.sizeOverLifetime.value(progress);
    double sizeWidth = particle.startSize.width * scale.width;
    double sizeHeight = particle.startSize.height * scale.height;
    return Size(sizeWidth, sizeHeight);
  }

  @override
  (ui.Image, Rect, RSTransform, Color) computeTransformation(
    Particle particle,
    ui.Image image,
    double progress,
    int totalElapsedMillis,
  ) {
    Size imageSize = _getSpriteSize(image, particle, progress);
    Size particleSize = _processSize(particle, progress);
    int columns = tile?.columns ?? 1;
    int rows = tile?.rows ?? 1;
    double width = imageSize.width / columns;
    double height = imageSize.height / rows;
    double frame = tile?.frameByTime(progress, totalElapsedMillis) ?? 0;
    int columnByFrame = tile?.columnByFrame(frame) ?? 0;
    int rowByFrame = tile?.rowByFrame(frame) ?? 0;
    double aspectRatio = particleSize.width / particleSize.height;
    double particleAspectRatio = width / height;
    if (aspectRatio > particleAspectRatio) {
      height = width / aspectRatio;
    } else {
      width = height * aspectRatio;
    }
    final rect = Rect.fromLTWH(
      columnByFrame * width,
      rowByFrame * height,
      width,
      height,
    );
    final transform = RSTransform.fromComponents(
      rotation: 0,
      scale: particleSize.width / width,
      anchorX: width / 2,
      anchorY: height / 2,
      translateX: particle.position.dx,
      translateY: particle.position.dy,
    );
    final color = particle.startColor;
    return (image, rect, transform, color);
  }
}

class PD_ShapeCircle extends _PD_ShapeImage {
  const PD_ShapeCircle()
      : super(
          tile: const PD_TileStatic(
            rows: 1,
            columns: 2,
            startFrame: PD_NumberConstant(1),
          ),
          shapePath: _PD_ShapeImage._shapeSpriteSheetPath,
        );

  @override
  PD_ShapeCircle clone() {
    return const PD_ShapeCircle();
  }
}

class PD_ShapeSquare extends _PD_ShapeImage {
  const PD_ShapeSquare()
      : super(
          tile: const PD_TileStatic(
            rows: 1,
            columns: 2,
          ),
          shapePath: _PD_ShapeImage._shapeSpriteSheetPath,
        );

  @override
  PD_ShapeSquare clone() {
    return const PD_ShapeSquare();
  }
}

class PD_ShapeImage extends _PD_ShapeImage {
  const PD_ShapeImage(String shapePath, {super.tile})
      : super(
          shapePath: shapePath,
        );

  @override
  PD_ShapeImage clone() {
    return PD_ShapeImage(shapePath, tile: tile?.clone());
  }
}
