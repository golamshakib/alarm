import 'dart:io';

import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_alarm/controller/add_alarm_controller.dart';

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

    // Determine the image source, check if the background image is a local file or asset
    String backgroundImage = alarm.backgroundImage;
    ImageProvider imageProvider;
    if (File(backgroundImage).existsSync()) {
      imageProvider = FileImage(File(backgroundImage));
    } else {
      imageProvider = AssetImage(
          backgroundImage); // Fallback to asset image if file doesn't exist
    }

    String formatRepeatDays(List<String> repeatDays) {
      if (repeatDays.length == 7) {
        return "Everyday"; // If all days are selected
      } else if (repeatDays.isNotEmpty) {
        return repeatDays.join(
            ', '); // Join the days with a comma if not all days are selected
      }
      return "No Repeat Days";
    }

    // Format time based on the format setting
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
          Image(
              image: imageProvider,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover),
          Positioned(
            bottom: getHeight(92),
            left: getWidth(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center column's children vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center column's children horizontally
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the row's children horizontally
                  children: [
                    CustomText(
                      text: formatTime(alarm.hour, alarm.minute, alarm.isAm, controller.timeFormat.value),
                      color: Colors.white,
                      fontSize: getWidth(40),
                      fontWeight: FontWeight.w300,
                    ),
                    SizedBox(
                      width: getWidth(16),
                    ),
                    Container(
                      height: getHeight(50),
                      width: getWidth(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: getWidth(16),
                    ),
                    CustomText(
                      text: formatRepeatDays(alarm.repeatDays),
                      fontSize: getWidth(14),
                      maxLines: 2,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ],
                ),
                CustomText(
                  text: alarm.label,
                  fontSize: getWidth(48),
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                SizedBox(
                  height: getHeight(24),
                ),
                GestureDetector(
                  onTap: () {
                    controller.stopAlarmVibration(); // Stop vibration on snooze
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: getWidth(38),
                            top: getHeight(15),
                            right: getWidth(38),
                            bottom: getHeight(15)),
                        child: const CustomText(
                          text: "Snooze",
                          color: AppColors.yellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
