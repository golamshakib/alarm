import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAlarmController extends GetxController {

  final labelController = TextEditingController();
  // Time management
  var selectedHour = 7.obs;
  var selectedMinute = 15.obs;
  var isAm = true.obs;
  var label = 'Morning Alarm'.obs;
  var selectedSnoozeDuration = 10.obs;
  final List<int> snoozeOptions = [5, 10, 15, 20, 25, 30];
  RxBool isSwitched = false.obs;

  // Vibration
  var isToggled = true.obs;
  // Method to toggle the state
  void vibrationToggle() {
    isToggled.value = !isToggled.value;
  }

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

  // Label
  // Set initial label text
  void setInitialLabel(String text) {
    label.value = text;
    labelController.text = text;
  }

  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
  }

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
  }




  // Volume
  var volume = 100.0.obs;

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

  // Set volume
  void setVolume(double value) {
    volume.value = value;
  }
  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }
}
