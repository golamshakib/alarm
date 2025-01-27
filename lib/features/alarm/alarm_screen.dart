import 'dart:io';

import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:alarm/features/add_alarm/controller/add_alarm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/common/widgets/custom_text.dart';
import '../add_alarm/presentation/screens/add_alarm_screen.dart';
import 'alarm_showing_screen.dart';
import 'package:alarm/features/settings/controller/settings_controller.dart';  // Import the SettingsController

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the SettingsController
    final SettingsController settingsController = Get.put(SettingsController());
    final controller = Get.put(AddAlarmController());

    String formatRepeatDays(List<String> repeatDays) {
      if (repeatDays.length == 7) {
        return "Everyday";  // If all days are selected
      } else if (repeatDays.isNotEmpty) {
        return repeatDays.join(', ');  // Join the days with a comma if not all days are selected
      }
      return "No Repeat Days";
    }


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(getWidth(16)),
          child: Obx(() {
            if (controller.alarms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagePath.alarmImage,
                      height: getHeight(346),
                      width: getWidth(375),
                    ),
                    SizedBox(height: getHeight(10)),
                    CustomText(
                      text: 'No Alarms Set Yet!',
                      fontWeight: FontWeight.w700,
                      fontSize: getWidth(32),
                      color: AppColors.textGrey,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar row for selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Obx(() {
                              return controller.isSelectionMode.value
                                  ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: controller.exitSelectionMode,
                              )
                                  : const SizedBox.shrink();
                            }),
                            SizedBox(width: getWidth(12)),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: controller.isSelectionMode.value
                                          ? '${controller.selectedAlarms.length} Item Selected'
                                          : 'My Alarms',
                                      fontSize: getWidth(24),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (controller.isSelectionMode.value) {
                          return GestureDetector(
                            onTap: () => _showLabelPopup(context, controller),
                            child: Image.asset(
                              IconPath.deleteIcon,
                              width: getWidth(18),
                              height: getHeight(20),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                  SizedBox(height: getHeight(24)),

                  // List of alarms
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.alarms.length,
                    separatorBuilder: (context, _) =>
                        SizedBox(height: getHeight(16)),
                    itemBuilder: (context, index) {
                      final alarm = controller.alarms[index];
                      final isSelected =
                      controller.selectedAlarms.contains(index);

                      return GestureDetector(
                        onLongPress: () {
                          controller.enableSelectionMode(index);
                        },
                        onDoubleTap: () {
                          Get.to(() => AlarmShowingScreen(
                            alarm: alarm,
                          ));
                        },
                        onTap: () {
                          if (controller.isSelectionMode.value) {
                            controller.toggleSelection(index);
                          } else {
                            Get.to(() => const AddAlarmScreen(),
                              arguments: {
                                'isEditMode': true, // Set flag to indicate editing
                                'alarm': alarm, // Pass the alarm data to the edit screen
                              },
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: File(alarm.backgroundImage).existsSync()
                                  ? FileImage(File(alarm.backgroundImage))
                                  : const AssetImage(ImagePath.dog) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xffFFF5E1),
                                  const Color(0xffFFF5E1).withOpacity(0.0),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.togglePlayPause(index); // Play/pause logic
                                          },
                                          child: Obx(() {
                                            // Dynamically show play/pause icon
                                            final isPlaying = controller.isPlaying.value &&
                                                controller.currentlyPlayingIndex.value == index;
                                            return Icon(
                                              isPlaying
                                                  ? Icons.play_circle_fill_rounded
                                                  : Icons.play_circle_outline_rounded,
                                              color: Colors.orange,
                                              size: 25,
                                            );
                                          }),
                                        ),
                                        SizedBox(width: getWidth(12)),
                                        GestureDetector(
                                          onTap: () {
                                            controller.toggleAlarm(index);
                                          },
                                          child: Obx(
                                                () => AnimatedContainer(
                                              duration:
                                              const Duration(
                                                  milliseconds: 300),
                                              width: getWidth(37),
                                              height: getHeight(21),
                                              decoration: BoxDecoration(
                                                color: alarm.isToggled.value
                                                    ? const Color(0xffFFAB4C)
                                                    : const Color(0xffA3B2C7)
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                BorderRadius.circular(30),
                                              ),
                                              child: AnimatedAlign(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                alignment: alarm.isToggled.value
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Container(
                                                  width: getWidth(18),
                                                  height: getHeight(18),
                                                  decoration:
                                                  const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (controller.isSelectionMode.value)
                                      Checkbox(
                                        value: isSelected,
                                        activeColor: const Color(0xffFFAB4C),
                                        side: const BorderSide(
                                          width: 1,
                                          color: Color(0xffFFAB4C),
                                        ),
                                        onChanged: (value) {
                                          controller.toggleSelection(index);
                                        },
                                      ),
                                  ],
                                ),
                                Text(
                                  "${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')} ${alarm.isAm ? 'AM' : 'PM'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: getWidth(36),
                                  ),
                                ),
                                SizedBox(height: getHeight(15)),
                                Row(
                                  children: [
                                    CustomText(
                                      text: formatRepeatDays(alarm.repeatDays),                                      fontSize: getWidth(14),
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xffA59F92),
                                    ),
                                    Image.asset(
                                      ImagePath.lineImage2,
                                      height: getHeight(20),
                                      width: getWidth(20),
                                    ),
                                    SizedBox(width: getWidth(8)),
                                    CustomText(
                                      text: alarm.label,
                                      fontSize: getWidth(14),
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xffA59F92),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
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
        title: const CustomText(text: 'Delete this alarm?'),
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
                    controller.deleteSelectedAlarms();
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
