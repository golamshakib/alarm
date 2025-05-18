import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alarm/features/add_alarm/data/alarm_model.dart';
import 'package:alarm/core/db_helpers/db_helper_alarm.dart';

import '../../add_alarm/controller/add_alarm_controller.dart';

class AlarmController extends GetxController {
  final AddAlarmController controller = Get.find<AddAlarmController>();

  Future<void> rescheduleAlarms() async {
    final dbHelper = DBHelperAlarm();
    List<Alarm> alarms = await dbHelper.fetchAlarms();

    for (var alarm in alarms) {
      DateTime nextAlarmTime = getNextAlarmTime(alarm);
      int timeInMillis = nextAlarmTime.millisecondsSinceEpoch;

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

    if (!alarm.isAm && alarm.hour < 12) {
      alarmHour += 12;
    } else if (alarm.isAm && alarm.hour == 00) {
      alarmHour = 0;
    } else if (!alarm.isAm && alarm.hour == 12) {
      alarmHour = 12;
    }
    DateTime alarmDateTime = DateTime(now.year, now.month, now.day, alarmHour, alarm.minute);
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    if (alarm.repeatDays.isNotEmpty) {
      List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      int todayIndex = now.weekday - 1;

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
