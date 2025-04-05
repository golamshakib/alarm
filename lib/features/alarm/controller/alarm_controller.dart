import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../add_alarm/data/alarm_model.dart';

class AlarmController extends GetxController {
  final AddAlarmController controller = Get.find<AddAlarmController>();

  static const platform = MethodChannel('alarm_channel');

  // Fetch alarms and reschedule
  // This method will be triggered by the BootReceiver after device restart
  Future<void> rescheduleAlarms() async {
    final dbHelper = DBHelperAlarm();
    List<Alarm> alarms = await dbHelper.fetchAlarms();

    // Loop through all alarms and reschedule them
    for (var alarm in alarms) {
      DateTime nextAlarmTime =
          getNextAlarmTime(alarm); // Calculate the next alarm time
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

  // This method calculates the next alarm time
  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();
    DateTime alarmTime =
        DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);

    if (alarmTime.isBefore(now)) {
      alarmTime =
          alarmTime.add(const Duration(days: 1)); // Move to the next day
    }
    return alarmTime;
  }

  // This method calls the native method to set the alarm
  // Future<void> setAlarmNative(
  //     int timeInMillis, int alarmId, List<String> repeatDays) async {
  //   const MethodChannel _channel = MethodChannel('alarm_channel');
  //   try {
  //     await _channel.invokeMethod('setAlarm', {
  //       'time': timeInMillis,
  //       'alarmId': alarmId,
  //       'repeatDays': repeatDays.isNotEmpty ? repeatDays : [],
  //     });
  //     debugPrint(
  //         "Alarm Set for $alarmId at $timeInMillis with repeat days: $repeatDays");
  //   } on PlatformException catch (e) {
  //     debugPrint("Failed to set alarm: ${e.message}");
  //   }
  // }
}
