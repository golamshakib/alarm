
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../add_alarm/controller/add_alarm_controller.dart';
import '../../add_alarm/data/alarm_model.dart';

class AlarmScreenController extends GetxController {
  final DBHelperAlarm dbHelper = DBHelperAlarm();
  final AddAlarmController controller = Get.find<AddAlarmController>();

  /// **Toggle Alarm ON/OFF**
  void toggleAlarm(int index) async {
    try {
      Alarm alarm = controller.alarms[index];
      alarm.isToggled.value = !alarm.isToggled.value;
      await dbHelper.updateAlarm(alarm);
      if (alarm.isToggled.value) {
        DateTime nextAlarmTime = getNextAlarmTime(alarm);
        int alarmTimeInMillis = nextAlarmTime.millisecondsSinceEpoch;
        await controller.setAlarmNative(alarmTimeInMillis, alarm.id!, alarm.repeatDays);
      } else {
        await controller.cancelAlarmNative(alarm.id!);
      }
      fetchAlarms();
      update();

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
      alarmTime = alarmTime.add(const Duration(days: 1));
    }
    return alarmTime;
  }

  Future<void> fetchAlarms() async {
    try {
      List<Alarm> fetchedAlarms = await dbHelper.fetchAlarms();
      for (var alarm in fetchedAlarms) {
        if (alarm.repeatDays.isEmpty) {
          alarm.repeatDays.assignAll(["Today"]);
        }
      }
      sortAlarmsChronologically(fetchedAlarms);
      controller.alarms.assignAll(fetchedAlarms);
      update();
    } catch (e) {
      debugPrint("Error fetching alarms: $e");
    }
  }

  void sortAlarmsChronologically(List<Alarm> alarms) {
    alarms.sort((a, b) {
      final aTime = a.isAm ? a.hour % 12 : (a.hour % 12) + 12;
      final bTime = b.isAm ? b.hour % 12 : (b.hour % 12) + 12;

      final aTotalMinutes = aTime * 60 + a.minute;
      final bTotalMinutes = bTime * 60 + b.minute;

      return aTotalMinutes.compareTo(bTotalMinutes);
    });
  }
  var isSelectionMode = false.obs;
  var selectedAlarms = <int>[].obs;

  void enableSelectionMode(int index) {
    isSelectionMode.value = true;
    if (!selectedAlarms.contains(index)) {
      selectedAlarms.add(index);
    }
  }
  void toggleSelection(int index) {
    if (selectedAlarms.contains(index)) {
      selectedAlarms.remove(index);
    } else {
      selectedAlarms.add(index);
    }
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedAlarms.clear();
  }

  Future<void> deleteSelectedAlarms() async {
    final dbHelper = DBHelperAlarm();
    for (int index in selectedAlarms) {
      final alarm = controller.alarms[index];
      if (alarm.id != null) {
        await dbHelper.deleteAlarm(
            alarm.id!);
      }
    }
    controller.alarms.removeWhere((alarm) =>
        selectedAlarms.contains(controller.alarms.indexOf(alarm)));

    exitSelectionMode();
    Get.snackbar("Succès", "Les alarmes sélectionnées ont été supprimées avec succès");
  }
}