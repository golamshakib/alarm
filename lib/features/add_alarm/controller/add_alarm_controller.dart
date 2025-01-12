import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAlarmController extends GetxController {
  // Time management
  var selectedHour = 7.obs;
  var selectedMinute = 15.obs;
  var isAm = true.obs;

  // Background
  var selectedBackground = "Cute Dog in bed".obs;
  var selectedBackgroundImage = "assets/images/dog.jpg".obs;

  // Repeat days
  var repeatDays = <String, bool>{
    "Su": false,
    "Mo": true,
    "Tu": true,
    "We": true,
    "Th": true,
    "Fr": true,
    "Sa": false,
  }.obs;

  // Snooze duration
  var snoozeDuration = 10.obs; // In minutes

  // Vibration toggle
  var vibrationEnabled = true.obs;

  // Volume
  var volume = 5.0.obs;

  // Update time
  void setTime(int hour, int minute, bool am) {
    selectedHour.value = hour;
    selectedMinute.value = minute;
    isAm.value = am;
  }

  // Toggle repeat days
  void toggleDay(String day) {
    repeatDays[day] = !repeatDays[day]!;
    repeatDays.refresh(); // Refresh to update UI
  }

  // Set snooze duration
  void setSnooze(int duration) {
    snoozeDuration.value = duration;
  }

  // Toggle vibration
  void toggleVibration(bool value) {
    vibrationEnabled.value = value;
  }

  // Set volume
  void setVolume(double value) {
    volume.value = value;
  }
}
