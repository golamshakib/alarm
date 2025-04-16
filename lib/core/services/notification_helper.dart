import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notification settings
  static Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Display a persistent notification
  static Future<void> showPersistentNotification(
      int alarmId, String alarmTime, String label) async {
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

    await flutterLocalNotificationsPlugin.show(
      alarmId, // Unique notification ID
      'Upcoming Alarm', // Title
      'Alarm at $alarmTime - $label', // Content
      platformChannelSpecifics,
      payload: 'alarm $alarmId',
    );
  }

  // Close notification
  static Future<void> closeNotification(int alarmId) async {
    await flutterLocalNotificationsPlugin.cancel(alarmId);
  }
}
