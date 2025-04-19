import 'dart:io';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/db_helpers/db_helper_alarm.dart';
import '../../../../core/services/notification_helper.dart';
import '../../../add_alarm/controller/add_alarm_controller.dart';
import '../../../add_alarm/data/alarm_model.dart';

class AlarmTriggerScreen extends StatefulWidget {
  final Alarm alarm;

  const AlarmTriggerScreen({super.key, required this.alarm});

  @override
  _AlarmTriggerScreenState createState() => _AlarmTriggerScreenState();
}

class _AlarmTriggerScreenState extends State<AlarmTriggerScreen> {
  final AddAlarmController controller = Get.find<AddAlarmController>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Alarm? alarmData;

  @override
  void initState() {
    super.initState();
    _fetchAlarmData();
    _playAlarmSound();
    _triggerVibration();
  }

  /// Fetch the alarm data from the database
  Future<void> _fetchAlarmData() async {
    int alarmId = widget.alarm.id!;
    final dbHelper = DBHelperAlarm();
    alarmData = await dbHelper.getAlarm(alarmId);
    if (alarmData != null) {

      await FlutterVolumeController.updateShowSystemUI(false);
      await controller.setDeviceVolume(alarmData!.volume);
    }
  }
  /// **Play Alarm Sound (Supports Network & Local Files)**
  Future<void> _playAlarmSound() async {
    String musicPath = widget.alarm.musicPath;
    if (musicPath.isNotEmpty) {
      try {
        if (musicPath.startsWith("http") || musicPath.startsWith("https")) {
          await _audioPlayer.setUrl(musicPath); // Play from URL
        } else if (File(musicPath).existsSync()) {
          await _audioPlayer.setFilePath(musicPath); // Play from local file
        } else {
          await _audioPlayer.setAsset('assets/audio/iphone_alarm.mp3');
        }

        await _audioPlayer
            .setLoopMode(LoopMode.one); // Keep playing until dismissed
        await _audioPlayer.play();
        // Show the persistent notification if the alarm is repeating
        if (widget.alarm.repeatDays.isNotEmpty) {
          String alarmTimeFormatted = "${widget.alarm.hour}:${widget.alarm.minute < 10 ? '0' : ''}${widget.alarm.minute}";
          await NotificationHelper.showPersistentNotification(
              widget.alarm.id!, alarmTimeFormatted, widget.alarm.label, widget.alarm.repeatDays
          );
        }
      } catch (e) {
        debugPrint("Error playing alarm sound: $e");
      }
    }
  }

  /// **Trigger Continuous Vibration Until Dismissed**
  Future<void> _triggerVibration() async {
    if (widget.alarm.isVibrationEnabled) {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [500, 1000], repeat: 0); // Loop vibration
      }
    }
  }

  /// **Dismiss Alarm**
  void _dismissAlarm() async {
    _stopAlarmProcesses();

    // Get the next valid alarm time (next repeat day)
    DateTime nextRepeatTime = controller.getNextAlarmTime(widget.alarm);
    int nextRepeatTimeInMillis = nextRepeatTime.millisecondsSinceEpoch;

    // Reschedule the alarm using the native method
    await controller.setAlarmNative(
      nextRepeatTimeInMillis,
      widget.alarm.id!,
      widget.alarm.repeatDays,
    );
    debugPrint("Alarm ID ${widget.alarm.id} dismissed.");

    // Do not close the notification if the alarm is repeating, just keep it visible
    if (widget.alarm.repeatDays.isEmpty) {
      await NotificationHelper.closeNotification(widget.alarm.id!, widget.alarm.repeatDays);
    }

    _closeApp(); // Close the app so no screen is shown
  }


  /// **Snooze Alarm and Re-Schedule Notification**
  void _snoozeAlarm() async {
    _stopAlarmProcesses();

    // Retrieve snooze duration from the database (in minutes)
    int snoozeTimeInMillis = widget.alarm.snoozeDuration * 60 * 1000; // Convert to milliseconds

    // Get the next snooze time
    DateTime snoozeTriggerTime = DateTime.now().add(Duration(milliseconds: snoozeTimeInMillis));
    int snoozeTimeEpoch = snoozeTriggerTime.millisecondsSinceEpoch;

    // Schedule the alarm in Native Code
    await controller.setAlarmNative(snoozeTimeEpoch, widget.alarm.id!, widget.alarm.repeatDays);

    debugPrint("Alarm ID ${widget.alarm.id} snoozed for ${widget.alarm.snoozeDuration} minutes.");

    // Do not close the notification if the alarm is repeating
    if (widget.alarm.repeatDays.isEmpty) {
      await NotificationHelper.closeNotification(widget.alarm.id!, widget.alarm.repeatDays);
    }

    _closeApp(); // Close the app so no screen is shown
  }

  /// **Stop All Running Processes**
  void _stopAlarmProcesses() {
    _audioPlayer.stop();
    Vibration.cancel();
  }

  /// **Close the App Properly (Ensures No Background Activity)**
  void _closeApp() {
    const platform = MethodChannel("alarm_channel");
    if (Platform.isAndroid) {
      platform.invokeMethod("closeApp"); // Call the Android function
    } else {
      exit(0); // Exit the app on iOS
    }
  }

  /// **Format Repeat Days**
  // String formatRepeatDays(List<String> repeatDays) {
  //   if (repeatDays.length == 7) {
  //     return "Everyday";
  //   } else if (repeatDays.isNotEmpty) {
  //     return repeatDays.join(', ');
  //   }
  //   return "Today";
  // }

  /// **Format Time Based on User Settings**
  String formatTime(int hour, int minute, bool isAm, int timeFormat) {
    if (timeFormat == 24) {
      // 24-hour format, show time as is
      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    } else {
      // 12-hour format conversion
      String period = 'AM';
      int displayHour = hour;

      if (hour == 0) {
        displayHour = 12; // Midnight case (00:xx -> 12:xx AM)
        period = 'AM';
      } else if (hour == 12) {
        displayHour = 12; // Noon case (12:xx -> 12:xx PM)
        period = 'PM';
      } else if (hour > 12) {
        displayHour = hour; // Convert PM times (13:xx -> 1:xx PM)
        period = 'PM';
      } else {
        period = 'AM'; // AM times (1:xx -> 1:xx AM)
      }

      return "$displayHour:${minute.toString().padLeft(2, '0')} $period";
    }
  }


  @override
  Widget build(BuildContext context) {
    // Determine the image source (Supports Network & Local)
    String backgroundImage = widget.alarm.backgroundImage;
    ImageProvider imageProvider;

    if (backgroundImage.startsWith("http") ||
        backgroundImage.startsWith("https")) {
      imageProvider = NetworkImage(backgroundImage); // Network image
    } else if (File(backgroundImage).existsSync()) {
      imageProvider = FileImage(File(backgroundImage)); // Local image
    } else {
      imageProvider = const AssetImage(ImagePath.cat); // Fallback asset image
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
                          widget.alarm.hour,
                          widget.alarm.minute,
                          widget.alarm.isAm,
                          controller.timeFormat.value, // Pass the time format
                        ),
                        color: Colors.white,
                        fontSize: getWidth(40),
                        fontWeight: FontWeight.w600,
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
                          text: controller.formatRepeatDays(widget.alarm.repeatDays),
                          fontSize: getWidth(20),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Alarm Label
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                    child: CustomText(
                      text: widget.alarm.label,
                      fontSize: getWidth(36),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: getHeight(24)),

                  // Dismiss & Snooze Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Snooze Button
                      GestureDetector(
                        onTap: _snoozeAlarm,
                        child: Container(
                          height: getHeight(60),
                          width: getWidth(120),
                          decoration: BoxDecoration(
                            color: Colors.white,
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

                      SizedBox(width: getWidth(20)),

                      // Dismiss Button
                      GestureDetector(
                        onTap: _dismissAlarm,
                        child: Container(
                          height: getHeight(60),
                          width: getWidth(120),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: "Dismiss",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
