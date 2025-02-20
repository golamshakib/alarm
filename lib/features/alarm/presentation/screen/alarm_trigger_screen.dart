import 'dart:io';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';
import '../../../add_alarm/controller/add_alarm_controller.dart';
import '../../../add_alarm/data/alarm_model.dart';
import '../../../../core/services/notification_service.dart';

class AlarmTriggerScreen extends StatefulWidget {
  final Alarm alarm;

  const AlarmTriggerScreen({super.key, required this.alarm});

  @override
  _AlarmTriggerScreenState createState() => _AlarmTriggerScreenState();
}

class _AlarmTriggerScreenState extends State<AlarmTriggerScreen> {
  final AddAlarmController controller = Get.find<AddAlarmController>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playAlarmSound(); // Manually play alarm sound
    _triggerVibration();
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
      } catch (e) {
        debugPrint("Error playing alarm sound: $e");
      }
    }
  }

  /// **Trigger Vibration if Enabled**
  Future<void> _triggerVibration() async {
    if (widget.alarm.isVibrationEnabled) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500, 1000], repeat: 5);
    }
  }

  /// **Dismiss Alarm**
  void _dismissAlarm() {
    _audioPlayer.stop();
    Vibration.cancel();
    Get.back();
    // SystemNavigator.pop(); // Force close the app
  }

  /// **Snooze Alarm and Re-Schedule Notification**
  void _snoozeAlarm() {
    _audioPlayer.stop();
    Vibration.cancel();
    // NotificationService.snoozeAlarm(alarm: widget.alarm);
    Get.back();
    // SystemNavigator.pop(); // Force close the app
  }

  /// **Format Repeat Days**
  String formatRepeatDays(List<String> repeatDays) {
    if (repeatDays.length == 7) {
      return "Everyday";
    } else if (repeatDays.isNotEmpty) {
      return repeatDays.join(', ');
    }
    return "No Repeat Days";
  }

  /// **Format Time Based on User Settings**
  String formatTime(int hour, int minute, bool isAm, int timeFormat) {
    if (timeFormat == 24) {
      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    } else {
      return "${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";
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
                        text: formatTime(widget.alarm.hour, widget.alarm.minute,
                            widget.alarm.isAm, controller.timeFormat.value),
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
                          text: formatRepeatDays(widget.alarm.repeatDays),
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
