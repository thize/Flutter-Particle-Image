// ignore_for_file: overridden_fields

part of particle_image;

/// The `Particle` class represents a single particle in an animation, containing both immutable and mutable properties that define its behavior and appearance.
/// It manages the lifecycle of the `Particle`, including its initial data setup and updates during its lifetime.

/*
✅ Progress
✅ Color over Lifetime
✅ Size over Lifetime
✅ Speed over Lifetime
✅ Rotation Z over Lifetime
✅ Gravity
✅ Shape and Direction
✅ Vortex
✅ Attractions
⬜ Trail
*/
class Particle {
  //! Immutable properties
  final ParticleData data;
  final Function() onDead;
  final ParticleEmitter emitter;

  late PD_Number speedOverLifetime;
  late PD_Vector3 rotationOverLifetime;
  late PD_Size sizeOverLifetime;
  late PD_Color colorOverLifetime;

  late int startDurationInMilliseconds;
  late int endDurationInMilliseconds;

  Particle({
    required this.data,
    required this.onDead,
    required this.emitter,
  });

  //! Mutable properties
  ParticleColor color = ParticleColor(0);
  ParticleTransform transform = ParticleTransform(0, 0, 0, 0);
  ParticleRect rect = ParticleRect.fromLTWH(0, 0, 0, 0);
  double progress = 0;
  Offset startPosition = Offset.zero;
  Offset _nextPosition = Offset.zero;
  Offset _modifedPosition = Offset.zero;

  Offset _direction = Offset.zero;
  Offset _velocity = Offset.zero;

  double _fixedTime = 1;
  int _totalElapsedMillis = 0;
  List<TrailPoint> trailPoints = [];

  //! Getters
  bool get isDone => progress == 1;

  //! Methods

  void setInitialData({required int totalElapsedMillis}) {
    progress = 0;
    isDead = false;
    _totalElapsedMillis = totalElapsedMillis;
    startDurationInMilliseconds = totalElapsedMillis;
    endDurationInMilliseconds = totalElapsedMillis +
        data.settings.time.lifetime.clone().value(0).inMilliseconds;
    speedOverLifetime = data.settings.speed.clone();
    rotationOverLifetime = data.settings.rotation.clone();
    sizeOverLifetime = data.settings.size.clone();
    colorOverLifetime = data.settings.color.clone();
    Color startColor = colorOverLifetime.value(0);
    color.update(
      startColor.alpha,
      startColor.red,
      startColor.green,
      startColor.blue,
    );
    var (Offset position, Offset direction) =
        data.emission.shape.apply(emitter.size);
    _direction = ParticleUtils.normalized(direction);
    startPosition = position;
    _nextPosition = startPosition;
    _modifedPosition = startPosition;
    double startSpeed = speedOverLifetime.value(0);
    _velocity = _direction * startSpeed;
    _applyTransformAndRect();
    trailPoints.clear();
  }

  void update(int totalElapsedMillis) {
    if (isDone) {
      kill();
      return;
    }
    int elapsedSinceLastUpdate = totalElapsedMillis - _totalElapsedMillis;
    _totalElapsedMillis = totalElapsedMillis;
    _fixedTime = elapsedSinceLastUpdate / 10;
    _updateProgress();

    _velocity = _direction * speedOverLifetime.value(progress);
    _applyColorOverLifetime();
    _applySizeOverLifetime();
    _applyGravity();

    _applyVortex();
    _applyVelocity();
    if (!_applyAttractor()) {
      _nextPosition = _modifedPosition;
    }
    _applyTransformAndRect();

    _updateTrail(totalElapsedMillis);
  }

  void _updateProgress() {
    progress = (_totalElapsedMillis - startDurationInMilliseconds) /
        (endDurationInMilliseconds - startDurationInMilliseconds);
    if (progress >= 1) progress = 1;
  }

  void _applyColorOverLifetime() {
    final c = colorOverLifetime.value(progress);
    color.update(c.alpha, c.red, c.green, c.blue);
  }

  void _applySizeOverLifetime() {
    final s = sizeOverLifetime.value(progress);
    rect.update(100, 100);
    // TODO: fix
    // rect.update(s.width, s.height);
  }

  void _applyGravity() {
    PD_MovementGravity? gravity = data.movement.gravity;
    if (gravity == null) return;
    double force = gravity.force(progress);
    _velocity = _velocity + Offset(0, force);
  }

  void _applyVortex() {
    PD_MovementVortex? vortex = data.movement.vortex;
    if (vortex == null) return;

    double strength = vortex.strength.value(progress);
    _modifedPosition = ParticleUtils.rotatePointArroundCenter(
      _modifedPosition,
      strength * _fixedTime,
    );
  }

  void _applyVelocity() {
    Offset useVelocity = _velocity;

    PD_MovementVelocity? velocity = data.movement.velocity;
    if (velocity != null) {
      Offset res = velocity.offset.value(progress);
      useVelocity += Offset(
        res.dx,
        -res.dy,
      );
    }
    _modifedPosition = _modifedPosition + useVelocity * _fixedTime;
  }

  bool _applyAttractor() {
    PD_MovementAttractor? attractor = data.movement.attractor;
    if (attractor == null) {
      return false;
    }

    Offset targetGlobalPosition = attractor.target();
    double progressLerp = attractor.progressLerp(progress);

    Offset emitterGlobalPosition = emitter.position;
    Offset targetLocalPosition = targetGlobalPosition - emitterGlobalPosition;

    Offset lerp = ParticleUtils.lerpUnclamped(
      _modifedPosition,
      targetLocalPosition,
      progressLerp,
    );
    _nextPosition = lerp;
    return true;
  }

  void _applyTransformAndRect() {
    ui.Image image = emitter.particlesDraw[data]!.image;
    final (Rect _rect, anchor, scale) = data.settings.shape
        .computeImage(this, image, progress, _totalElapsedMillis);
    transform.update(
      rotation: _getRotation(),
      translateX: _nextPosition.dx,
      translateY: _nextPosition.dy,
      anchorX: anchor.dx,
      anchorY: anchor.dy,
      scale: scale,
    );
    rect.fromRect(_rect);
  }

  double _getRotation() {
    if (data.settings.alignToDirection) {
      Offset direction = _velocity;

      PD_MovementAttractor? attractor = data.movement.attractor;
      if (attractor != null) {
        Offset targetGlobalPosition = attractor.target();
        Offset emitterGlobalPosition = emitter.position;
        Offset targetLocalPosition =
            targetGlobalPosition - emitterGlobalPosition;
        direction = targetLocalPosition - _modifedPosition;
      }

      return math.atan2(direction.dy, direction.dx) + math.pi / 2;
    }
    return rotationOverLifetime.value(progress).z;
  }

  void _updateTrail(int totalElapsedMillis) {
    if (data.settings.trail == null) return;
    if (trailPoints.isEmpty ||
        _totalElapsedMillis - trailPoints.last.startElapsedMillis >
            data.settings.trail!.vertexDistance) {
      trailPoints.add(TrailPoint(_nextPosition, totalElapsedMillis));
    }
    trailPoints.removeWhere((point) =>
        (totalElapsedMillis - point.startElapsedMillis) >
        data.settings.trail!.lifetime * 1000);
  }

  bool isDead = false;

  void kill() {
    if (isDead) return;
    isDead = true;
    color.update(
      0,
      color.red,
      color.green,
      color.blue,
    );
    onDead();
    progress = 1;
  }

  void drawExtra(Canvas canvas) {
    data.settings.trail?.draw(canvas, progress, this);
  }
}

/// Dedicated transform class for pooling system
/// Help to reuse transforms after rendering
/// A transform class for particles in pooling system.
class ParticleTransform extends RSTransform {
  /// Scaled cosine of transform.
  double _scaledCos = 0;

  /// Scaled sine of transform.
  double _scaledSin = 0;

  /// Translate value in x
  double _tx = 0;

  /// Translate value in y
  double _ty = 0;

  /// Creates a new particle transform.
  ParticleTransform(super.scos, super.ssin, super.tx, super.ty);

  /// Update all transform specs
  void update({
    required double rotation,
    required double scale,
    required double anchorX,
    required double anchorY,
    required double translateX,
    required double translateY,
  }) {
    _scaledCos = math.cos(rotation) * scale;
    _scaledSin = math.sin(rotation) * scale;
    _tx = translateX - _scaledCos * anchorX + _scaledSin * anchorY;
    _ty = translateY - _scaledSin * anchorX - _scaledCos * anchorY;
  }

  /// The cosine of the rotation multiplied by the scale factor.
  @override
  double get scos => _scaledCos;

  /// The sine of the rotation multiplied by that same scale factor.
  @override
  double get ssin => _scaledSin;

  /// The x coordinate of the translation, minus [scos] multiplied by the
  /// x-coordinate of the rotation point, plus [ssin] multiplied by the
  /// y-coordinate of the rotation point.
  @override
  double get tx => _tx;

  /// The y coordinate of the translation, minus [ssin] multiplied by the
  /// x-coordinate of the rotation point, minus [scos] multiplied by the
  /// y-coordinate of the rotation point.
  @override
  double get ty => _ty;
}

/// Dedicated color class for pooling system
/// Help to reuse colors after rendering
class ParticleColor extends Color {
  @override
  int value = 0;

  ParticleColor(super.value);

  /// Updates the color channels separately.
  ///
  /// The parameters [a], [r], [g], and [b] represent the alpha, red, green,
  /// and blue color channels respectively. Each channel is expected to be a
  /// value between 0 and 255.
  ///
  /// The color value of this [ParticleColor] object is updated with the
  /// provided color channels.
  void update(int a, int r, int g, int b) {
    // Combine the color channels into a single integer value.
    value = (((a & 0xff) <<
                24) | // Shift alpha channel and bitwise AND with 0xff
            ((r & 0xff) << 16) | // Shift red channel and bitwise AND with 0xff
            ((g & 0xff) << 8) | // Shift green channel and bitwise AND with 0xff
            ((b & 0xff) << 0)) & // Shift blue channel and bitwise AND with 0xff
        0xFFFFFFFF; // Mask the result to 32 bits
  }

  /// Linearly interpolates the color channels of this [ParticleColor]
  /// instance between the provided [from] and [to] colors using the
  /// given interpolation [delta].
  ///
  /// The color channels are interpolated separately using the [_lerpInt]
  /// function. The resulting interpolated color channels are then used to
  /// update the color of this [ParticleColor] instance using the [update]
  /// method.
  ///
  /// Parameters:
  ///   - from: The starting color.
  ///   - to: The ending color.
  ///   - delta: The interpolation factor.
  void lerp(Color from, Color to, double delta) {
    update(
      _clampInt(_lerpInt(from.alpha, to.alpha, delta).toInt(), 0, 255),
      _clampInt(_lerpInt(from.red, to.red, delta).toInt(), 0, 255),
      _clampInt(_lerpInt(from.green, to.green, delta).toInt(), 0, 255),
      _clampInt(_lerpInt(from.blue, to.blue, delta).toInt(), 0, 255),
    );
  }

  /// Linearly interpolates between two integers.
  ///
  /// The function takes in the starting integer [from], the ending integer
  /// [to], and the interpolation factor [delta]. It returns the interpolated
  /// value as a [double].
  ///
  /// Parameters:
  ///   - from: The starting integer.
  ///   - to: The ending integer.
  ///   - delta: The interpolation factor.
  ///
  /// Returns:
  ///   The interpolated value as a [double].
  double _lerpInt(int from, int to, double delta) => from + (to - from) * delta;

  /// Clamps the given [value] between the specified [min] and [max]
  /// boundaries.
  ///
  /// If [value] is less than [min], this function returns [min]. If [value] is
  /// greater than [max], this function returns [max]. Otherwise, it returns
  /// [value] itself.
  ///
  /// This method is a specialized version of [num.clamp] that is optimized for
  /// use with non-nullable [int] values.
  ///
  /// Parameters:
  ///   - [value]: The value to be clamped.
  ///   - [min]: The lower boundary of the range.
  ///   - [max]: The upper boundary of the range.
  ///
  /// Returns:
  ///   - The clamped value.
  int _clampInt(int value, int min, int max) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }

  /// The alpha channel of this color in an 8 bit value.
  ///
  /// A value of 0 means this color is fully transparent. A value of 255 means
  /// this color is fully opaque.
  @override
  int get alpha => (0xff000000 & value) >> 24;

  /// The red channel of this color in an 8 bit value.
  @override
  int get red => (0x00ff0000 & value) >> 16;

  /// The green channel of this color in an 8 bit value.
  @override
  int get green => (0x0000ff00 & value) >> 8;

  /// The blue channel of this color in an 8 bit value.
  @override
  int get blue => (0x000000ff & value) >> 0;
}

/// Help to reuse colors after rendering
class ParticleRect extends Rect {
  /// The offset of the left edge of this rectangle from the x axis.
  @override
  double left = 0;

  /// The offset of the top edge of this rectangle from the y axis.
  @override
  double top = 0;

  /// The offset of the right edge of this rectangle from the x axis.
  @override
  double right = 0;

  /// The offset of the bottom edge of this rectangle from the y axis.
  @override
  double bottom = 0;

  /// Creates a [ParticleRect] from the left, top, width, and height parameters.
  ///
  /// The [left] parameter represents the x-coordinate of the left edge of the
  /// rectangle. The [top] parameter represents the y-coordinate of the top
  /// edge of the rectangle. The [width] parameter represents the width of the
  /// rectangle. The [height] parameter represents the height of the rectangle.
  ParticleRect.fromLTWH(super.left, super.top, super.width, super.height)
      : super.fromLTWH();

  /// Updates the particle's rectangle by setting the right and bottom edges based on the given width and height.
  ///
  /// The [width] parameter represents the new width of the rectangle.
  /// The [height] parameter represents the new height of the rectangle.
  void update(double width, double height) {
    right = left + width;
    bottom = top + height;
  }

  void fromRect(Rect rect) {
    left = rect.left;
    top = rect.top;
    right = rect.right;
    bottom = rect.bottom;
  }
}
