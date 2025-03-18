import 'package:alarm/features/add_alarm/presentation/screens/local_background_screen.dart';
import 'package:alarm/features/nav_bar/presentation/screens/nav_bar.dart';
import 'package:alarm/features/splash_screen/presentation/screens/onboarding1.dart';
import 'package:alarm/features/splash_screen/presentation/screens/onboarding2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/db_helpers/db_helper_alarm.dart';
import '../features/add_alarm/data/alarm_model.dart';
import '../features/add_alarm/presentation/screens/change_back_ground_screen.dart';
import '../features/add_alarm/presentation/screens/create_new_background_screen.dart';
import '../features/alarm/presentation/screen/alarm_trigger_screen.dart';
import '../features/splash_screen/presentation/screens/onboarding3.dart';
import '../features/splash_screen/presentation/screens/splash_screen.dart';

class AppRoute {
  static String init = "/";
  static String onboarding1 = "/onboarding1";
  static String onboarding2 = "/onboarding2";
  static String onboarding3 = "/onboarding3";
  static String navBarScreen = "/navBarScreen";
  static String changeBackgroundScreen = "/changeBackgroundScreen";
  static String localBackgroundScreen = "/localBackgroundScreen";
  static String createNewAlarmScreen = "/createNewAlarmScreen";
  static String createNewBackgroundScreen = "/createNewBackgroundScreen";


  static const alarmTrigger = '/alarmTrigger';


  static List<GetPage> routes = [
    GetPage(name: init, page: () => const SplashScreen()),
    GetPage(name: onboarding1, page: () => const OnBoarding1Screen()),
    GetPage(name: onboarding2, page: () => const OnBoarding2Screen()),
    GetPage(name: onboarding3, page: () => const OnBoarding3Screen()),
    GetPage(name: navBarScreen, page: () => const CreatorNavBar()),

    GetPage(name: changeBackgroundScreen, page: () => const ChangeBackGroundScreen()),
    GetPage(name: localBackgroundScreen, page: () => const LocalBackgroundScreen()),
    GetPage(name: createNewAlarmScreen, page: () => const CreateNewBackgroundScreen()),
    GetPage(name: createNewBackgroundScreen, page: () => const CreateNewBackgroundScreen()),


    GetPage(
      name: AppRoute.alarmTrigger,
      page: () {
        final alarmIdParam = Get.parameters['alarmId'];
        if (alarmIdParam != null) {
          final int alarmId = int.tryParse(alarmIdParam) ?? -1;
          // Use a FutureBuilder to fetch the alarm from the local DB.
          return FutureBuilder<Alarm?>(
            future: DBHelperAlarm().getAlarm(alarmId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return AlarmTriggerScreen(alarm: snapshot.data!);
              } else if (snapshot.hasError) {
                return const Scaffold(
                  body: Center(child: Text("Error loading alarm data")),
                );
              }
              // While loading, show a progress indicator.
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        } else {
          // Fallback: use a dummy alarm if no alarmId is passed.
          Alarm dummyAlarm = Alarm(
            hour: 7,
            minute: 0,
            isAm: true,
            label: "Morning Alarm",
            musicPath: 'assets/audio/iphone_alarm.mp3',
            backgroundImage: '',
            isVibrationEnabled: true,
            repeatDays: [],
            backgroundTitle: 'Hello',
          );
          return AlarmTriggerScreen(alarm: dummyAlarm);
        }
      },
    ),
  ];
}