import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void navigateToHomeScreen() {
    Future.delayed(
      const Duration(milliseconds: 1500),
          () {
        // Get.offAll(
        //       () => const OnboardingScreenOne(),
        //   transition: Transition.fade,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeOut,
        // );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    navigateToHomeScreen();
  }
}
