import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class CoinAttractionExample extends StatefulWidget {
  const CoinAttractionExample({super.key, required this.controller});

  final ParticleController controller;

  @override
  State<CoinAttractionExample> createState() => _CoinAttractionExampleState();
}

class _CoinAttractionExampleState extends State<CoinAttractionExample> {
  GlobalKey targetKey = GlobalKey();
  int coins = 100;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CoinsParticle(
          coins: 15,
          targetKey: targetKey,
          addCoins: (int coins) {
            setState(() {
              this.coins += coins;
            });
          },
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
            Positioned(
              right: 12,
              child: Text("$coins"),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinsParticle extends StatefulWidget {
  const CoinsParticle({
    super.key,
    required this.coins,
    required this.targetKey,
    required this.addCoins,
  });

  final int coins;
  final GlobalKey targetKey;
  final Function(int coins) addCoins;

  @override
  State<CoinsParticle> createState() => _CoinsParticleState();
}

class _CoinsParticleState extends State<CoinsParticle> {
  static const int maxParticles = 30;
  int _coinsPerParticle = 0;
  int _extraCoins = 0;
  int _particlesBurst = 0;

  @override
  void initState() {
    super.initState();
    _coinsPerParticle =
        widget.coins >= maxParticles ? widget.coins ~/ maxParticles : 1;
    _extraCoins =
        widget.coins >= maxParticles ? widget.coins % maxParticles : 0;
    _particlesBurst =
        widget.coins >= maxParticles ? maxParticles : widget.coins;
  }

  @override
  Widget build(BuildContext context) {
    return ParticleImage(particlesData: [
      ParticleData(
        settings: _settings(),
        movement: _movement(),
        emission: _emission(),
        events: PD_Events(
          onLastParticleFinished: () {
            widget.addCoins(_extraCoins);
          },
          onEachParticleFinished: () {
            widget.addCoins(_coinsPerParticle);
          },
        ),
      ),
    ]);
  }

  PD_Emission _emission() {
    return PD_Emission(
      shape: const PD_EmissionShapeCircle(),
      bursts: [
        PD_Burst(
          time: Duration.zero,
          count: _particlesBurst,
        ),
      ],
    );
  }

  PD_Settings _settings() {
    var duration = PD_DurationRandom(
      const Duration(milliseconds: 950),
      const Duration(milliseconds: 1200),
    );
    return PD_Settings(
      time: PDS_Time(
        loop: false,
        lifetime: duration,
        duration: duration.value(0),
      ),
      speed: PD_NumberCurve(
        begin: const PD_NumberConstant(0),
        end: PD_NumberRandomBetweenTwoConstants(1, 6),
        curve: CurvePoints(const [
          CurvePoint(force: 20, y: 1),
          CurvePoint(force: 100, y: 0),
        ]),
      ),
      shape: PD_ShapeImage(
        "assets/Coin_Rotation.png",
        tile: const PD_TileFPS(
          columns: 4,
          rows: 4,
          fps: 25,
        ),
      ),
      size: const PD_Size(
        width: PD_NumberConstant(34),
        height: PD_NumberConstant(34),
      ),
      // trail: PD_Trail(
      //   ratio: 0.74,
      //   vertexDistance: 10,
      //   width: const PD_NumberCurve(
      //     begin: 1,
      //     end: 0,
      //     curve: Curves.linear,
      //   ),
      //   inheritParticleColor: true,
      //   colorOverLifetime: PD_ColorSingle(
      //     const Color(0xffFFD204).withOpacity(0.57),
      //   ),
      //   colorOverTrail: PD_ColorProgress(
      //     [Colors.white, Colors.white.withOpacity(0)],
      //     [0, 1],
      //   ),
      //   dieWithParticle: true,
      //   lifetime: 0.2,
      // ),
    );
  }

  PD_Movement _movement() {
    return PD_Movement(
      vortex: PD_MovementVortex(
        strength: PD_NumberCurve(
          begin: const PD_NumberConstant(0),
          end: const PD_NumberConstant(1),
          curve: CurvePoints(const [
            CurvePoint(force: 15, y: 0),
            CurvePoint(force: 5, y: 0),
            CurvePoint(force: 1, y: 2),
            CurvePoint(force: 5, y: 1),
          ]),
        ),
      ),
      attractor: PD_MovementAttractor(
        targetKey: widget.targetKey,
        context: context,
        lerp: PD_NumberCurve(
          begin: const PD_NumberConstant(0),
          end: const PD_NumberConstant(1),
          curve: CurvePoints(const [
            CurvePoint(force: 8, y: 0),
            CurvePoint(y: 1),
          ]),
        ),
      ),
    );
  }
}
