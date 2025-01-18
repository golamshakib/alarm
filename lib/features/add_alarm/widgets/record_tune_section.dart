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
                onTap: () {
                  if (!controller.isRecordingNow.value) {
                    controller.startRecording();
                  } else {
                    controller.stopRecording();
                  }
                },
                child: Row(
                  children: [
                    const CustomText(
                      text: "Record",
                      color: Color(0xffFFA845),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffFFA845),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (controller.isRecordingNow.value) {
                          controller.stopRecording();
                        } else {
                          controller.startRecording();
                        }
                      },
                      child: controller
                          .isRecordingNow.value !=
                          true
                          ? Radio<bool>(
                        value: false,
                        activeColor:
                        const Color(0xffF34100),
                        groupValue: controller
                            .isRecordingNow.value,
                        onChanged: (value) {
                          if (value == false) {
                            controller.stopRecording();
                          }
                        },
                      )
                          : SizedBox(
                        height: getHeight(30),
                        width: getWidth(30),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                              IconPath.recordingOnIcon),
                        ),
                      ),
                    ),
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