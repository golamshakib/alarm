import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/Auth_service.dart';
import 'features/alarm_notification/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter engine
  await NotificationHelper.initializeNotifications();
  await NotificationHelper.requestNotificationPermissions(); // Request permissions
  await AuthService.init();
  runApp(const MyApp());
}
