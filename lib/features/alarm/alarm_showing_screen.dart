import 'dart:io';

import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_alarm/controller/add_alarm_controller.dart';
import '../add_alarm/data/alarm_model.dart';

class AlarmShowingScreen extends StatelessWidget {
  const AlarmShowingScreen({super.key, required this.alarm});

  final Alarm alarm;

  @override
  Widget build(BuildContext context) {
    final AddAlarmController controller = Get.find<AddAlarmController>();

    // Trigger vibration when the alarm screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.triggerAlarmVibration(alarm);
    });

    // Determine the image source
    String backgroundImage = alarm.backgroundImage;
    ImageProvider imageProvider;
    if (File(backgroundImage).existsSync()) {
      imageProvider = FileImage(File(backgroundImage));
    } else {
      imageProvider = AssetImage(backgroundImage);
    }

    String formatRepeatDays(List<String> repeatDays) {
      if (repeatDays.length == 7) {
        return "Everyday";
      } else if (repeatDays.isNotEmpty) {
        return repeatDays.join(', ');
      }
      return "No Repeat Days";
    }

    String formatTime(int hour, int minute, bool isAm, int timeFormat) {
      if (timeFormat == 24) {
        return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
      } else {
        return "${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image(
            image: imageProvider,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Bottom Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: getWidth(16),
                right: getWidth(16),
                bottom: getHeight(90),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time and Repeat Days
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: formatTime(
                            alarm.hour, alarm.minute, alarm.isAm, controller.timeFormat.value),
                        color: Colors.white,
                        fontSize: getWidth(40),
                        fontWeight: FontWeight.w300,
                      ),
                      SizedBox(width: getWidth(16)),
                      Container(
                        height: getHeight(50),
                        width: getWidth(2),
                        color: Colors.white,
                      ),
                      SizedBox(width: getWidth(16)),
                      Flexible(
                        child: CustomText(
                          text: formatRepeatDays(alarm.repeatDays),
                          fontSize: getWidth(14),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Alarm Label
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                    child: CustomText(
                      text: alarm.label,
                      fontSize: getWidth(36),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: getHeight(24)),
                  // Snooze Button
                  GestureDetector(
                    onTap: () {
                      controller.stopAlarmVibration();
                      Get.back();
                    },
                    child: Container(
                      height: getHeight(60),
                      width: getWidth(120),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: "Snooze",
                          color: AppColors.yellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
