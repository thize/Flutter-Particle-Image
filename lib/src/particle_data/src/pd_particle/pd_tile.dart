part of particle_image;

abstract class PD_Tile {
  final int rows;
  final int columns;
  final PD_Number startFrame;

  const PD_Tile({
    this.rows = 1,
    this.columns = 1,
    this.startFrame = const PD_NumberConstant(0),
  });

  double frameByTime(double progress, int totalElapsedMillis);

  int columnByFrame(double frame) {
    return (frame).floor() % columns;
  }

  int rowByFrame(double frame) {
    return ((frame).floor() / columns).floor() % rows;
  }

  PD_Tile clone();
}

class PD_TileStatic extends PD_Tile {
  const PD_TileStatic({
    super.rows = 1,
    super.columns = 1,
    super.startFrame = const PD_NumberConstant(0),
  });

  @override
  double frameByTime(double progress, int totalElapsedMillis) {
    return startFrame.value(0);
  }

  @override
  PD_TileStatic clone() {
    return PD_TileStatic(
      rows: rows,
      columns: columns,
      startFrame: startFrame.clone(),
    );
  }
}

class PD_TileFPS extends PD_Tile {
  final int fps;

  const PD_TileFPS({
    super.rows = 1,
    super.columns = 1,
    super.startFrame = const PD_NumberConstant(0),
    this.fps = 25,
  });

  @override
  double frameByTime(double progress, int totalElapsedMillis) {
    if (fps == 1) {
      return startFrame.value(progress);
    }
    double _startFrame = startFrame.clone().value(progress);
    double frame = (totalElapsedMillis / 1000) * fps;
    frame = frame.floorToDouble();
    return frame + _startFrame;
  }

  @override
  PD_TileFPS clone() {
    return PD_TileFPS(
      rows: rows,
      columns: columns,
      startFrame: startFrame.clone(),
      fps: fps,
    );
  }
}
