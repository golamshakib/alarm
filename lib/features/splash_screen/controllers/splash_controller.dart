import 'package:alarm/features/splash_screen/presentation/screens/onboarding1.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void navigateToOnboardingScreen() {
    Future.delayed(
      const Duration(milliseconds: 1500),
          () {
        Get.offAll(
              () => const OnBoarding1Screen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    navigateToOnboardingScreen();
  }
}
