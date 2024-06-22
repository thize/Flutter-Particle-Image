import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class TestExample extends StatefulWidget {
  const TestExample({super.key, required this.controller});

  final ParticleController controller;

  @override
  State<TestExample> createState() => _TestExampleState();
}

class _TestExampleState extends State<TestExample> {
  GlobalKey targetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ParticleImage(
          controller: widget.controller,
          particlesData: [
            _particle1("assets/Coin.png"),
          ],
        ),
        _target(),
      ],
    );
  }

  Widget _target() {
    return Transform.translate(
      offset: const Offset(300, 0),
      child: Container(
        width: 60,
        height: 40,
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              child: Image.asset(
                'assets/Coin.png',
                key: targetKey,
                width: 40,
              ),
            ),
            const Positioned(
              right: 12,
              child: Text("100"),
            ),
          ],
        ),
      ),
    );
  }

  ParticleData _particle1(String path) {
    return ParticleData(
      movement: PD_Movement(
        attractor: PD_MovementAttractor(
          context: context,
          targetKey: targetKey,
          lerp: const PD_NumberCurve(
            curve: Curves.linear,
            begin: PD_NumberConstant(0),
            end: PD_NumberConstant(1),
          ),
        ),
        gravity: const PD_MovementGravity(
          force: PD_NumberConstant(-6),
        ),
        velocity: const PD_MovementVelocity(
          offset: PD_OffsetNumber(
            x: PD_NumberConstant(10),
            y: PD_NumberConstant(0),
          ),
        ),
        vortex: const PD_MovementVortex(
          strength: PD_NumberConstant(150),
        ),
      ),
      settings: PD_Settings(
        shape: PD_ShapeImage(path),
        color: const PD_ColorSingle(Colors.white),
        time: const PDS_Time(
          loop: false,
          duration: Duration(milliseconds: 2000),
          lifetime: PD_DurationConstant(Duration(milliseconds: 2000)),
        ),
        speed: const PD_NumberConstant(0),
        size: const PD_Size(
          height: PD_NumberConstant(34),
          width: PD_NumberConstant(34),
        ),
      ),
      emission: const PD_Emission(
        // shape: PD_EmissionShapeRectangle(
        //   size: Size(300, 300),
        //   emitOnSurface: !false,
        // ),
        // shape: PD_EmissionShapeCircle(
        //   radius: 100,
        //   emitOnSurface: false,
        // ),
        shape: PD_EmissionShapePoint(),
        // shape: PD_EmissionShapeDirectional(angle: 50),
        // rateOverDuration: 150,
        // ratePerSecond: 15,
        bursts: [
          PD_Burst(
            time: Duration(milliseconds: 0),
            count: 1,
          ),
        ],
      ),
    );
  }
}
