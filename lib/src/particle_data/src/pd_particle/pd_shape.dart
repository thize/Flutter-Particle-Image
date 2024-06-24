part of particle_image;

abstract class PD_Shape {
  final String shapePath;
  final PD_Tile? tile;

  static const _shapeSpriteSheetPath =
      "packages/particle_image/assets/images/default.png";

  PD_Shape({
    required this.shapePath,
    this.tile,
  });

  PD_Shape clone();

  int? _hash;
  int get hash => _hash ??= shapePath.hashCode;

  Size _getSpriteSize(ui.Image image, Particle particle, double progress) {
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();
    return Size(imageWidth, imageHeight);
  }

  (Rect, Offset, double) computeImage(
    Particle particle,
    ui.Image image,
    double progress,
    int totalElapsedMillis,
  ) {
    Size particleSize = particle.sizeOverLifetime.value(progress);

    double aspectRatio = (particleSize.height != 0)
        ? (particleSize.width / particleSize.height)
        : 1.0;

    Size imageSize = _getSpriteSize(image, particle, progress);
    int columns = tile?.columns ?? 1;
    int rows = tile?.rows ?? 1;
    double width = imageSize.width / columns;
    double height = imageSize.height / rows;
    double frame = tile?.frameByTime(progress, totalElapsedMillis) ?? 0;
    int columnByFrame = tile?.columnByFrame(frame) ?? 0;
    int rowByFrame = tile?.rowByFrame(frame) ?? 0;
    double particleAspectRatio = (height != 0) ? (width / height) : 1.0;

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
    Offset anchor = Offset(width / 2, height / 2);
    double scale = (width != 0) ? (particleSize.width / width) : 1.0;

    return (rect, anchor, scale);
  }
}

class PD_ShapeCircle extends PD_Shape {
  PD_ShapeCircle()
      : super(
          tile: const PD_TileStatic(
            rows: 1,
            columns: 2,
            startFrame: PD_NumberConstant(1),
          ),
          shapePath: PD_Shape._shapeSpriteSheetPath,
        );

  @override
  PD_ShapeCircle clone() => PD_ShapeCircle();
}

class PD_ShapeSquare extends PD_Shape {
  PD_ShapeSquare()
      : super(
          tile: const PD_TileStatic(rows: 1, columns: 2),
          shapePath: PD_Shape._shapeSpriteSheetPath,
        );

  @override
  PD_ShapeSquare clone() => PD_ShapeSquare();
}

class PD_ShapeImage extends PD_Shape {
  PD_ShapeImage(String shapePath, {super.tile}) : super(shapePath: shapePath);

  @override
  PD_ShapeImage clone() => PD_ShapeImage(shapePath, tile: tile?.clone());
}
