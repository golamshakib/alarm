import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddAlarmController extends GetxController {
  final labelController = TextEditingController();
  // Time selection
  var selectedHour = 7.obs; // Default to 1 AM
  var selectedMinute = 0.obs;
  var isAm = true.obs;
  var isSelectionMode = false.obs;
  var selectedAlarms = <int>[].obs;

  // Alarm label
  var label = 'Morning Alarm'.obs;

  // Repeat days
  var repeatDays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  }.obs;

  // Snooze duration
  var selectedSnoozeDuration = 5.obs; // Default snooze duration (5 minutes)

  // Vibration toggle
  var isVibrationEnabled = true.obs;

  // Volume
  var volume = 100.0.obs; // Default volume set to 50%
  var selectedBackground = "Cute Dog in bed".obs;
  var selectedBackgroundImage = "assets/images/dog.jpg".obs;
  final List<int> snoozeOptions = [5, 10, 15, 20, 25, 30];
  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
  }

  // List of alarms
  var alarms = <Alarm>[].obs;

  // Save the current alarm
  void saveAlarm() {
    final alarm = Alarm(
      hour: selectedHour.value,
      minute: selectedMinute.value,
      isAm: isAm.value,
      label: label.value.isEmpty ? 'Morning Alarm' : label.value,
      repeatDays: repeatDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      isToggled: false,
    );
    alarms.add(alarm);
    update(); // Notify listeners
  }
  void toggleAlarm(int index) {
    alarms[index].isToggled.value = !alarms[index].isToggled.value;
    alarms.refresh(); // Notify the UI to rebuild
  }
  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
  }

  // Reset fields after saving
  void resetFields() {
    selectedHour.value = 1;
    selectedMinute.value = 0;
    isAm.value = true;
    label.value = '';
    repeatDays.updateAll((key, value) => false);
    selectedSnoozeDuration.value = 5;
    isVibrationEnabled.value = false;
    volume.value = 50.0;
  }

  // Toggle a repeat day
  void toggleDay(String day) {
    repeatDays[day] = !repeatDays[day]!;
    repeatDays.refresh();
  }

  // Toggle vibration
  void toggleVibration() {
    isVibrationEnabled.value = !isVibrationEnabled.value;
  }

  // Set volume
  void setVolume(double newVolume) {
    volume.value = newVolume;
  }



  // Enable selection mode
  void enableSelectionMode(int index) {
    isSelectionMode.value = true;
    selectedAlarms.add(index);
  }

  // Toggle selection
  void toggleSelection(int index) {
    if (selectedAlarms.contains(index)) {
      selectedAlarms.remove(index);
    } else {
      selectedAlarms.add(index);
    }
  }

  // Exit selection mode
  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedAlarms.clear();
  }

  // Delete selected alarms
  void deleteSelectedAlarms() {
    alarms.removeWhere((alarm) => selectedAlarms.contains(alarms.indexOf(alarm)));
    exitSelectionMode();
  }

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }
}

// Alarm model
class Alarm {
  int hour;
  int minute;
  bool isAm;
  String label;
  List<String> repeatDays;
  RxBool isToggled;

  Alarm({
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.label,
    required this.repeatDays,
    bool isToggled = false,
  }) : isToggled = isToggled.obs;
}