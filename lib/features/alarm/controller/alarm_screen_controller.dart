
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../add_alarm/data/alarm_model.dart';

class AlarmScreenController extends GetxController {
  final DBHelperAlarm dbHelper = DBHelperAlarm();
  final AddAlarmController controller = Get.find<AddAlarmController>();

  /// **Toggle Alarm ON/OFF**
  void toggleAlarm(int index) async {
    try {
      // Get the alarm object using the updated index
      Alarm alarm = controller.alarms[index];

      // Toggle the alarm ON/OFF
      alarm.isToggled.value = !alarm.isToggled.value;

      // Update the alarm in the database
      await dbHelper.updateAlarm(alarm);

      if (alarm.isToggled.value) {
        // If the alarm is ON, set it at the next scheduled time
        DateTime nextAlarmTime = getNextAlarmTime(alarm);
        int alarmTimeInMillis = nextAlarmTime.millisecondsSinceEpoch;
        await controller.setAlarmNative(alarmTimeInMillis, alarm.id!, alarm.repeatDays);
      } else {
        // If the alarm is OFF, cancel it
        await controller.cancelAlarmNative(alarm.id!);
      }

      // Refresh the list after toggling
      fetchAlarms();
      update(); // Ensure UI updates

    } catch (e) {
      debugPrint("Error toggling alarm: $e");
    }
  }



  /// **Get Next Alarm Time Based on Current Time**
  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.isAm ? alarm.hour : (alarm.hour % 12) + 12,
      alarm.minute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1)); // Move to the next day
    }

    return alarmTime;
  }

  /// **Fetch All Alarms from Database**
  Future<void> fetchAlarms() async {
    try {
      List<Alarm> fetchedAlarms = await dbHelper.fetchAlarms();

      // Ensure repeatDays is correctly formatted
      for (var alarm in fetchedAlarms) {
        if (alarm.repeatDays.isEmpty) {
          alarm.repeatDays.assignAll(["Today"]); // Fallback to "Today" if empty
        }
      }
      sortAlarmsChronologically(fetchedAlarms);
      controller.alarms.assignAll(fetchedAlarms);
      update(); // 🔹 Ensure UI updates after fetching
    } catch (e) {
      debugPrint("Error fetching alarms: $e");
    }
  }

  void sortAlarmsChronologically(List<Alarm> alarms) {
    alarms.sort((a, b) {
      final aTime = a.isAm ? a.hour % 12 : (a.hour % 12) + 12;
      final bTime = b.isAm ? b.hour % 12 : (b.hour % 12) + 12;

      final aTotalMinutes = aTime * 60 + a.minute;
      final bTotalMinutes = bTime * 60 + b.minute;

      return aTotalMinutes.compareTo(bTotalMinutes);
    });
  }

  // Selection mode on the Alarm Screen
  var isSelectionMode = false.obs;
  var selectedAlarms = <int>[].obs;

// Enable selection mode
  void enableSelectionMode(int index) {
    isSelectionMode.value = true;
    if (!selectedAlarms.contains(index)) {
      selectedAlarms.add(index); // Add the index of the selected alarm
    }
  }

// Toggle selection for deletion
  void toggleSelection(int index) {
    if (selectedAlarms.contains(index)) {
      selectedAlarms.remove(index); // Remove from selection if already selected
    } else {
      selectedAlarms.add(index); // Add to selection if not selected
    }
  }

// Exit selection mode
  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedAlarms.clear();
  }

// Delete selected alarms
  Future<void> deleteSelectedAlarms() async {
    final dbHelper = DBHelperAlarm(); // Instantiate the database helper

    // Loop through selected alarms and delete them from the database
    for (int index in selectedAlarms) {
      final alarm = controller.alarms[index]; // Get the alarm at the selected index
      if (alarm.id != null) {
        await dbHelper.deleteAlarm(
            alarm.id!); // Delete the alarm from the database
      }
    }

    // Remove the alarms from the local list
    controller.alarms.removeWhere((alarm) =>
        selectedAlarms.contains(controller.alarms.indexOf(alarm)));

    // Exit selection mode and clear the selection
    exitSelectionMode();

    Get.snackbar("Success", "Selected alarms deleted successfully!");
  }

}