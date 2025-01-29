
import 'package:get/get.dart';

import '../../../core/utils/helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../alarm_notification/notification_helper.dart';

class AlarmScreenController extends GetxController {

  final AddAlarmController controller = Get.find<AddAlarmController>();

// Alarm Screen Method
  void toggleAlarm(int index) async {
    final dbHelper = DBHelperAlarm();
    final alarm = controller.alarms[index];

    // Toggle the alarm state
    alarm.isToggled.value = !alarm.isToggled.value;
    controller.alarms.refresh(); // Update UI

    try {
      await dbHelper.updateAlarm(alarm); // Update database

      if (!alarm.isToggled.value) {
        await NotificationHelper.cancelAlarm(alarm.id!); // Cancel notification
        print("🚫 Alarm ${alarm.id} canceled.");
      } else {
        DateTime alarmTime = controller.calculateNextAlarmTime(alarm, DateTime.now());
        await NotificationHelper.scheduleAlarm(
          id: alarm.id!,
          title: "Alarm",
          body: alarm.label,
          scheduledTime: alarmTime,
        );
        print("🔔 Alarm ${alarm.id} rescheduled for: $alarmTime");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update alarm: $e");
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