import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../add_alarm/data/alarm_model.dart';

class AlarmController extends GetxController {
  final AddAlarmController controller = Get.find<AddAlarmController>();

  // This method should be triggered when the BootReceiver calls the Flutter method
  Future<void> rescheduleAlarms() async {
    final dbHelper = DBHelperAlarm();
    List<Alarm> alarms = await dbHelper.fetchAlarms();

    // Loop through all alarms and reschedule them
    for (var alarm in alarms) {
      DateTime nextAlarmTime = getNextAlarmTime(alarm); // Calculate the next alarm time
      int timeInMillis = nextAlarmTime.millisecondsSinceEpoch;

      // Call the native side (Android) to set the alarm with the next time
      try {
        await controller.setAlarmNative(timeInMillis, alarm.id!, alarm.repeatDays);
        debugPrint('Alarm Rescheduled for ${alarm.id}');
      } catch (e) {
        debugPrint('Failed to reschedule alarm: $e');
      }
    }
  }

  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1)); // Move to the next day
    }
    return alarmTime;
  }
}

