

import 'package:get/get.dart';

import '../../features/add_alarm/controller/add_alarm_controller.dart';
import '../../features/add_alarm/controller/change_back_ground_screen_controller.dart';
import '../../features/add_alarm/controller/create_new_back_ground_screen_controller.dart';
import '../../features/settings/controller/settings_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());

    Get.lazyPut<AddAlarmController>(() => AddAlarmController());

    Get.lazyPut<ChangeBackgroundScreenController>(
          () => ChangeBackgroundScreenController(),
      fenix: true,
    );
    Get.lazyPut<CreateNewBackgroundController>(
          () => CreateNewBackgroundController(),
      fenix: true,
    );

  }
}