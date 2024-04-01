import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class ConfettiFullScreenExample extends StatelessWidget {
  const ConfettiFullScreenExample({super.key, required this.controller});

  final ParticleController controller;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.5,
      child: ParticleImage(
        controller: controller,
        particle: const ParticleData(emission: PD_Emission()),
        subParticles: [
          _corners(const Offset(-400, 800), 45),
          _corners(const Offset(400, 800), -45),
        ],
      ),
    );
  }

  ParticleData _corners(Offset offset, double degrees) {
    return ParticleData(
      transform: (c, child) {
        return Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: ParticleUtils.toRadians(degrees),
            child: child,
          ),
        );
      },
      settings: PD_Settings(
        time: PDS_Time(
          loop: false,
          lifetime: PD_DurationRandom(
            const Duration(seconds: 1),
            const Duration(seconds: 3),
          ),
          duration: const Duration(milliseconds: 1000),
        ),
        shape: const PD_ShapeSquare(),
        color: PDS_Color(
          start: PD_ColorRandom(const [
            Color(0xffFF002B),
            Color(0xffFF7200),
            Color(0xffFFEB00),
            Color(0xff6CFF00),
            Color(0xff00FFF0),
            Color(0xff00C6FF),
            Color(0xff0079FF),
          ]),
        ),
        speed: PDS_Speed(
          start: PD_NumberRandomBetweenTwoConstants(3, 15),
          overLifetime: const PD_NumberCurve(
            begin: 1,
            end: 0.5,
            curve: Curves.easeOutCirc,
          ),
        ),
        rotation: PDS_Rotation(
          start: PD_NumberRandomBetweenTwoConstants(-360, 360),
          overLifetime: const PD_NumberCurve(
            begin: 0,
            end: 2000,
            curve: Curves.linear,
          ),
        ),
        size: PDS_Size(
          start: const PD_Size(
            width: PD_NumberConstant(30),
            height: PD_NumberConstant(10),
          ),
          overLifetime: PD_NumberCurve(
            begin: 1,
            end: 0,
            curve: CurvePoints(const [
              CurvePoint(force: 1, y: 1),
              CurvePoint(force: 5, y: 0),
              CurvePoint(force: 1, y: 1),
            ]),
          ),
        ),
      ),
      movement: const PD_Movement(
        gravity: PD_MovementGravity(
          force: PD_NumberCurve(
            begin: -20,
            end: -120,
            curve: Curves.easeInOutSine,
          ),
        ),
      ),
      emission: const PD_Emission(
        bursts: [
          PD_Burst(
            time: Duration.zero,
            count: 100,
          ),
        ],
        shape: PD_EmissionShapeDirectional(),
      ),
    );
  }
}
