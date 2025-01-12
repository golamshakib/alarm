import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/app_texts.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/image_path.dart';

class OnBoarding1Screen extends StatelessWidget {
  const OnBoarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff5e1),
      body: SafeArea(
        child: Stack(
          children: [
            // Top Image
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                ImagePath.onboarding1,
                height: getHeight(550),
              ),
            ),

            // Title and Subtitle Texts
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getHeight(550)),
                  SizedBox(height: getHeight(36)),

                  // Title Text
                  CustomText(
                    text: AppText.onboarding1TitleText,
                    fontSize: getWidth(32),
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: getHeight(8)),

                  // Subtitle Text
                  CustomText(
                    text: AppText.onboarding1SubtitleText,
                    fontSize: getWidth(18),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),

            // "Next" Button
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: getWidth(16),
                  bottom: getHeight(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoute.onboarding2);
                  },
                  child: Image.asset(
                    IconPath.onboardingNext1,
                    height: getHeight(65),
                    width: getWidth(65),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
