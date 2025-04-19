import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../features/add_alarm/controller/add_alarm_controller.dart';
final AddAlarmController addAlarmController = Get.put(AddAlarmController());
class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notification settings
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Display a persistent notification (with repeat days logic)
  static Future<void> showPersistentNotification(
      int alarmId, String alarmTime, String label, List<String> repeatDays) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alarm_channel', // channel id
      'Alarm Notifications', // channel name
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true, // Make it persistent
      visibility: NotificationVisibility
          .public, // Make it visible on the lock screen
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // // Format the repeat days using your formatRepeatDays method
    // String formatRepeatDays(List<String> repeatDays) {
    //   if (repeatDays.isEmpty) return "Today"; // Default if empty
    //   if (repeatDays.length == 7) return "Everyday"; // If all days are selected
    //   return repeatDays.join(', '); // Otherwise, join with commas
    // }

    String repeatDaysFormatted = addAlarmController.formatRepeatDays(repeatDays);
    // Show the notification only if the alarm is set to repeat
    String message = repeatDays.isNotEmpty
        ? 'Alarm at - $repeatDaysFormatted - $alarmTime - $label'
        : 'Alarm at $alarmTime - $label';

    await flutterLocalNotificationsPlugin.show(
      alarmId, // Unique notification ID
      'Upcoming Alarm', // Title
      message, // Content
      platformChannelSpecifics,
      payload: 'alarm $alarmId',
    );
  }

  // Close notification (for non-repeating alarms after the alarm triggers)
  static Future<void> closeNotification(int alarmId, List<String> repeatDays) async {
    // Only cancel notification if it's not a repeat alarm
    if (repeatDays.isEmpty) {
      await flutterLocalNotificationsPlugin.cancel(alarmId);
    }
  }
}

