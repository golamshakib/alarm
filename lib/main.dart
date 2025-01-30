import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'app.dart';
import 'core/services/Auth_service.dart';
import 'features/alarm_notification/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter engine
  await NotificationHelper.initializeNotifications();
  await NotificationHelper.requestNotificationPermissions(); // Request permissions
  WakelockPlus.enable();
  await AuthService.init();

  runApp(const MyApp());
}
