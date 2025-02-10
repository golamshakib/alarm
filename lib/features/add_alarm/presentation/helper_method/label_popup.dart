import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../controller/add_alarm_controller.dart';

void showLabelPopup(BuildContext context, AddAlarmController controller) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const CustomText(text: 'Label:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: getWidth(10)),
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller.labelController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        actions: [
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
                    controller
                        .updateLabel(controller.labelController.text.trim());
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
        ],
      );
    },
  );
}
