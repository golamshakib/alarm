import 'package:alarm/features/splash_screen/presentation/screens/onboarding1.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../nav_bar/presentation/screens/nav_bar.dart';

class SplashController extends GetxController {
  void navigateToOnboardingScreen() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true; // Default: true
    debugPrint("Splash Screen: isFirstTime = $isFirstTime"); // Debug log
    Future.delayed(
      const Duration(milliseconds: 1500),
          () {
            if (isFirstTime) {
              // First time user → Show Onboarding
              Get.offAll(() => const OnBoarding1Screen(),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            } else {
              // Returning user → Show Bottom Nav Bar
              Get.offAll(() => const CreatorNavBar(),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            }
          },
    );
  }

  @override
  void onInit() {
    super.onInit();
    navigateToOnboardingScreen();
  }
}
