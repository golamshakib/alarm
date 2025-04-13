import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  /// **Request Notification Permissions (For Android 13+)**
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
}
