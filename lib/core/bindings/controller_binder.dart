

import 'package:get/get.dart';

import '../../features/add_alarm/controller/change_back_ground_controller.dart';
import '../../features/add_alarm/controller/create_new_back_ground_alarm_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LogInController>(
    //       () => LogInController(),
    //   fenix: true,
    // );

    Get.lazyPut<ChangeBackgroundController>(
          () => ChangeBackgroundController(),
      fenix: true,
    );
    Get.lazyPut<CreateAlarmController>(
          () => CreateAlarmController(),
      fenix: true,
    );

  }
}