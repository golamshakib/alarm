import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/add_alarm_model.dart';


class AddAlarmController extends GetxController {
  final labelController = TextEditingController();

  // Time management
  var selectedHour = 7.obs;
  var selectedMinute = 15.obs;
  var isAm = true.obs;
  var label = 'Morning Alarm'.obs;
  var selectedSnoozeDuration = 10.obs;
  final List<int> snoozeOptions = [5, 10, 15, 20, 25, 30];

  // Background
  var selectedBackground = "Cute Dog in bed".obs;
  var selectedBackgroundImage = "assets/images/dog.jpg".obs;

  // Repeat days
  var repeatDays = <String, bool>{
    "Su": false,
    "Mo": true,
    "Tu": true,
    "We": false,
    "Th": false,
    "Fr": true,
    "Sa": false,
  }.obs;

  // Vibration
  var isToggled = true.obs;
  // Vibration toggle
  void vibrationToggle() {
    isToggled.value = !isToggled.value; // Toggle the vibration state
  }

  // Volume
  var volume = 100.0.obs;

  // Alarm List
  var alarms = <AlarmModel>[].obs;


  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
  }
  // Toggle repeat days
  void toggleDay(String day) {
    if (repeatDays.containsKey(day)) {
      repeatDays[day] = !repeatDays[day]!;
      repeatDays.refresh(); // Refresh to update the UI
    }
  }

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
  }

  // Set volume
  void setVolume(double value) {
    volume.value = value;
  }

  // Save alarm to the list
  void saveAlarm() {
    final List<String> activeDays = repeatDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final newAlarm = AlarmModel(
      hour: selectedHour.value,
      minute: selectedMinute.value,
      isAm: isAm.value,
      label: label.value,
      backgroundName: selectedBackground.value,
      backgroundImage: selectedBackgroundImage.value,
      repeatDays: activeDays,
      vibrationEnabled: isToggled.value,
      snoozeDuration: selectedSnoozeDuration.value,
      volume: volume.value,
    );

    alarms.add(newAlarm);
    // Get.snackbar("Success", "Alarm added successfully!",
    //     snackPosition: SnackPosition.BOTTOM);
  }

  // Reset all fields after saving an alarm
  // void resetFields() {
  //   selectedHour.value = 7;
  //   selectedMinute.value = 15;
  //   isAm.value = true;
  //   label.value = 'Morning Alarm';
  //   selectedBackground.value = "Cute Dog in bed";
  //   selectedBackgroundImage.value = "assets/images/dog.jpg";
  //   repeatDays.updateAll((key, value) => false);
  //   isToggled.value = false;
  //   selectedSnoozeDuration.value = 10;
  //   volume.value = 100.0;
  // }

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }
}
