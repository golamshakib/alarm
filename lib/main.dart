import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.requestNotificationPermissions();
  runApp(const MyApp());
}
