import 'dart:io';

import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/common/widgets/text_with_arrow.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../routes/app_routes.dart';
import '../../../settings/controller/settings_controller.dart';
import '../../controller/add_alarm_controller.dart';

class AddAlarmScreen extends StatelessWidget {
  const AddAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddAlarmController controller = Get.put(AddAlarmController());
    final settingsController = Get.find<SettingsController>(); // Don't Remove this (Settings fetching the data)
    final arguments = Get.arguments;

    if (arguments != null) {
      controller.selectedBackground.value = arguments['title'] ?? '';
      controller.selectedBackgroundImage.value = arguments['imagePath'] ?? '';
      controller.selectedMusicPath.value = arguments['musicPath'] ?? '';
      controller.selectedRecordingPath.value = arguments['recordingPath'] ?? '';
    }

    final isEditMode = arguments?['isEditMode'] ?? false;
    final alarm = arguments?['alarm']; // Get alarm if in edit mode

    if (isEditMode && alarm != null) {
      // Prepopulate fields with the existing alarm's data
      controller.selectedHour.value = alarm.hour;
      controller.selectedMinute.value = alarm.minute;
      controller.isAm.value = alarm.isAm;
      controller.label.value = alarm.label;
      controller.repeatDays.updateAll((key, value) => false); // Reset and update repeat days
      for (var day in alarm.repeatDays) {
        controller.repeatDays[day] = true;
      }
      controller.selectedBackground.value = alarm.backgroundTitle;
      controller.selectedBackgroundImage.value = alarm.backgroundImage;
      controller.selectedMusicPath.value = alarm.musicPath;
      controller.selectedRecordingPath.value = alarm.recordingPath;
      controller.selectedSnoozeDuration.value = alarm.snoozeDuration;
      controller.isVibrationEnabled.value = alarm.isVibrationEnabled;
      controller.volume.value = alarm.volume;
    }


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                CustomAppbarWithLogo(
                  text: isEditMode ? 'Edit Alarm' : 'Add Alarm',
                  iconPath: IconPath.check,
                  onIconTap: () {
                    if (isEditMode) {
                      controller.updateAlarmInDatabase(alarm); // Update the existing alarm
                      Get.back();
                    } else {
                      controller.saveAlarmToDatabase(); // Save a new alarm
                    }
                    controller.saveScreenPreferences();
                  },
                ),
                SizedBox(height: getHeight(16)),

                // Time Picker
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellowContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: getHeight(60),
                    child: Row(
                      mainAxisAlignment: controller.timeFormat.value == 24 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hour Dropdown (Reactive to time format)
                        Flexible(
                          child: Obx(() {
                            final is24Hour = controller.timeFormat.value == 24;
                            return DropdownButton<int>(
                              value: controller.selectedHour.value,
                              items: List.generate(
                                is24Hour ? 24 : 12,
                                    (index) {
                                  return DropdownMenuItem(
                                    value: is24Hour ? index : index + 1,
                                    child: Text(
                                      is24Hour ? index.toString() : (index + 1).toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectedHour.value = value;
                                }
                              },
                              dropdownColor: AppColors.lightYellowContainer,
                              menuMaxHeight: getHeight(250),
                            );
                          }),
                        ),

                        // Minute Dropdown
                        Flexible(
                          child: Obx(() => DropdownButton<int>(
                            value: controller.selectedMinute.value,
                            items: List.generate(60, (index) {
                              return DropdownMenuItem(
                                value: index,
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedMinute.value = value;
                              }
                            },
                            dropdownColor: AppColors.lightYellowContainer,
                            menuMaxHeight: getHeight(250),
                          )),
                        ),

                        // AM/PM Dropdown (Reactive to 12-hour format)
                        Flexible(
                          child: Obx(() {
                            final is24Hour = controller.timeFormat.value == 24;
                            if (!is24Hour) {
                              return DropdownButton<bool>(
                                value: controller.isAm.value,
                                items: [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text(
                                      "AM",
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text(
                                      "PM",
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.isAm.value = value;
                                  }
                                },
                                dropdownColor: AppColors.lightYellowContainer,
                                menuMaxHeight: getHeight(150),
                              );
                            }

                            // Return an empty widget for 24-hour format
                            return const SizedBox.shrink();
                          }),
                        ),
                      ],
                    ),
                  ),
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
                          const CustomText(text: 'Background:'),
                          InkWell(
                            onTap: isEditMode ? null : () {
                              Get.toNamed(AppRoute.changeBackgroundScreen);
                            },
                            child: Obx(() {
                              return TextWithArrow(
                                text: controller.selectedBackground.value,
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: getHeight(16)),
                      Obx(() {
                        final imagePath = controller.selectedBackgroundImage.value;

                        if (imagePath.isNotEmpty) {
                          ImageProvider imageProvider;

                          if (imagePath.startsWith("http") || imagePath.startsWith("https")) {
                            // If it's a URL, use NetworkImage
                            imageProvider = NetworkImage(imagePath);
                          } else if (File(imagePath).existsSync()) {
                            // If it's a local file, use FileImage
                            imageProvider = FileImage(File(imagePath));
                          } else {
                            // If neither, use a fallback asset
                            imageProvider = const AssetImage(ImagePath.cat);
                          }

                          return Container(
                            height: getHeight(150),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink(); // Return an empty widget if no imagePath
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
                              _showLabelPopup(context, controller);
                            },
                            child: Obx(() => TextWithArrow(
                              text: controller.label.value.isNotEmpty
                                  ? controller.label.value
                                  : "Morning Alarm",
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
                            onTap: () => _showSnoozePopup(context, controller),
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
                              duration:
                              const Duration(milliseconds: 300),
                              width: getWidth(37),
                              height: getHeight(21),
                              decoration: BoxDecoration(
                                color: controller.isVibrationEnabled.value
                                    ? const Color(0xffFFAB4C)
                                    : const Color(0xffA3B2C7)
                                    .withOpacity(0.3),
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
                                onChanged: (value) async {
                                  await controller.setDeviceVolume(value);
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

void _showLabelPopup(BuildContext context, AddAlarmController controller) {
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

void _showSnoozePopup(BuildContext context, AddAlarmController controller) {
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
