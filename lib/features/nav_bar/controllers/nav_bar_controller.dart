import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/features/alarm/alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_alarm/presentation/screens/add_alarm_screen.dart';
import '../../settings/presentation/screens/settings_screen.dart';

class CreatorNavBarController extends GetxController {

  var selectedIndex = 0.obs;


  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Define active and inactive icon paths
  final List<Map<String, String>> iconPaths = [
    {
      'active': IconPath.alarmActive,
      'inactive': IconPath.alarmInactive,
    },
    {
      'active': IconPath.add,
      'inactive': IconPath.add,
    },
    {
      'active': IconPath.settingsActive,
      'inactive': IconPath.settingsInactive,
    },
  ];

  // Define the screens for each tab
  final List<Widget> screens = [
    const AlarmScreen(),
    const AddAlarmScreen(),
    const SettingsScreen(),
  ];
}






// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
//
// class CreatorNavBarController extends GetxController {
//   final _selectedIndex = 0.obs;
//
//   int get currentIndex => _selectedIndex.value;
//
//   void changeIndex(int index) {
//     _selectedIndex.value = index;
//   }
//
//   final List<Widget> screens = const [
//     CreatorHomeScreen(),
//     EventScreen(),
//     SettingsScreen(),
//     CreatorProfile()
//   ];
//
//   final List<String> labels = const ['Home', 'Events', 'Settings', 'Profile'];
//
//   final List<Image> activeIcons = [
//     Image.asset(IconPath.homeActive, height: 26.h, width: 26.w, fit: BoxFit.cover),
//     Image.asset(IconPath.ticketActive, height: 26.h, width: 26.w, fit: BoxFit.cover),
//     Image.asset(IconPath.settingActive, height: 26.h, width: 26.w, fit: BoxFit.cover),
//     Image.asset(IconPath.profileActive, height: 26.h, width: 26.w, fit: BoxFit.cover),
//   ];
//
//   final List<Image> inActiveIcons = [
//     Image.asset(IconPath.home, height: 26.h, width: 26.w, fit: BoxFit.cover),
//     Image.asset(IconPath.ticket, height: 26.h, width: 26.w, fit: BoxFit.cover),
//     Image.asset(IconPath.setting, height: 26.h, width: 26.w, fit: BoxFit.cover),
//     Image.asset(IconPath.profile, height: 26.h, width: 26.w, fit: BoxFit.cover),
//   ];
// }
