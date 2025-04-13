import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../nav_bar/presentation/screens/nav_bar.dart';

class OnBoarding3Screen extends StatelessWidget {
  const OnBoarding3Screen({super.key});

  void completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isFirstTime', false); // Mark onboarding as completed

    debugPrint("Onboarding Completed. isFirstTime set to: ${prefs.getBool('isFirstTime')}");

    // Navigate to the main app
    Get.offAll(() => const CreatorNavBar(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff5e1),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: getHeight(16)),
                child: Image.asset(
                  ImagePath.onboarding3,
                  height: getHeight(750),
                ),
              ),
            ),

            // Text and Button Section
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overlapping RichText
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getWidth(8)),
                      child: RichText(
                        text: TextSpan(
                          text: '',
                          style: GoogleFonts.poppins(
                            fontSize: getWidth(32),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: 'Upload ',
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(32),
                                color: AppColors.textYellow,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'and save your favorites.',
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(32),
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: getHeight(48)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          completeOnboarding();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            // right: getWidth(16),
                            bottom: getHeight(16),),
                          child: Image.asset(
                            IconPath.onboardingNext3,
                            height: getHeight(65),
                            width: getWidth(65),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
