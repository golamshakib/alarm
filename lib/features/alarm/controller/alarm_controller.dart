import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../add_alarm/data/alarm_model.dart';

class AlarmController extends GetxController {
  static const platform = MethodChannel('alarm_channel');

  // Fetch alarms and reschedule
  Future<void> rescheduleAlarms() async {
    final dbHelper = DBHelperAlarm();
    List<Alarm> alarms = await dbHelper.fetchAlarms();  // Fetch alarms from the local DB

    for (var alarm in alarms) {
      DateTime nextAlarmTime = getNextAlarmTime(alarm);
      int timeInMillis = nextAlarmTime.millisecondsSinceEpoch;

      // Call the native side to set the alarm with the next time
      try {
        await platform.invokeMethod('setAlarm', {
          'time': timeInMillis,
          'alarmId': alarm.id,
          'repeatDays': alarm.repeatDays,
        });
        print('Alarm Rescheduled for ${alarm.id}');
      } on PlatformException catch (e) {
        print('Failed to reschedule alarm: ${e.message}');
      }
    }
  }

  // Calculate the next alarm time based on repeat days
  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);

    // If the alarm time is already in the past, set it for the next day
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    // You can add additional logic here to check the repeat days and adjust the next alarm time
    return alarmTime;
  }
}
