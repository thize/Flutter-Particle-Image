import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class UniformEmitterExample extends StatelessWidget {
  const UniformEmitterExample({super.key, required this.controller});

  final ParticleController controller;

  @override
  Widget build(BuildContext context) {
    return ParticleImage(
      controller: controller,
      particle: ParticleData(
        settings: _settings(),
        movement: _movement(),
        emission: _emission(),
      ),
    );
  }

  PD_Emission _emission() {
    return const PD_Emission(
      ratePerSecond: 200,
      shape: PD_EmissionShapePoint(uniformLoop: 23),
    );
  }

  PD_Settings _settings() {
    return const PD_Settings(
      time: PDS_Time(
        lifetime: PD_DurationConstant(Duration(seconds: 2)),
        duration: Duration(seconds: 1),
      ),
      shape: PD_ShapeImage("assets/Star.png"),
      size: PDS_Size(
        start: PD_Size(
          width: PD_NumberConstant(40),
          height: PD_NumberConstant(40),
        ),
      ),
    );
  }

  PD_Movement _movement() {
    return const PD_Movement(
      vortex: PD_MovementVortex(
        strength: PD_NumberCurve(
          begin: 0,
          end: 1,
          curve: Curves.linear,
        ),
      ),
    );
  }
}
