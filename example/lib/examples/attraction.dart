import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class AttractionExample extends StatefulWidget {
  const AttractionExample({
    super.key,
    this.moving = true,
    required this.controller,
  });

  final bool moving;
  final ParticleController controller;

  @override
  State<AttractionExample> createState() => _AttractionExampleState();
}

class _AttractionExampleState extends State<AttractionExample> {
  GlobalKey targetKey = GlobalKey();

  bool goingRight = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _particle(),
        _target(),
      ],
    );
  }

  ParticleImage _particle() {
    return ParticleImage(
      controller: widget.controller,
      particlesData: [
        ParticleData(
          settings: _settings(),
          movement: _movement(),
          emission: _emission(),
        ),
      ],
    );
  }

  TweenAnimationBuilder<double> _target() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: -1, end: goingRight ? 1 : -1),
      duration: const Duration(milliseconds: 1000),
      onEnd: () {
        goingRight = !goingRight;
        setState(() {});
      },
      builder: (context, value, child) {
        return Transform.translate(
          offset: _getMoving(value),
          child: Container(
            key: targetKey,
            width: 40,
            height: 40,
            color: Colors.white.withOpacity(0.5),
          ),
        );
      },
    );
  }

  Offset _getMoving(double value) {
    if (widget.moving) {
      return _offset(0, -150) + const Offset(300, 0) * value;
    }
    return _offset(150, -100);
  }

  PD_Emission _emission() {
    return const PD_Emission(
      ratePerSecond: 50,
      shape: PD_EmissionShapeDirectional(angle: 0),
    );
  }

  PD_Settings _settings() {
    return PD_Settings(
      shape: PD_ShapeSquare(),
      speed: const PD_NumberConstant(10),
      time: const PDS_Time(duration: Duration(seconds: 1)),
      color: PD_ColorRandom(
        const [
          Color(0xffFFAF00),
          Color(0xffFF1B00),
          Color(0xff00FF0A),
          Color(0xff0048FF),
        ],
      ),
    );
  }

  PD_Movement _movement() {
    return PD_Movement(
      gravity: const PD_MovementGravity(force: PD_NumberConstant(-20)),
      attractor: PD_MovementAttractor(
        targetKey: targetKey,
        context: context,
        lerp: const PD_NumberCurve(
          begin: PD_NumberConstant(0),
          end: PD_NumberConstant(1),
          curve: Curves.linear,
        ),
      ),
    );
  }

  Offset _offset(double dx, double dy) {
    return Offset(
      MediaQuery.of(context).size.width / 2 - 20 + dx,
      MediaQuery.of(context).size.height / 2 - 20 + dy,
    );
  }
}
