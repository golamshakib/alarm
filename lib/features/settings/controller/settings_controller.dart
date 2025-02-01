import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';

class SettingsController extends GetxController {
  final RxInt selectedTime = 12.obs; // Default to 12-hour format
  final List<int> timeFormat = [12, 24]; // Available time formats
  final DBHelperAlarm dbHelper = DBHelperAlarm(); // To interact with DB


  @override
  void onInit() {
    super.onInit();
    loadTimeFormat(); // Load time format when the controller is initialized
  }

  /// Update the selected time format and save it to SharedPreferences
  Future<void> updateTime(int format) async {
    selectedTime.value = format;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeFormat', format);
  }

  /// Load the time format from SharedPreferences
  Future<void> loadTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    selectedTime.value = prefs.getInt('timeFormat') ?? 12; // Default to 12-hour format
  }

  /// Reset all alarms from the database and clear UI
  Future<void> resetAllAlarms() async {
    try {
      await dbHelper.clearAlarms();
      Get.find<AddAlarmController>().alarms.clear(); // Clear alarms list in UI controller
    } catch (e) {
      Get.snackbar("Error", "Failed to reset alarms: $e", duration: const Duration(seconds: 2));
    }
  }
}
