import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_alarm/presentation/screens/add_alarm_screen.dart';
import '../../alarm/presentation/screen/alarm_screen.dart';
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
