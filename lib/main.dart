import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/Auth_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter engine
  await NotificationService.initializeNotifications();
  await NotificationService.requestNotificationPermissions(); // Request permissions
  runApp(const MyApp());
}
