import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../controller/add_alarm_controller.dart';

void showSnoozePopup(BuildContext context, AddAlarmController controller) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(text: 'Snooze:'),
            SizedBox(height: getHeight(10)),

            Obx(() {
              return Column(
                children: controller.snoozeOptions.map((option) {
                  final isSelected =
                      controller.selectedSnoozeDuration.value == option;

                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomText(
                            text: '$option Minute',
                            fontSize: getWidth(14),
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? AppColors.textYellow
                                : AppColors.textGrey,
                          ),
                        ),
                      ),
                      Radio<int>(
                        value: option,
                        groupValue: controller.selectedSnoozeDuration.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateSnoozeDuration(value);
                          }
                        },
                        activeColor: AppColors.yellow,
                      ),
                    ],
                  );
                }).toList(),
              );
            }),

            // Bottom Buttons
            SizedBox(height: getHeight(16)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: getHeight(10)),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: 'Cancel',
                          color: AppColors.textYellow,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: getWidth(10)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: getHeight(10)),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: 'Done',
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(6)),
          ],
        ),
      );
    },
  );
}
