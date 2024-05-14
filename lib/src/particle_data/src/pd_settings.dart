part of particle_image;

class PD_Settings {
  final PD_Shape shape;
  final PD_Trail? trail;
  final PDS_Time time;
  final PDS_Speed speed;
  final PDS_Size size;
  final PDS_Rotation rotation;
  final PDS_Color color;

  // final bool alignToDirection;

  const PD_Settings({
    this.shape = const PD_ShapeSquare(),
    this.trail,
    this.time = const PDS_Time(),
    this.speed = const PDS_Speed(),
    this.size = const PDS_Size(),
    this.rotation = const PDS_Rotation(),
    this.color = const PDS_Color(),
  });

  PD_Settings clone() {
    return PD_Settings(
      shape: shape.clone(),
      trail: trail,
      time: time,
      speed: speed,
      size: size,
      rotation: rotation,
      color: color,
    );
  }
}

class PDS_Size {
  final PD_Size start;
  final PD_Size overLifetime;

  const PDS_Size({
    this.start = const PD_Size(
      height: PD_NumberConstant(40),
      width: PD_NumberConstant(40),
    ),
    this.overLifetime = const PD_Size(
      height: PD_NumberConstant(1),
      width: PD_NumberConstant(1),
    ),
  });
}

class PDS_Color {
  final PD_Color start;
  final PD_Color overLifetime;

  const PDS_Color({
    this.start = const PD_ColorSingle(),
    this.overLifetime = const PD_ColorSingle(),
  });
}

class PDS_Rotation {
  final PD_Vector3 start;
  final PD_Vector3 overLifetime;

  const PDS_Rotation({
    this.start = const PD_Vector3(),
    this.overLifetime = const PD_Vector3(),
  });
}

class PDS_Speed {
  final PD_Number start;
  final PD_Number overLifetime;

  const PDS_Speed({
    this.start = const PD_NumberConstant(2),
    this.overLifetime = const PD_NumberConstant(1),
  });
}

class PDS_Time {
  final bool loop;
  final Duration startDelay;
  final Duration duration;
  final PD_Duration lifetime;

  const PDS_Time({
    this.loop = true,
    this.startDelay = Duration.zero,
    this.duration = const Duration(seconds: 5),
    this.lifetime = const PD_DurationConstant(Duration(seconds: 1)),
  });
}
