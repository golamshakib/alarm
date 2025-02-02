

import 'package:get/get.dart';

import '../../features/add_alarm/controller/change_back_ground_screen_controller.dart';
import '../../features/add_alarm/controller/create_new_back_ground_screen_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LogInController>(
    //       () => LogInController(),
    //   fenix: true,
    // );

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