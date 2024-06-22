// import 'package:flutter/material.dart';
// import 'package:particle_image/particle_image.dart';

// class TriangleExample extends StatelessWidget {
//   const TriangleExample({super.key, required this.controller});

//   final ParticleController controller;

//   @override
//   Widget build(BuildContext context) {
//     return ParticleImage(
//       controller: controller,
//       particlesData: [
//         ParticleData(
//           settings: _settings(),
//           movement: _movement(),
//           emission: _emission(),
//         ),
//       ],
//     );
//   }

//   PD_Emission _emission() {
//     return const PD_Emission(
//       ratePerSecond: 50,
//       shape: PD_EmissionShapeDirectional(angle: 45),
//     );
//   }

//   PD_Settings _settings() {
//     return PD_Settings(
//       time: const PDS_Time(
//         lifetime: PD_DurationConstant(Duration(seconds: 1)),
//         duration: Duration(seconds: 5),
//       ),
//       shape: const PD_ShapeSquare(),
//       speed: const PDS_Speed(
//         start: PD_NumberConstant(2),
//       ),
//       color: PDS_Color(
//         start: PD_ColorRandom(
//           const [
//             Color(0xffFFAF00),
//             Color(0xffFF1B00),
//             Color(0xff00FF0A),
//             Color(0xff0048FF),
//           ],
//         ),
//       ),
//       size: const PDS_Size(
//         start: PD_Size(
//           width: PD_NumberConstant(20),
//           height: PD_NumberConstant(20),
//         ),
//       ),
//     );
//   }

//   PD_Movement _movement() {
//     return const PD_Movement(
//       gravity: PD_MovementGravity(
//         force: PD_NumberConstant(-2),
//       ),
//     );
//   }
// }
