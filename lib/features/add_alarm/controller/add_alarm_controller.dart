import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddAlarmController extends GetxController {
  final labelController = TextEditingController();

  // Time selection
  var selectedHour = 7.obs; // Default to 7 AM
  var selectedMinute = 0.obs;
  var isAm = true.obs;
  var isSelectionMode = false.obs;
  var selectedAlarms = <int>[].obs;

  void setCurrentTime() {
    // Set the current time to the selected hour and minute
    DateTime now = DateTime.now();
    selectedHour.value = now.hour > 12 ? now.hour - 12 : now.hour;
    selectedMinute.value = now.minute;
    isAm.value = now.hour < 12;
  }

  @override
  void onInit() {
    super.onInit();
    setCurrentTime(); // Set the current time when the controller is initialized
  }

  // Select Background
  var selectedBackground = "Cute Dog in bed".obs;
  var selectedBackgroundImage = "assets/images/dog.png".obs;

  // Method to update the background
  void setAlarmBackground(String backgroundName, String backgroundImagePath) {
    selectedBackground.value = backgroundName;
    selectedBackgroundImage.value = backgroundImagePath;
  }

  // Alarm label
  var label = 'Morning Alarm'.obs;

  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
  }

  // Snooze duration
  final List<int> snoozeOptions = [5, 10, 15, 20, 25, 30];
  var selectedSnoozeDuration = 5.obs; // Default snooze duration (5 minutes)

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
  }

  // Vibration toggle
  var isVibrationEnabled = true.obs;
  // Toggle vibration
  void toggleVibration() {
    isVibrationEnabled.value = !isVibrationEnabled.value;
  }

  // Volume
  var volume = 100.0.obs; // Default volume set to 50%
  // Set volume
  void setVolume(double newVolume) {
    volume.value = newVolume;
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
      repeatDays: List.from(repeatDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)),
      isToggled: true,
    );
    alarms.add(alarm); // Add alarm to the list of alarms
    update(); // Notify listeners
  }

  // Method to toggle a repeat day for a specific alarm
  void toggleDayForAlarm(String day, Alarm alarm) {
    if (alarm.repeatDays.contains(day)) {
      alarm.repeatDays.remove(day); // Remove day if it's already selected
    } else {
      alarm.repeatDays.add(day); // Add day if it's not selected
    }
    update(); // Update UI
  }

  // Repeat days for this controller
  var repeatDays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  }.obs;

  // Method to toggle a repeat day (works globally, but we'll handle it on individual alarms)
  void toggleDay(String day) {
    repeatDays[day] = !repeatDays[day]!;
    updateRepeatDaysLogic();  // Update the logic after toggling
    update(); // Notify listeners to rebuild UI if necessary
  }

  // Update the repeat days logic without changing the label on the screen
  void updateRepeatDaysLogic() {
    final formattedDays = formatRepeatDays();
    // Internally store the formatted days (but don't update the label here)
  }

  // Format repeat days: either show them as "Mon, Tue, Wed" or "Mon to Wed" or "Everyday"
  String formatRepeatDays() {
    final selectedDays = repeatDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedDays.isEmpty) {
      return 'No Repeat Days'; // Default if no days are selected
    }

    // If all days are selected, show "Everyday"
    if (selectedDays.length == 7) {
      return 'Everyday';
    }

    // Group consecutive days with "to"
    List<String> formattedDays = [];
    List<String> group = [selectedDays.first];

    for (int i = 1; i < selectedDays.length; i++) {
      final prevDay = selectedDays[i - 1];
      final currDay = selectedDays[i];

      // Check if the current day is consecutive to the previous day
      if (_isConsecutiveDay(prevDay, currDay)) {
        group.add(currDay);
      } else {
        // If not consecutive, add the previous group and start a new one
        formattedDays.add(_groupToString(group));
        group = [currDay];
      }
    }

    // Add the last group
    formattedDays.add(_groupToString(group));

    return formattedDays.join(', ');
  }

  // Helper function to check if two days are consecutive
  bool _isConsecutiveDay(String prevDay, String currDay) {
    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final prevIndex = daysOfWeek.indexOf(prevDay);
    final currIndex = daysOfWeek.indexOf(currDay);
    return currIndex == prevIndex + 1;
  }

  // Convert a group of consecutive days to a string (e.g., "Mon to Wed")
  String _groupToString(List<String> group) {
    if (group.length == 1) {
      return group.first;
    }
    return '${group.first} to ${group.last}';
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

  // Method to toggle an alarm (enable/disable)
  void toggleAlarm(int index) {
    // Toggle the alarm's state
    alarms[index].isToggled.value = !alarms[index].isToggled.value;
    update(); // Update the UI when the alarm state changes
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
