part of particle_image;

class Particle {
  final ParticleData data;
  final double startTime;
  final Duration animationDuration;

  // speed
  late double _startSpeed;
  double get startSpeed => _startSpeed;
  late PD_Number _speedOverLifetime;
  PD_Number get speedOverLifetime => _speedOverLifetime;

  // rotation
  late Vector3 _startRotation;
  Vector3 get startRotation => _startRotation;
  late PD_Vector3 _rotationOverLifetime;
  PD_Vector3 get rotationOverLifetime => _rotationOverLifetime;

  // size
  late Size _startSize;
  Size get startSize => _startSize;
  late PD_Size _sizeOverLifetime;
  PD_Size get sizeOverLifetime => _sizeOverLifetime;

  // color
  late Color _startColor;
  Color get startColor => _startColor;
  late PD_Color _colorOverLifetime;
  PD_Color get colorOverLifetime => _colorOverLifetime;

  // position
  Offset _globalPositionDiff = Offset.zero;
  Offset _modifedPosition = Offset.zero;
  Offset _startPosition = Offset.zero;
  Offset _position = Offset.zero;
  Offset get position => _position;

  Offset _nextPosition = Offset.zero;

  // progress
  double _currentProgress = 0;
  int _totalElapsedMillis = 0;

  // movement
  Offset _direction = Offset.zero;
  Offset _velocity = Offset.zero;
  Offset _gravityVelocity = Offset.zero;

  final List<TrailPoint> trailPoints = List<TrailPoint>.empty(growable: true);

  Particle({
    required this.data,
    required this.startTime,
    required Size totalSize,
    required GlobalKey particleImageKey,
    required BuildContext context,
  }) : animationDuration = data.settings.time.lifetime.clone().value(0) {
    _startPositionAndDirection(
      totalSize,
      particleImageKey,
      context,
    );

    // speed
    _startSpeed = data.settings.speed.start.clone().value(0);
    _speedOverLifetime = data.settings.speed.overLifetime.clone();
    _velocity += _direction * _startSpeed;

    // size
    _startSize = data.settings.size.start.clone().value(0);
    _sizeOverLifetime = data.settings.size.overLifetime.clone();

    // color
    _startColor = data.settings.color.start.clone().value(0);
    _colorOverLifetime = data.settings.color.overLifetime.clone();

    // rotation
    _startRotation = data.settings.rotation.start.clone().value(0);
    _rotationOverLifetime = data.settings.rotation.overLifetime.clone();
    trailPoints.add(TrailPoint(_position, 0));
  }

  void _startPositionAndDirection(
    Size totalSize,
    GlobalKey particleImageKey,
    BuildContext context,
  ) {
    var (Offset position, Offset direction) =
        data.emission.shape.apply(totalSize);
    _position = position;
    _modifedPosition = position;
    _startPosition = position;
    _direction = ParticleUtils.normalized(direction);

    // global position
    final (Offset globalPosition, Size globalSize) =
        ParticleUtils.fromKey(particleImageKey, context);
    var _globalPosition = globalPosition + globalSize.center(Offset.zero);
    Offset diffToZero = Offset.zero - position;
    _globalPositionDiff = _globalPosition - position - diffToZero;
  }

  (ui.Image, ui.Rect, ui.RSTransform, ui.Color) computeTransformation(
      ui.Image image) {
    return data.settings.shape.computeTransformation(
        this, image, _currentProgress, _totalElapsedMillis);
  }

  onAnimationUpdate({
    required double progress,
    required int elapsedMillis,
  }) {
    _currentProgress = progress;
    _totalElapsedMillis += elapsedMillis;
    double fixTime = elapsedMillis / 10;
    double speedWithTime = _speedOverLifetime.value(_currentProgress);
    _velocity = _direction * startSpeed * speedWithTime;
    _applyMoveVelocity(fixTime);
    _applyGravity(fixTime);
    _applyVortex(fixTime);
    _applyVelocity(fixTime);
    if (!_applyAttractor(fixTime)) {
      _nextPosition = _modifedPosition;
    }
    _position = _nextPosition;
    _addTrailPoint();
  }

  void _applyVelocity(double fixTime) {
    var velocity = _velocity + _gravityVelocity;
    _modifedPosition = _modifedPosition + velocity * fixTime;
  }

  void _applyMoveVelocity(double fixTime) {
    PD_MovementVelocity? velocity = data.movement.velocity;
    if (velocity == null) return;
    Offset res = velocity.offset.value(_currentProgress) * fixTime;
    _velocity += Offset(
      res.dx,
      -res.dy,
    );
  }

  void _applyVortex(double fixTime) {
    PD_MovementVortex? vortex = data.movement.vortex;
    if (vortex == null) return;

    double strength = vortex.strength.value(_currentProgress);
    _modifedPosition = ParticleUtils.rotatePointArroundCenter(
      _modifedPosition,
      strength * fixTime,
    );
  }

  void _applyGravity(double fixTime) {
    PD_MovementGravity? gravity = data.movement.gravity;
    if (gravity == null) return;
    double gravityAcceleration = gravity.force(_currentProgress);

    _gravityVelocity += Offset(0, gravityAcceleration * fixTime);
  }

  // Offset _trailLastPos = Offset.zero;
  Offset? lastTrailPoint;

  void _addTrailPoint() {
    double sizeX = 1;
    PD_Trail? trail = data.settings.trail;
    bool _hasTrail = trail != null;
    if (!_hasTrail) return;

    // adiciona um ponto
    if (_currentProgress < animationDuration.inMilliseconds) {
      trailPoints[trailPoints.length - 1] =
          TrailPoint(_position, _currentProgress.toDouble());
    }
  }

  bool _applyAttractor(double fixTime) {
    PD_MovementAttractor? attractor = data.movement.attractor;
    if (attractor == null) {
      return false;
    }

    Offset targetLocalPosition = attractor.target() - _globalPositionDiff;

    double progressLerp = attractor.progressLerp(_currentProgress);

    Offset lerp = ParticleUtils.lerpUnclamped(
      _modifedPosition,
      targetLocalPosition,
      progressLerp,
    );
    _nextPosition = lerp;
    return true;
  }

  void drawExtra(Canvas canvas) {
    data.settings.trail?.draw(canvas, _currentProgress, this);
  }
}
