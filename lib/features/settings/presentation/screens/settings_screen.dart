import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/common/widgets/text_with_arrow.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CustomAppbarWithLogo(text: 'Settings'),
            SizedBox(height: getHeight(24)),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(text: 'Time format'),
                  GestureDetector(
                    onTap: () => _timeFormatPopup(context, controller),
                    child: Obx(() => TextWithArrow(
                      text:
                      '${controller.selectedTime.value} Hour',
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(16)),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(text: 'Reset Alarms'),
                  GestureDetector(
                    onTap: () => _resetAlarmPopup(context, controller),
                    child: const TextWithArrow(
                    text: '',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

void _timeFormatPopup(BuildContext context, SettingsController controller) {
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
            // Title
            const CustomText(text: 'Time Format:'),
            SizedBox(height: getHeight(10)),

            Obx(() {
              return Column(
                children: controller.timeFormat.map((option) {
                  final isSelected =
                      controller.selectedTime.value == option;

                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomText(
                            text: '$option Hour',
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
                        groupValue: controller.selectedTime.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateTime(value);
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

void _resetAlarmPopup(BuildContext context, SettingsController controller) {
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
            // Title
            const CustomText(text: 'Reset All Alarms?'),
            SizedBox(height: getHeight(16)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back(); // Close the popup immediately on "Cancel"
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
                    onTap: () async {
                      // Close the dialog immediately after pressing "Yes"
                      Get.back();

                      // Reset all alarms
                      await controller.resetAllAlarms();

                      Get.snackbar(
                        "Success",
                        "All alarms have been reset.", duration: const Duration(seconds: 2)
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: getHeight(10)),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: 'Yes',
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
