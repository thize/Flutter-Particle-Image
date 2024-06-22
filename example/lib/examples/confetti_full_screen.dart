// import 'package:flutter/material.dart';
// import 'package:particle_image/particle_image.dart';

// class ConfettiFullScreenExample extends StatelessWidget {
//   const ConfettiFullScreenExample({super.key, required this.controller});

//   final ParticleController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 0.5,
//       child: ParticleImage(
//         controller: controller,
//         particlesData: [
//           const ParticleData(emission: PD_Emission()),
//           _corners(const Offset(-400, 800), 45),
//           _corners(const Offset(400, 800), -45),
//         ],
//       ),
//     );
//   }

//   ParticleData _corners(Offset offset, double degrees) {
//     return ParticleData(
//       settings: PD_Settings(
//         time: const PDS_Time(
//           loop: !false,
//           lifetime: PD_DurationConstant(Duration(milliseconds: 1000)),
//           duration: Duration(milliseconds: 1000),
//         ),
//         shape: const PD_ShapeSquare(),
//         color: PDS_Color(
//           start: PD_ColorRandom(const [
//             Color(0xffFF002B),
//             Color(0xffFF7200),
//             Color(0xffFFEB00),
//             Color(0xff6CFF00),
//             Color(0xff00FFF0),
//             Color(0xff00C6FF),
//             Color(0xff0079FF),
//           ]),
//         ),
//         speed: PDS_Speed(
//           start: PD_NumberRandomBetweenTwoConstants(3, 15),
//           overLifetime: const PD_NumberCurve(
//             begin: 1,
//             end: 0.5,
//             curve: Curves.easeOutCirc,
//           ),
//         ),
//         rotation: const PDS_Rotation(
//           start: PD_Vector3(
//             x: PD_NumberConstant(0),
//             y: PD_NumberConstant(125),
//             z: PD_NumberConstant(20),
//           ),
//           // overLifetime: PD_Vector3Curve(
//           //   begin: PD_Vector3(
//           //     x: PD_NumberConstant(0),
//           //     y: PD_NumberConstant(0),
//           //     z: PD_NumberConstant(0),
//           //   ),
//           //   end: PD_Vector3(
//           //     x: PD_NumberConstant(2000),
//           //     y: PD_NumberConstant(2000),
//           //     z: PD_NumberConstant(2000),
//           //   ),
//           //   curve: Curves.linear,
//           // ),
//         ),
//         // size: PDS_Size(
//         //   start: const PD_Size(
//         //     width: PD_NumberConstant(30),
//         //     height: PD_NumberConstant(30),
//         //   ),
//         //   overLifetime: PD_SizeCurve(
//         //     begin: const PD_Size(
//         //       width: PD_NumberConstant(1),
//         //       height: PD_NumberConstant(1),
//         //     ),
//         //     end: const PD_Size(
//         //       width: PD_NumberConstant(0),
//         //       height: PD_NumberConstant(0),
//         //     ),
//         //     curve: CurvePoints(const [
//         //       CurvePoint(force: 1, y: 1),
//         //       CurvePoint(force: 5, y: 0),
//         //       CurvePoint(force: 1, y: 1),
//         //     ]),
//         //   ),
//         // ),
//       ),
//       // movement: const PD_Movement(
//       //   gravity: PD_MovementGravity(
//       //     force: PD_NumberCurve(
//       //       begin: -20,
//       //       end: -120,
//       //       curve: Curves.easeInOutSine,
//       //     ),
//       //   ),
//       // ),
//       emission: const PD_Emission(
//         bursts: [
//           PD_Burst(
//             time: Duration.zero,
//             count: 100,
//           ),
//         ],
//         shape: PD_EmissionShapeDirectional(),
//       ),
//     );
//   }
// }
