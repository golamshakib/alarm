
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants/api_constants.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  /// Initialize Push Notification Service
  Future<void> initialize() async {
    /// Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted permission for push notifications");
    } else {
      log("User denied or has not granted permission");
    }

    /// Get FCM Token (Optional: Use this for testing with FCM API)
    String? fcmToken = await _firebaseMessaging.getToken();
    log("FCM Token: $fcmToken");
    if (fcmToken != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', fcmToken);

      // Send the FCM token to the backend
      await sendTokenToBackend(fcmToken);
    }

    /// Handle Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received a foreground message: ${message.notification?.title}");
      _showNotification(message);
    });

    /// Handle Background and Terminated State Notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("User clicked on a notification while the app was in background.");
      // _navigateToScreen(message);
    });

    /// Handle Notification Click When App Was Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log("Notification clicked when app was terminated.");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _navigateToScreen(message);
        });
      }
    });

    /// Initialize Local Notification Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Local notification clicked");
        // _navigateToScreenFromLocal();
      },
    );
  }

  /// Show Local Notification
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new message',
      platformChannelSpecifics,
    );
  }

  /// Send FCM Token to Backend Server
  Future<void> sendTokenToBackend(String fcmToken) async {
    const String storeFcmToke = AppUrls.storeFcmToken;
    try {
      final response = await http.post(
        Uri.parse(storeFcmToke),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("FCM token sent successfully to backend");
      } else {
        log("Failed to send token to backend. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error sending token to backend: $e");
    }
  }

// /// Handle Navigation for Notification Clicks
// void _navigateToScreen(RemoteMessage message) {
//   navigatorKey.currentState?.push(
//     MaterialPageRoute(
//         // builder: (context) => const EnterPriseNotificationScreen()),
//
//   );
// }

//   /// Handle Local Notification Clicks
//   void _navigateToScreenFromLocal( ) {
//     navigatorKey.currentState?.push(
//       MaterialPageRoute(
//         builder: (context) => const EnterPriseNotificationScreen(),
//       ),
//     );
//   }
}