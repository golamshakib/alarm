import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/change_back_ground_controller.dart';
import '../../controller/preview_screen_controller.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({
    super.key,
    required this.title,
    required this.image,
    required this.musicUrl,
  });

  final String title;
  final String image;
  final String musicUrl;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreviewScreenController()); // Initialize controller

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppbarWithLogo(
                  text: "Preview",
                  showBackIcon: true,
                  iconPath: IconPath.editSquare,
                  onIconTap: () {},
                ),
                SizedBox(height: getHeight(24)),
                Row(
                  children: [
                    CustomText(text: title),
                    const CustomText(text: ':'),
                    SizedBox(width: getWidth(8)),
                    Obx(() {
                      return GestureDetector(
                        onTap: controller.togglePlay,
                        child: Icon(
                          controller.isPlaying.value
                              ? Icons.play_circle_fill_rounded
                              : Icons.play_circle_outline_rounded,
                          color: Colors.orange,
                          size: 25,
                        ),
                      );
                    }),
                    SizedBox(width: getWidth(10)),
                    Obx(() {
                      return controller.showExtraImage.value
                          ? Image.asset(
                        musicUrl,
                        height: getHeight(25),
                        width: getWidth(75),
                      )
                          : const SizedBox();
                    }),
                  ],
                ),
                SizedBox(height: getHeight(16)),

                // Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: getHeight(20)),

                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: getHeight(12)),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Set as alarm background',
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
