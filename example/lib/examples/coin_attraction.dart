// import 'package:flutter/material.dart';
// import 'package:particle_image/particle_image.dart';

// class CoinAttractionExample extends StatefulWidget {
//   const CoinAttractionExample({super.key, required this.controller});

//   final ParticleController controller;

//   @override
//   State<CoinAttractionExample> createState() => _CoinAttractionExampleState();
// }

// class _CoinAttractionExampleState extends State<CoinAttractionExample> {
//   GlobalKey targetKey = GlobalKey();
//   int coins = 100;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _particle(),
//         _target(),
//       ],
//     );
//   }

//   ParticleImage _particle() {
//     return ParticleImage(
//       controller: widget.controller,
//       particlesData: [
//         ParticleData(
//           settings: _settings(),
//           movement: _movement(),
//           emission: _emission(),
//           events: PD_Events(
//             onEachParticleFinished: () {
//               setState(() {
//                 coins++;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _target() {
//     return Transform.translate(
//       offset: const Offset(300, 0),
//       child: Container(
//         width: 60,
//         height: 40,
//         color: Colors.black.withOpacity(0.5),
//         child: Stack(
//           alignment: Alignment.center,
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//               left: -20,
//               child: Image.asset(
//                 'assets/Coin.png',
//                 key: targetKey,
//                 width: 40,
//               ),
//             ),
//             Positioned(
//               right: 12,
//               child: Text("$coins"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   PD_Emission _emission() {
//     return const PD_Emission(
//       shape: PD_EmissionShapeCircle(),
//       bursts: [
//         PD_Burst(
//           time: Duration.zero,
//           count: 25,
//         ),
//       ],
//     );
//   }

//   PD_Settings _settings() {
//     return PD_Settings(
//       time: PDS_Time(
//         loop: false,
//         lifetime: PD_DurationRandom(
//           const Duration(milliseconds: 1500),
//           const Duration(milliseconds: 2000),
//         ),
//         duration: const Duration(milliseconds: 300),
//       ),
//       speed: PDS_Speed(
//         start: PD_NumberRandomBetweenTwoConstants(1, 6),
//         overLifetime: PD_NumberCurve(
//           begin: 0,
//           end: 1,
//           curve: CurvePoints(const [
//             CurvePoint(force: 20, y: 1),
//             CurvePoint(force: 100, y: 0),
//           ]),
//         ),
//       ),
//       shape: const PD_ShapeImage(
//         "assets/Coin_Rotation.png",
//         tile: PD_TileFPS(
//           columns: 4,
//           rows: 4,
//           fps: 25,
//         ),
//       ),
//       size: const PDS_Size(
//         start: PD_Size(
//           width: PD_NumberConstant(40),
//           height: PD_NumberConstant(40),
//         ),
//       ),
//       trail: PD_Trail(
//         ratio: 0.74,
//         vertexDistance: 10,
//         width: const PD_NumberCurve(
//           begin: 1,
//           end: 0,
//           curve: Curves.linear,
//         ),
//         inheritParticleColor: true,
//         colorOverLifetime: PD_ColorSingle(
//           const Color(0xffFFD204).withOpacity(0.57),
//         ),
//         colorOverTrail: PD_ColorProgress(
//           colors: [Colors.white, Colors.white.withOpacity(0)],
//         ),
//         dieWithParticle: true,
//         lifetime: 0.2,
//       ),
//     );
//   }

//   PD_Movement _movement() {
//     return PD_Movement(
//       vortex: PD_MovementVortex(
//         strength: PD_NumberCurve(
//           begin: 0,
//           end: 1,
//           curve: CurvePoints(const [
//             CurvePoint(force: 15, y: 0),
//             CurvePoint(force: 5, y: 0),
//             CurvePoint(force: 1, y: 2),
//             CurvePoint(force: 5, y: 1),
//           ]),
//         ),
//       ),
//       attractor: PD_MovementAttractor(
//         targetKey: targetKey,
//         context: context,
//         lerp: PD_NumberCurve(
//           begin: 0,
//           end: 1,
//           curve: CurvePoints(const [
//             CurvePoint(force: 14, y: 0),
//             CurvePoint(y: 1),
//           ]),
//         ),
//       ),
//     );
//   }
// }
