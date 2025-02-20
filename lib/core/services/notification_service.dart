import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/add_alarm/controller/add_alarm_controller.dart';
import '../../features/add_alarm/data/alarm_model.dart';
import '../../features/alarm/presentation/screen/alarm_trigger_screen.dart';

class NotificationService {
  // static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  //
  // /// **Initialize Notifications**
  // static Future<void> initializeNotifications() async {
  //   tz.initializeTimeZones();
  //
  //   const AndroidInitializationSettings androidInitializationSettings =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(android: androidInitializationSettings);
  //
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse response) async {
  //       if (!Get.isRegistered<AddAlarmController>()) {
  //         Get.put(AddAlarmController());
  //       }
  //
  //       final alarmController = Get.find<AddAlarmController>();
  //
  //       if (response.payload != null) {
  //         int alarmId = int.tryParse(response.payload!) ?? -1;
  //         if (alarmId != -1) {
  //           final alarm =
  //           alarmController.alarms.firstWhereOrNull((a) => a.id == alarmId);
  //           if (alarm != null && alarm.isToggled.value) {
  //             Get.to(() => AlarmTriggerScreen(alarm: alarm));
  //           } else {
  //             print("Alarm not found or toggled off!");
  //           }
  //         }
  //       }
  //     },
  //   );
  // }
  //
  // /// **Request Notification Permissions (For Android 13+)**
   static Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    final overlayStatus = await Permission.systemAlertWindow.request();

    if (status.isDenied || overlayStatus.isDenied) {
      debugPrint("User denied notification or overlay permissions.");
    } else if (status.isPermanentlyDenied || overlayStatus.isPermanentlyDenied) {
      log("User permanently denied notifications. Open settings to enable.");
      openAppSettings();
    } else {
      log("Notification and overlay permissions granted!");
    }
  }
  //
  // /// **Schedule a Full-Screen Alarm Notification**
  // static Future<void> scheduleAlarm({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledTime,
  // }) async {
  //   final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
  //
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'alarm_channel_id',
  //     'Alarm Notifications',
  //     channelDescription: 'Notifications for alarms',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     fullScreenIntent: true,
  //     playSound: true,
  //     enableVibration: true,
  //     visibility: NotificationVisibility.public,
  //     category: AndroidNotificationCategory.alarm,
  //   );
  //
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     scheduledDate,
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //     payload: id.toString(),
  //   );
  //
  //   log("Alarm scheduled for: $scheduledDate with ID: $id");
  //
  //   // ✅ Automatically launch `AlarmTriggerScreen` at the exact alarm time
  //   Future.delayed(scheduledTime.difference(DateTime.now()), () {
  //     log("Launching AlarmTriggerScreen for alarm ID: $id");
  //
  //     if (!Get.isRegistered<AddAlarmController>()) {
  //       Get.put(AddAlarmController());
  //     }
  //
  //     final alarmController = Get.find<AddAlarmController>();
  //     final alarm = alarmController.alarms.firstWhereOrNull((a) => a.id == id);
  //
  //     if (alarm != null && alarm.isToggled.value) {
  //       Get.to(() => AlarmTriggerScreen(alarm: alarm));
  //     } else {
  //       log("Alarm not found or toggled off.");
  //     }
  //   });
  // }
  //
  // /// **Cancel a Scheduled Alarm Notification**
  // static Future<void> cancelAlarm(int id) async {
  //   await flutterLocalNotificationsPlugin.cancel(id);
  //   log("Alarm with ID: $id has been canceled.");
  // }
  //
  // /// **Snooze the Alarm & Automatically Launch AlarmTriggerScreen**
  // static Future<void> snoozeAlarm({required Alarm alarm}) async {
  //   DateTime snoozeTime = DateTime.now().add(Duration(minutes: alarm.snoozeDuration));
  //   final tz.TZDateTime snoozedDate = tz.TZDateTime.from(snoozeTime, tz.local);
  //
  //   log("Snoozing alarm for: $snoozedDate");
  //
  //   // Schedule the snoozed notification
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'snooze_alarm_channel',
  //     'Snoozed Alarm Notifications',
  //     channelDescription: 'Notifications for snoozed alarms',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     fullScreenIntent: true,
  //     playSound: true,
  //     enableVibration: true,
  //     visibility: NotificationVisibility.public,
  //     category: AndroidNotificationCategory.alarm,
  //   );
  //
  //   final NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     alarm.id!,
  //     "Snoozed Alarm",
  //     "${alarm.label} (Snoozed)",
  //     snoozedDate,
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //     payload: alarm.id.toString(),
  //   );
  //
  //   // ✅ Automatically launch `AlarmTriggerScreen` when snooze time arrives
  //   Future.delayed(Duration(minutes: alarm.snoozeDuration), () {
  //     log("Launching AlarmTriggerScreen after snooze.");
  //     if (alarm.isToggled.value) {
  //       Get.to(() => AlarmTriggerScreen(alarm: alarm));
  //     }
  //   });
  //
  //   log("Snoozed alarm will trigger at: $snoozedDate with ID: ${alarm.id}");
  // }
}