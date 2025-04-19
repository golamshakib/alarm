import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      visibility: NotificationVisibility.public, // Make it visible on the lock screen
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification only if the alarm is set to repeat
    String message = repeatDays.isNotEmpty
        ? 'Alarm at - ${repeatDays.join(', ')} - $alarmTime - $label' // Show repeat days
        : 'Alarm at $alarmTime - $label'; // Non-repeating alarm message

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

