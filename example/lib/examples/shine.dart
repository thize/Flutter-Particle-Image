// import 'package:flutter/material.dart';
// import 'package:particle_image/particle_image.dart';

// class ShineExample extends StatelessWidget {
//   const ShineExample({super.key, required this.controller});

//   final ParticleController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 0.5,
//       child: ParticleImage(
//         controller: controller,
//         particlesData: [
//           _particle1(),
//           _particle2(),
//         ],
//       ),
//     );
//   }

//   ParticleData _particle1() {
//     return const ParticleData(
//       settings: PD_Settings(
//         shape: PD_ShapeImage("assets/sparkle.png"),
//         color: PDS_Color(
//           start: PD_ColorSingle(Colors.red),
//         ),
//         time: PDS_Time(
//           duration: Duration(milliseconds: 350),
//           lifetime: PD_DurationConstant(Duration(milliseconds: 350)),
//         ),
//         size: PDS_Size(
//           start: PD_Size(
//             height: PD_NumberConstant(100),
//             width: PD_NumberConstant(100),
//           ),
//           overLifetime: PD_SizeCurve(
//             begin: PD_Size(
//               height: PD_NumberConstant(1),
//               width: PD_NumberConstant(1),
//             ),
//             end: PD_Size(
//               height: PD_NumberConstant(0),
//               width: PD_NumberConstant(0),
//             ),
//             curve: Curves.linear,
//           ),
//         ),
//       ),
//       emission: PD_Emission(
//         bursts: [
//           PD_Burst(
//             time: Duration(milliseconds: 0),
//             count: 15,
//           ),
//         ],
//       ),
//     );
//   }

//   ParticleData _particle2() {
//     return const ParticleData(
//       settings: PD_Settings(
//         shape: PD_ShapeImage("assets/decal_scorch.png"),
//         time: PDS_Time(
//           duration: Duration(milliseconds: 400),
//           lifetime: PD_DurationConstant(Duration(milliseconds: 400)),
//         ),
//         color: PDS_Color(
//           start: PD_ColorSingle(Colors.red),
//         ),
//         speed: PDS_Speed(
//           start: PD_NumberConstant(0),
//         ),
//         size: PDS_Size(
//           start: PD_Size(
//             height: PD_NumberConstant(200),
//             width: PD_NumberConstant(200),
//           ),
//           overLifetime: PD_SizeCurve(
//             begin: PD_Size(
//               height: PD_NumberConstant(1),
//               width: PD_NumberConstant(1),
//             ),
//             end: PD_Size(
//               height: PD_NumberConstant(0),
//               width: PD_NumberConstant(0),
//             ),
//             curve: Curves.linear,
//           ),
//         ),
//       ),
//       emission: PD_Emission(
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
