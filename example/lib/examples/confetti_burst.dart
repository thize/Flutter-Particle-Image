// import 'package:flutter/material.dart';
// import 'package:particle_image/particle_image.dart';

// class ConfettiBurstExample extends StatelessWidget {
//   const ConfettiBurstExample({super.key, required this.controller});

//   final ParticleController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 0.5,
//       child: ParticleImage(
//         controller: controller,
//         particlesData: [
//           ParticleData(
//             settings: _settings(),
//             movement: _movement(),
//             emission: _emission(),
//           ),
//         ],
//       ),
//     );
//   }

//   PD_Emission _emission() {
//     return const PD_Emission(
//       bursts: [
//         PD_Burst(
//           time: Duration.zero,
//           count: 100,
//         ),
//       ],
//       shape: PD_EmissionShapePoint(),
//     );
//   }

//   PD_Settings _settings() {
//     return PD_Settings(
//       time: const PDS_Time(
//         lifetime: PD_DurationConstant(Duration(seconds: 1)),
//         duration: Duration(seconds: 1),
//       ),
//       shape: PD_ShapeImage(
//         "assets/Confetti.png",
//         tile: PD_TileFPS(
//           columns: 5,
//           rows: 5,
//           startFrame: PD_NumberRandomBetweenTwoConstants(0, 25),
//           fps: 1,
//         ),
//       ),
//       speed: PDS_Speed(
//         start: PD_NumberRandomBetweenTwoConstants(2, 10),
//         overLifetime: PD_NumberCurve(
//           begin: 1,
//           end: 0,
//           curve: CurvePoints(const [
//             CurvePoint(force: 8, y: 0),
//             CurvePoint(force: 2, y: 1),
//             CurvePoint(force: 1, y: 1),
//           ]),
//         ),
//       ),
//       rotation: PDS_Rotation(
//         start: PD_Vector3RandomBetweenTwoConstants(
//           Vector3(0, 0, 0),
//           Vector3(0, 0, 360),
//         ),
//         overLifetime: const PD_Vector3Curve(
//           begin: PD_Vector3(
//             x: PD_NumberConstant(0),
//             y: PD_NumberConstant(0),
//             z: PD_NumberConstant(0),
//           ),
//           end: PD_Vector3(
//             x: PD_NumberConstant(0),
//             y: PD_NumberConstant(0),
//             z: PD_NumberConstant(1200),
//           ),
//           curve: Curves.linear,
//         ),
//       ),
//       size: PDS_Size(
//         start: const PD_Size(
//           width: PD_NumberConstant(65),
//           height: PD_NumberConstant(65),
//         ),
//         overLifetime: PD_SizeCurve(
//           begin: const PD_Size(
//             width: PD_NumberConstant(1),
//             height: PD_NumberConstant(1),
//           ),
//           end: const PD_Size(
//             width: PD_NumberConstant(0),
//             height: PD_NumberConstant(0),
//           ),
//           curve: CurvePoints(const [
//             CurvePoint(force: 1, y: 1),
//             CurvePoint(force: 5, y: 0),
//             CurvePoint(force: 1, y: 1),
//           ]),
//         ),
//       ),
//     );
//   }

//   PD_Movement _movement() {
//     return const PD_Movement(
//       gravity: PD_MovementGravity(
//         force: PD_NumberConstant(-4),
//       ),
//     );
//   }
// }
