part of particle_image;

class PD_Settings {
  final PD_Shape shape;
  final PDS_Time time;
  final PD_Number speed;
  final PD_Size size;
  final PD_Vector3 rotation;
  final PD_Color color;
  final PD_Trail? trail;

  final bool alignToDirection;

  PD_Settings({
    PD_Shape? shape,
    this.time = const PDS_Time(),
    this.speed = const PD_NumberConstant(2),
    this.size = const PD_Size(
      height: PD_NumberConstant(40),
      width: PD_NumberConstant(40),
    ),
    this.rotation = const PD_Vector3(),
    this.color = const PD_ColorSingle(),
    this.trail,
    this.alignToDirection = false,
  }) : shape = shape ?? PD_ShapeCircle();

  PD_Settings clone() {
    return PD_Settings(
      shape: shape.clone(),
      trail: trail,
      time: time,
      speed: speed,
      size: size,
      rotation: rotation,
      color: color,
      alignToDirection: alignToDirection,
    );
  }
}

class PDS_Size {
  final PD_Size start;
  final PD_Size? overLifetime;

  const PDS_Size({
    this.start = const PD_Size(
      height: PD_NumberConstant(40),
      width: PD_NumberConstant(40),
    ),
    this.overLifetime,
  });
}

class PDS_Time {
  final bool loop;
  final Duration startDelay;
  final Duration duration;
  final PD_Duration lifetime;

  bool isDurationOver(int elapsedInMilliseconds) {
    return Duration(milliseconds: elapsedInMilliseconds) >=
        (duration + startDelay);
  }

  const PDS_Time({
    this.loop = true,
    this.startDelay = Duration.zero,
    this.duration = const Duration(seconds: 5),
    this.lifetime = const PD_DurationConstant(Duration(seconds: 1)),
  });
}
