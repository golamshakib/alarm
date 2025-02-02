// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../core/common/widgets/custom_text.dart';
// import '../../../core/utils/constants/app_sizes.dart';
// import '../../../core/utils/constants/icon_path.dart';
// import '../controller/create_new_back_ground_screen_controller.dart';
//
// class RecordTuneSection extends StatelessWidget {
//   const RecordTuneSection({
//     super.key,
//     required this.controller,
//   });
//
//   final CreateAlarmController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomText(
//           text: "Record your tune:",
//           fontSize: getWidth(16),
//           color: const Color(0xff333333),
//           fontWeight: FontWeight.w600,
//         ),
//         Row(
//           children: [
//             Obx(() {
//               // Tooltip with dynamic message
//               return Tooltip(
//                 message: controller.recordingHoverMessage.value.isNotEmpty
//                     ? controller.recordingHoverMessage.value
//                     : "Start recording audio",
//                 child: GestureDetector(
//                   onTap: controller.isMicDisabled.value
//                       ? null // Disable interaction if isMicDisabled is true
//                       : () async {
//                     await controller.openVoiceRecorder();
//                   },
//                   child: Opacity(
//                     opacity: controller.isMicDisabled.value ? 0.5 : 1.0, // Visual indication,
//                     child: Row(
//                       children: [
//                         // Text for start/stop recording
//                         Obx(() => CustomText(
//                           text: controller.isRecording.value ? "Stop Record" : "Start Record",
//                           color: controller.isMicDisabled.value
//                               ? Colors.grey // Change text color when disabled
//                               : const Color(0xffFFA845),
//                           decoration: TextDecoration.underline,
//                           decorationColor: const Color(0xffFFA845),
//                         )),
//                         const SizedBox(width: 8),
//                         // Icon for recording state
//                         Obx(() => SizedBox(
//                           height: getHeight(30),
//                           width: getWidth(30),
//                           child: CircleAvatar(
//                             backgroundImage: AssetImage(
//                               controller.isRecording.value
//                                   ? IconPath.recordingOnIcon
//                                   : IconPath.radioIcon,
//                             ),
//                           ),
//                         )),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ],
//     );
//   }
// }
