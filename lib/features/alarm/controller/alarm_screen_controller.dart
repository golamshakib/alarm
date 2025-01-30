
import 'package:get/get.dart';

import '../../../core/utils/helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../add_alarm/data/alarm_model.dart';

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

      // 🔹 Update the database with the modified alarm
      await dbHelper.updateAlarm(alarm);

      // 🔹 Refresh the list from the database
      fetchAlarms();

      update(); // Ensure UI is refreshed
    } catch (e) {
      print("Error toggling alarm: $e");
    }
  }


  /// **Fetch All Alarms from Database**
  Future<void> fetchAlarms() async {
    try {
      List<Alarm> fetchedAlarms = await dbHelper.fetchAlarms();
      controller.alarms.assignAll(fetchedAlarms);
    } catch (e) {
      print("Error fetching alarms: $e");
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