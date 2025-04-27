import 'dart:io';

import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:alarm/features/add_alarm/controller/add_alarm_controller.dart';
import 'package:alarm/features/alarm/controller/alarm_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../add_alarm/data/alarm_model.dart';
import '../../../add_alarm/presentation/screens/add_alarm_screen.dart';
import 'package:alarm/features/settings/controller/settings_controller.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with WidgetsBindingObserver {
  late final SettingsController settingsController;
  late final AddAlarmController addAlarmController;
  late final AlarmScreenController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Listen for app lifecycle changes

    settingsController = Get.put(SettingsController());
    addAlarmController = Get.put(AddAlarmController());
    controller = Get.put(AlarmScreenController());
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Stop listening for lifecycle changes
    addAlarmController
        .stopMusic(); // Ensure music stops when screen is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      addAlarmController
          .stopMusic(); // Stop music when app goes into background or tab switches
    }
  }

// Format time based on the format setting
  String formatTime(int hour, int minute, bool isAm, int timeFormat) {
    if (timeFormat == 24) {
      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    } else {
      return "${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getHeight(16), horizontal: getWidth(16)),
          child: Obx(() {
            // Create a copy of the alarms list to sort
            final alarms = List<Alarm>.from(addAlarmController.alarms);

            // Sort alarms chronologically by time
            controller.sortAlarmsChronologically(alarms);

            if (alarms.isEmpty) {
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
                                    SizedBox(height: getHeight(16)),
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
                    itemCount: alarms.length,
                    separatorBuilder: (context, _) =>
                        SizedBox(height: getHeight(16)),
                    itemBuilder: (context, index) {
                      final alarm = alarms[index];
                      final isSelected =
                      controller.selectedAlarms.contains(index);

                      return GestureDetector(
                        onLongPress: () {
                          controller.enableSelectionMode(index);
                        },
                        onTap: () {
                          addAlarmController
                              .stopMusic(); // Stop music when navigating away
                          if (controller.isSelectionMode.value) {
                            controller.toggleSelection(index);
                          } else {
                            Get.to(() => const AddAlarmScreen(), arguments: {
                              'isEditMode': true,
                              // Set flag to indicate editing
                              'alarm': alarm,
                              // Pass the alarm data to the edit screen
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: alarm.backgroundImage.startsWith("http") ||
                                  alarm.backgroundImage.startsWith("https")
                                  ? NetworkImage(alarm.backgroundImage) // Use network image if it's a URL
                                  : File(alarm.backgroundImage).existsSync()
                                  ? FileImage(File(alarm.backgroundImage)) // Use FileImage for local files
                                  : const AssetImage(ImagePath.cat)
                              as ImageProvider,
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
                                        // 🎵 Play Button (Supports Network & Local Music)
                                        GestureDetector(
                                          onTap: () {
                                            addAlarmController.togglePlayPause(
                                                index, alarm.musicPath);
                                          },
                                          child: Obx(() {
                                            final isPlaying =
                                                addAlarmController.isPlaying.value &&
                                                    addAlarmController
                                                        .currentlyPlayingIndex
                                                        .value ==
                                                        index;
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
                                              duration: const Duration(
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
                                                  decoration: const BoxDecoration(
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
                                CustomText(
                                  text: formatTime(
                                      alarm.hour,
                                      alarm.minute,
                                      alarm.isAm,
                                      addAlarmController.timeFormat.value),
                                  fontWeight: FontWeight.w300,
                                  fontSize: getWidth(36),
                                ),
                                SizedBox(height: getHeight(15)),
                                Row(
                                  children: [
                                    CustomText(
                                      text: addAlarmController.formatRepeatDays(alarm.repeatDays),
                                      fontSize: getWidth(14),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffA59F92),
                                    ),
                                    Image.asset(
                                      ImagePath.lineImage2,
                                      height: getHeight(20),
                                      width: getWidth(20),
                                    ),
                                    SizedBox(width: getWidth(8)),
                                    Flexible(
                                      child: CustomText(
                                        text: alarm.label,
                                        textOverflow: TextOverflow.ellipsis,
                                        fontSize: getWidth(14),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xffA59F92),
                                      ),
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
          })

        ),
      ),
    );
  }
}

void _showLabelPopup(BuildContext context, AlarmScreenController controller) {
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
