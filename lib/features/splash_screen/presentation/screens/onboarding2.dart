import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';

class OnBoarding2Screen extends StatelessWidget {
  const OnBoarding2Screen({super.key});

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
                  ImagePath.onboarding2,
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
                          text: 'Choose from a wide variety of ',
                          style: GoogleFonts.poppins(
                            fontSize: getWidth(32),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: 'animal',
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(32),
                                color: AppColors.textYellow,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' images and ',
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(32),
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'sounds',
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(32),
                                color: AppColors.textYellow,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: getHeight(48)),

                    // Next Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.onboarding3);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            // right: getWidth(16),
                            bottom: getHeight(16),
                          ),
                          child: Image.asset(
                            IconPath.onboardingNext2,
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
