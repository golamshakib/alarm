import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/image_path.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.put(SplashController());
    return Scaffold(
      backgroundColor: const Color(0xfffff5e1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(66)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePath.appLogo, height: getHeight(44), width: getWidth(243),),
            ],
          ),
        ),
      ),
    );
  }
}
