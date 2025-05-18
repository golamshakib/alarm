import 'dart:io';

import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/common/widgets/text_with_arrow.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:alarm/features/add_alarm/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../nav_bar/controllers/nav_bar_controller.dart';
import '../../../nav_bar/presentation/screens/nav_bar.dart';
import '../../../settings/controller/settings_controller.dart';
import '../../controller/add_alarm_controller.dart';
import '../../data/alarm_model.dart';
import '../helper_method/label_popup.dart';
import '../helper_method/snooze_popup.dart';

class AddAlarmScreen extends StatelessWidget {
  const AddAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddAlarmController controller = Get.put(AddAlarmController());
    final settingsController = Get.find<
        SettingsController>(); // Don't Remove this (Settings fetching the data)
    final navController = Get.put(CreatorNavBarController(), permanent: true);
    final arguments = Get.arguments;

    if (arguments != null) {
      controller.selectedBackground.value = arguments['title'] ?? '';
      controller.selectedBackgroundImage.value = arguments['imagePath'] ?? '';
      controller.selectedMusicPath.value = arguments['musicPath'] ?? '';
      // controller.selectedRecordingPath.value = arguments['recordingPath'] ?? '';
    }

    final isEditMode = arguments?['isEditMode'] ?? false;
    final alarm = arguments?['alarm'];

    if (isEditMode && alarm != null) {
      // Prepopulate fields with the existing alarm's data
      controller.selectedHour.value = alarm.hour;
      controller.selectedMinute.value = alarm.minute;
      controller.isAm.value = alarm.isAm;
      controller.label.value = alarm.label;
      // Check if repeatDays is empty or contains "Today" and adjust it
      if (alarm.repeatDays.isEmpty || alarm.repeatDays.contains("Today")) {
        controller.repeatDays.updateAll((key, value) => false); // Reset all days to false
      } else {
        // Prepopulate repeat days from the alarm's repeatDays
        for (var day in alarm.repeatDays) {
          controller.repeatDays[day] = true;
        }
      }
      controller.selectedBackground.value = alarm.backgroundTitle;
      controller.selectedBackgroundImage.value = alarm.backgroundImage;
      controller.selectedMusicPath.value = alarm.musicPath;
      // controller.selectedRecordingPath.value = alarm.recordingPath;
      controller.selectedSnoozeDuration.value = alarm.snoozeDuration;
      controller.isVibrationEnabled.value = alarm.isVibrationEnabled;
      controller.volume.value = alarm.volume;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(16), vertical: getHeight(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar

                CustomAppbarWithLogo(
                  text: isEditMode ? 'Edit Alarm' : 'Add Alarm',
                  iconPath: IconPath.check,
                  onIconTap: () async {
                    if (isEditMode) {
                      controller.updateAlarmInDatabase(alarm);
                      Get.back();
                    } else {
                      await controller.saveAlarmToDatabase();

                      Alarm newAlarm = controller.alarms.last;

                      DateTime alarmTime =
                          controller.getNextAlarmTime(newAlarm);
                      int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;
                      await controller.setAlarmNative(
                        alarmTimeInMillis,
                        newAlarm.id!,
                        newAlarm.repeatDays,
                      );
                      controller.saveScreenPreferences();

                       // Navigate back and switch to Alarm Screen
                      navController.changeIndex(0); // Set the bottom nav to Alarm screen
                      Get.offAll(() => const CreatorNavBar()); // Ensure smooth navigation

                    }
                  },
                ),
                SizedBox(height: getHeight(16)),

                // Time Picker
                Container(
                  margin: EdgeInsets.symmetric(vertical: getHeight(16)),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellowContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: TimePickerUI(controller: controller),
                ),

                // Background Section
                Container(
                  padding: EdgeInsets.all(getWidth(16)),
                  decoration: BoxDecoration(
                    color: AppColors.greyContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Background:',
                            color: isEditMode
                                ? AppColors.textGrey
                                : AppColors.textPrimary,
                          ),
                          InkWell(
                            onTap: isEditMode
                                ? null
                                : () {
                                    Get.toNamed(
                                        AppRoute.changeBackgroundScreen);
                                  },
                            child: Obx(() {
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: AppSizes.width * 0.5),
                                child: TextWithArrow(
                                  text: controller.selectedBackground.value,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: getHeight(16)),
                      Obx(() {
                        final imagePath =
                            controller.selectedBackgroundImage.value;

                        if (imagePath.isNotEmpty) {
                          ImageProvider imageProvider;

                          if (imagePath.startsWith("http") ||
                              imagePath.startsWith("https")) {
                            // If it's a URL, use NetworkImage
                            imageProvider = NetworkImage(imagePath);
                          } else if (File(imagePath).existsSync()) {
                            // If it's a local file, use FileImage
                            imageProvider = FileImage(File(imagePath));
                          } else {
                            // If neither, use a fallback asset
                            imageProvider = const AssetImage(ImagePath.cat);
                          }

                          return Stack(
                            children: [
                              Container(
                                height: getHeight(150),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isEditMode) // Add grey overlay if in edit mode
                                Container(
                                  height: getHeight(150),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.withValues(alpha: 0.7), // Semi-transparent grey overlay
                                  ),
                                ),
                            ],

                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      SizedBox(height: getHeight(24)),

                      // Repeat Section
                      const CustomText(text: 'Repeat:'),
                      SizedBox(height: getHeight(8)),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: controller.repeatDays.keys.map((day) {
                            final isSelected = controller.repeatDays[day]!;
                            return GestureDetector(
                              onTap: () {
                                controller.toggleDay(day);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.yellow
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CustomText(
                                  text: day,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.yellow,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),

                      SizedBox(height: getHeight(30)),

                      // Label Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(text: 'Label:'),
                          GestureDetector(
                            onTap: () {
                              showLabelPopup(context, controller);
                            },
                            child: Obx(() => ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: AppSizes.width * 0.5,
                                  ),
                                  child: TextWithArrow(
                                    text: controller.label.value.isNotEmpty
                                        ? controller.label.value
                                        : "Morning Alarm",
                                  ),
                                )),
                          ),
                        ],
                      ),

                      SizedBox(height: getHeight(24)),

                      // Snooze Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(text: 'Snooze:'),
                          GestureDetector(
                            onTap: () => showSnoozePopup(context, controller),
                            child: Obx(() => TextWithArrow(
                                  text:
                                      '${controller.selectedSnoozeDuration.value} Minute',
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: getHeight(24)),

                      // Vibration Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(text: 'Vibration:'),
                          Obx(() => GestureDetector(
                                onTap: controller.toggleVibration,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: getWidth(37),
                                  height: getHeight(21),
                                  decoration: BoxDecoration(
                                    color: controller.isVibrationEnabled.value
                                        ? const Color(0xffFFAB4C)
                                        : const Color(0xffA3B2C7)
                                            .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                    alignment:
                                        controller.isVibrationEnabled.value
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Container(
                                      width: getWidth(18),
                                      height: getHeight(18),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),

                      SizedBox(height: getHeight(6)),
                      // Volume Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(text: 'Volume:'),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Obx(() {
                              return Slider(
                                value: controller.volume.value,
                                min: 0.0,
                                max: 1.0,
                                onChanged: (value) {
                                  controller.setAppVolume(value); // Only updates local volume
                                },
                                activeColor: Colors.orange,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
