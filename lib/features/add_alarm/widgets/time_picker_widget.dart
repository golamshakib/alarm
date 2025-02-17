import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/constants/app_sizes.dart';

class TimePickerUI extends StatelessWidget {
  final dynamic controller;

  const TimePickerUI({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final is24Hour = controller.timeFormat.value == 24;

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hour Picker (Adjusts for 12-hour or 24-hour format)
            Expanded(
              child: SizedBox(
                height: getHeight(120),
                child: Obx(
                      () => ListWheelScrollView.useDelegate(
                    controller: FixedExtentScrollController(
                      initialItem: is24Hour
                          ? controller.selectedHour.value
                          : (controller.selectedHour.value % 12) - 1,
                    ),
                    itemExtent: 30,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      if (is24Hour) {
                        controller.selectedHour.value = index;
                      } else {
                        controller.selectedHour.value = (index + 1) % 12 == 0
                            ? 12
                            : index + 1;
                      }
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final hour = is24Hour ? index : (index + 1);
                        final isSelected = hour == controller.selectedHour.value;

                        return Center(
                          child: Transform.scale(
                            scale: isSelected ? 1.2 : 0.9,
                            child: Text(
                              hour.toString().padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(22),
                                fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: is24Hour ? 24 : 12,
                    ),
                  ),
                ),
              ),
            ),

            // Minute Picker (Remains the same)
            Expanded(
              child: SizedBox(
                height: getHeight(120),
                child: Obx(
                      () => ListWheelScrollView.useDelegate(
                    controller: FixedExtentScrollController(
                        initialItem: controller.selectedMinute.value),
                    itemExtent: 30,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) =>
                    controller.selectedMinute.value = index,
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final isSelected = index == controller.selectedMinute.value;

                        return Center(
                          child: Transform.scale(
                            scale: isSelected ? 1.2 : 0.9,
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(22),
                                fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: 60,
                    ),
                  ),
                ),
              ),
            ),

            // AM/PM Picker (Only visible in 12-hour format)
            if (!is24Hour)
              Expanded(
                child: SizedBox(
                  height: getHeight(120),
                  child: Obx(
                        () => ListWheelScrollView.useDelegate(
                      controller: FixedExtentScrollController(
                          initialItem: controller.isAm.value ? 0 : 1),
                      itemExtent: 30,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) =>
                      controller.isAm.value = index == 0,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final isSelected = (index == 0 && controller.isAm.value) ||
                              (index == 1 && !controller.isAm.value);
                          final text = index == 0 ? 'AM' : 'PM';

                          return Center(
                            child: Transform.scale(
                              scale: isSelected ? 1.2 : 0.9,
                              child: Text(
                                text,
                                style: GoogleFonts.poppins(
                                  fontSize: getWidth(22),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
