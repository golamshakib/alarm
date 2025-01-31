
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../add_alarm/data/alarm_model.dart';
import '../../../core/utils/helpers/notification_helper.dart';

class AlarmScreenController extends GetxController {
  final DBHelperAlarm dbHelper = DBHelperAlarm();
  final AddAlarmController controller = Get.find<AddAlarmController>();

  /// **Toggle Alarm ON/OFF**
  void toggleAlarm(int index) async {
    try {
      // Get the alarm object
      Alarm alarm = controller.alarms[index];

      // Toggle the value in memory
      alarm.isToggled.value = !alarm.isToggled.value;

      // 🔹 Update the database with the modified alarm state
      await dbHelper.updateAlarm(alarm);

      // 🔹 If the alarm is OFF, cancel the scheduled notification
      if (!alarm.isToggled.value) {
        await NotificationHelper.cancelAlarm(alarm.id!);
        debugPrint("Notification for alarm ID ${alarm.id} has been canceled.");
      } else {
        // 🔹 If the alarm is ON, schedule the notification
        DateTime scheduledTime = getNextAlarmTime(alarm);
        await NotificationHelper.scheduleAlarm(
          id: alarm.id!,
          title: "Alarm",
          body: alarm.label,
          scheduledTime: scheduledTime,
        );
        debugPrint("Notification for alarm ID ${alarm.id} has been scheduled.");
      }

      // 🔹 Refresh the list from the database
      fetchAlarms();

      update(); // Ensure UI is refreshed
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
      controller.alarms.assignAll(fetchedAlarms);
      update(); // 🔹 Ensure UI updates after fetching
    } catch (e) {
      debugPrint("Error fetching alarms: $e");
    }
  }

// Selection mode on the Alarm Screen
  var isSelectionMode = false.obs;
  var selectedAlarms = <int>[].obs;

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