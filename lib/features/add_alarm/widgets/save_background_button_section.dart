import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_sizes.dart';
import '../controller/create_new_back_ground_screen_controller.dart';

class SaveBackgroundButtonSection extends StatelessWidget {
  const SaveBackgroundButtonSection({
    super.key,
    required this.controller,
    this.id,
  });

  final CreateNewBackgroundController controller;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.musicPath.value != null
         // || controller.recordingPath.value != null
        ? GestureDetector(
      onTap: () async {
        // Call saveData with the provided ID
        controller.saveData(id: id);
      },
      child: Container(
        padding:
        EdgeInsets.symmetric(vertical: getHeight(12)),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CustomText(
            text: 'Save background',
            color: AppColors.textWhite,
          ),
        ),
      ),
    )
        : const Text(""));
  }
}