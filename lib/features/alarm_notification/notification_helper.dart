import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../add_alarm/controller/add_alarm_controller.dart';
import '../add_alarm/data/alarm_model.dart';
import '../alarm/alarm_trigger_screen.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// **Initialize Notifications**
  static Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification Clicked!");

        if (!Get.isRegistered<AddAlarmController>()) {
          Get.put(AddAlarmController());
        }

        final alarmController = Get.find<AddAlarmController>();

        if (response.payload != null) {
          int alarmId = int.tryParse(response.payload!) ?? -1;
          if (alarmId != -1) {
            final alarm = alarmController.alarms.firstWhereOrNull((a) => a.id == alarmId);
            if (alarm != null && alarm.isToggled.value) { // Ensure alarm is enabled
              Get.to(() => AlarmTriggerScreen(alarm: alarm));
            } else {
              print("Alarm not found or toggled off!");
            }
          }
        }
      },
    );
  }

  /// **Request Notification Permissions (For Android 13+)**
  static Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    final overlayStatus = await Permission.systemAlertWindow.request();

    if (status.isDenied || overlayStatus.isDenied) {
      print("User denied notification or overlay permissions.");
    } else if (status.isPermanentlyDenied || overlayStatus.isPermanentlyDenied) {
      print("User permanently denied notifications. Open settings to enable.");
      openAppSettings(); // Open settings if permanently denied
    } else {
      print("Notification and overlay permissions granted!");
    }
  }


  /// **Schedule a Full-Screen Alarm Notification**
  static Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Notifications',
      channelDescription: 'Notifications for alarms',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      // sound: RawResourceAndroidNotificationSound('alarm_sound'), // Ensure `alarm_sound.mp3` exists in `res/raw/`
      playSound: true,
      sound: null,
      enableVibration: true,
    );

    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: id.toString(),
    );

    print("Alarm scheduled for: $scheduledDate with ID: $id");
  }

  /// **Cancel a Scheduled Alarm Notification**
  static Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print("Alarm with ID: $id has been canceled.");
  }

  /// **Snooze the Alarm (Re-Schedule After Snooze Duration)**
  static Future<void> snoozeAlarm({required Alarm alarm}) async {
    // Calculate the new time for the snoozed alarm
    DateTime snoozeDuration = DateTime.now().add(Duration(minutes: alarm.snoozeDuration));

    print("Snooze set for: $snoozeDuration");

    await scheduleAlarm(
      id: alarm.id!,
      title: "Snoozed Alarm",
      body: "${alarm.label} (Snoozed)",
      scheduledTime: snoozeDuration,
    );
  }
}
