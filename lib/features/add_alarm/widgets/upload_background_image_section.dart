
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_sizes.dart';
import '../controller/create_new_back_ground_screen_controller.dart';

class UploadBackgroundImageSection extends StatelessWidget {
  const UploadBackgroundImageSection({
    super.key,
    required this.controller,
    required this.picker,
  });

  final CreateNewBackgroundController controller;
  final ImagePicker picker;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.imagePath.value == null
        ? CustomText(
      text: "Upload Background Image:",
      fontSize: getWidth(16),
      fontWeight: FontWeight.w600,
      color: const Color(0xff333333),
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: "Upload Background Image:",
          fontSize: getWidth(16),
          fontWeight: FontWeight.w600,
          color: const Color(0xff333333),
        ),
        GestureDetector(
            onTap: ()  {
              controller.pickImage();
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