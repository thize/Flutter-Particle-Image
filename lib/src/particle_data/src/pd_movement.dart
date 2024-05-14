part of particle_image;

class PD_Movement {
  final PD_MovementAttractor? attractor;
  final PD_MovementVelocity? velocity;
  final PD_MovementGravity? gravity;
  final PD_MovementVortex? vortex;

  const PD_Movement({
    this.attractor,
    this.velocity,
    this.gravity,
    this.vortex,
  });
}

class PD_MovementAttractor {
  late PD_NumberCurve _lerp;
  GlobalKey? _targetKey;
  Offset? _targetOffset;
  final BuildContext context;

  Curve get curve => _lerp.curve;

  PD_MovementAttractor({
    GlobalKey? targetKey,
    Offset? targetOffset,
    required this.context,
    required PD_NumberCurve lerp,
  }) {
    assert(targetKey != null || targetOffset != null);
    _targetOffset = targetOffset;
    _targetKey = targetKey;
    _lerp = lerp;
  }

  Offset target() {
    if (_targetKey == null) return _notNullTargetOffset;
    final (Offset _offset, Size _size) =
        ParticleUtils.fromKey(_targetKey!, context);
    if (_offset.dx == -1 && _offset.dy == -1) {
      return _notNullTargetOffset;
    }
    _targetOffset = Offset(
      _offset.dx + _size.width / 2,
      _offset.dy + _size.height / 2,
    );
    return _targetOffset!;
  }

  Offset get _notNullTargetOffset => _targetOffset ?? Offset.zero;

  double progressLerp(double progress) {
    return _lerp.value(progress);
  }

  double reverseProgressLerp(double progress) {
    return 1 - _lerp.value(progress);
  }
}

class PD_MovementNoise {
  final double strength;
  final double frequency;
  final Offset offset;

  const PD_MovementNoise({
    this.strength = 1,
    this.frequency = 1,
    this.offset = Offset.zero,
  });
}

class PD_MovementVelocity {
  final PD_OffsetNumber offset;

  const PD_MovementVelocity({
    this.offset = const PD_OffsetNumber(
      x: PD_NumberConstant(0),
      y: PD_NumberConstant(0),
    ),
  });
}

class PD_MovementGravity {
  final PD_Number _force;

  const PD_MovementGravity({
    PD_Number force = const PD_NumberConstant(0),
  }) : _force = force;

  double force(double progress) {
    return _force.value(progress) * -0.00981;
  }
}

class PD_MovementVortex {
  final PD_Number strength;

  const PD_MovementVortex({
    this.strength = const PD_NumberConstant(0),
  });
}
