// import 'package:flutter/material.dart';
// import 'package:particle_image/particle_image.dart';

// class ShineExample extends StatelessWidget {
//   const ShineExample({super.key, required this.controller});

//   final ParticleController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 0,
//         height: 0,
//         child: ParticleImage(
//           controller: controller,
//           particlesData: [
//             _particle1(),
//             // _particle2(),
//           ],
//         ),
//       ),
//     );
//   }

//   ParticleData _particle1() {
//     return ParticleData(
//       settings: PD_Settings(
//         shape: PD_ShapeImage("assets/sparkle.png"),
//         time: const PDS_Time(
//           duration: Duration(milliseconds: 1000),
//           lifetime: PD_DurationConstant(Duration(milliseconds: 500)),
//         ),
//         size: const PD_SizeCurve(
//           begin: PD_Size(
//             height: PD_NumberConstant(34),
//             width: PD_NumberConstant(34),
//           ),
//           end: PD_Size(
//             height: PD_NumberConstant(0),
//             width: PD_NumberConstant(0),
//           ),
//           curve: Curves.linear,
//         ),
//       ),
//       emission: const PD_Emission(
//         ratePerSecond: 400,
//       ),
//     );
//   }

//   ParticleData _particle2() {
//     return ParticleData(
//       settings: PD_Settings(
//         shape: PD_ShapeImage("assets/decal_scorch.png"),
//         time: const PDS_Time(
//           duration: Duration(milliseconds: 1500),
//           lifetime: PD_DurationConstant(Duration(milliseconds: 1500)),
//         ),
//         // color: PD_ColorSingle(Colors.red),
//         speed: const PD_NumberConstant(0),
//         size: const PD_SizeCurve(
//           begin: PD_Size(
//             height: PD_NumberConstant(200),
//             width: PD_NumberConstant(200),
//           ),
//           end: PD_Size(
//             height: PD_NumberConstant(0),
//             width: PD_NumberConstant(0),
//           ),
//           curve: Curves.linear,
//         ),
//       ),
//       emission: const PD_Emission(
//         shape: PD_EmissionShapePoint(),
//         bursts: [
//           PD_Burst(
//             time: Duration(milliseconds: 0),
//             count: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
