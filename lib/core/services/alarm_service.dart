import 'package:flutter/services.dart';
import '../../features/add_alarm/data/alarm_model.dart';
import '../db_helpers/db_helper_alarm.dart';

class AlarmService {
  static const MethodChannel _channel = MethodChannel('alarm_channel');

  // Handle Alarm Rescheduling on Device Restart
  Future<void> handleAlarmOnAppStart() async {
    try {
      // Fetch alarms from the local database
      final dbHelper = DBHelperAlarm();
      final alarms = await dbHelper.fetchAlarms();

      for (var alarm in alarms) {
        if (alarm.isToggled.value) {  // Use .value to access the actual boolean value
          final alarmTime = getNextAlarmTime(alarm);
          final alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;

          // Set the alarm using native Android code
          await _channel.invokeMethod('setAlarm', {
            'time': alarmTimeInMillis,
            'alarmId': alarm.id!,
            'repeatDays': alarm.repeatDays,
          });
        }
      }
    } catch (e) {
      print("Error in rescheduling alarms: $e");
    }
  }

  // Calculate the next alarm time based on repeat days
  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();
    int alarmHour = alarm.hour;

    // Adjust the hour based on 24-hour format
    if (!alarm.isAm && alarm.hour < 12) {
      alarmHour += 12; // Convert PM hours
    } else if (alarm.isAm && alarm.hour == 12) {
      alarmHour = 0; // Midnight
    }

    DateTime alarmDateTime = DateTime(now.year, now.month, now.day, alarmHour, alarm.minute);

    // If the alarm time has already passed today, move to the next day
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(Duration(days: 1));
    }

    // Handle repeat days
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
