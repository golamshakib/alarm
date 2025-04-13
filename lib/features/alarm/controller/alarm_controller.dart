import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alarm/features/add_alarm/data/alarm_model.dart';
import 'package:alarm/core/db_helpers/db_helper_alarm.dart';

import '../../add_alarm/controller/add_alarm_controller.dart';

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

    int alarmHour = alarm.hour;

    // Adjust hour for 24-hour format
    if (!alarm.isAm && alarm.hour < 12) {
      alarmHour += 12; // PM times should be 12+ (e.g., 1 PM should be 13)
    } else if (alarm.isAm && alarm.hour == 00) {
      alarmHour = 0; // 12 AM should be 00:00 in 24-hour format
    } else if (!alarm.isAm && alarm.hour == 12) {
      alarmHour = 12; // Noon should stay 12:00 in 24-hour format
    }

    DateTime alarmDateTime = DateTime(now.year, now.month, now.day, alarmHour, alarm.minute);

    // If the alarm time is already past today, move to the next valid day
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    // If the user has selected repeat days, find the next valid day
    if (alarm.repeatDays.isNotEmpty) {
      List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      int todayIndex = now.weekday - 1; // Monday is index 0

      for (int i = 0; i < 7; i++) {
        int nextDayIndex = (todayIndex + i) % 7;
        if (alarm.repeatDays.contains(weekDays[nextDayIndex])) {
          return alarmDateTime.add(Duration(days: i));
        }
      }
    }
    return alarmDateTime;
  }
}
