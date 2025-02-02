
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_sizes.dart';
import '../controller/create_new_back_ground_screen_controller.dart';

class UploadToneSection extends StatelessWidget {
  const UploadToneSection({
    super.key,
    required this.controller,
  });

  final CreateNewBackgroundController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.musicPath.value == null
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
        Obx(() => Tooltip(
          message: controller.musicHoverMessage.value.isNotEmpty
              ? controller.musicHoverMessage.value
              : "Pick an audio file",
            child: GestureDetector(
                onTap: controller.isMusicDisabled.value
                    ? null // Disable interaction if isMusicDisabled is true
                    : () async {
                  controller.pickMusic();
                },
                child: CustomText(
                  text: "Change",
                  color: controller.isMusicDisabled.value
                      ? Colors.grey // Change text color when disabled
                      : const Color(0xffFFA845),
                  fontWeight: FontWeight.w600,
                  fontSize: getWidth(16),
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xffFFA845),
                )),
          ),
        )
      ],
    ));
  }
}