import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_sizes.dart';
import '../../../core/utils/constants/icon_path.dart';
import '../controller/create_new_back_ground_alarm_controller.dart';

class RecordTuneSection extends StatelessWidget {
  const RecordTuneSection({
    super.key,
    required this.controller,
  });

  final CreateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: "Record your tune:",
          fontSize: getWidth(16),
          color: const Color(0xff333333),
          fontWeight: FontWeight.w600,
        ),
        Obx(() {
          return Row(
            children: [
              GestureDetector(
                onTap: () async  {
                  controller.toggleRecording();
                },
                child: Row(
                  children: [
                    CustomText(
                      text: controller.isRecording.value
                          ? "Stop Record"
                          : "Start Record", // Change text based on isRecordingNow value
                      color: const Color(0xffFFA845),
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xffFFA845),
                    ),
                    const SizedBox(width: 8),
                    controller.isRecording.value
                        ? SizedBox(
                      height: getHeight(30),
                      width: getWidth(30),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(IconPath.recordingOnIcon),
                      ),
                    )
                        : SizedBox(
                      height: getHeight(25),
                      width: getWidth(25),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(IconPath.radioIcon),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}