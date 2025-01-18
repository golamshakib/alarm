import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_sizes.dart';
import '../controller/create_new_back_ground_alarm_controller.dart';

class UploadToneSection extends StatelessWidget {
  const UploadToneSection({
    super.key,
    required this.controller,
  });

  final CreateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.selectedAudio.value == null
        ? CustomText(
      text: "Upload your tone:",
      fontSize: getWidth(16),
      fontWeight: FontWeight.w600,
      color: const Color(0xff333333),
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: "Upload your tone:",
          fontSize: getWidth(16),
          fontWeight: FontWeight.w600,
          color: const Color(0xff333333),
        ),
        GestureDetector(
            onTap: () async {
              try {
                FilePickerResult? result =
                await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                );
                if (result != null &&
                    result.files.single.path != null) {
                  controller.pickAudio(
                      File(result.files.single.path!));
                }
              } catch (e) {
                Get.snackbar(
                    "Error", "Failed to pick audio: $e",
                    snackPosition:
                    SnackPosition.BOTTOM);
              }
            },
            child: CustomText(
              text: "Change",
              color: const Color(0xffFFA845),
              fontWeight: FontWeight.w600,
              fontSize: getWidth(16),
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xffFFA845),
            ))
      ],
    ));
  }
}