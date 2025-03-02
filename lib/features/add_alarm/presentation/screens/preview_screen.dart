import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/add_alarm_controller.dart';
import '../../controller/preview_screen_controller.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.musicPath,
  });

  final String title;
  final String imagePath;
  final String musicPath;

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(PreviewScreenController()); // Initialize controller

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getWidth(16), vertical: getHeight(16)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevents infinite height error
              children: [
                CustomAppbarWithLogo(
                  text: "Preview",
                  showBackIcon: true,
                  onBackTap: () async {
                    controller.stopMusic();
                    Get.back();
                    },
                  iconPath: IconPath.editSquare,
                  onIconTap: () async {
                    controller.stopMusic();
                  },
                ),
                SizedBox(height: getHeight(24)),

                // Wrap Flexible in a SizedBox
                Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        text: title,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const CustomText(text: ' :'),
                    SizedBox(width: getWidth(8)),
                    GestureDetector(
                      onTap: () => controller.togglePlay(musicPath),
                      child: Obx(
                        () => Icon(
                          controller.isPlaying.value
                              ? Icons.play_circle_fill_rounded
                              : Icons.play_circle_outline_rounded,
                          color: Colors.orange,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getHeight(24)),

                // Image Preview - Ensure it has proper constraints
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imagePath,
                      width: double.infinity,
                      height: getHeight(200), // Ensure finite height
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImagePath.cat,
                      fit: BoxFit.contain,
                    );
                  }),
                ),
                SizedBox(height: getHeight(20)),

                GestureDetector(
                  onTap: () {
                    controller.stopMusic();
                    final addAlarmController = Get.find<AddAlarmController>();
                    addAlarmController.selectedBackground.value = title;
                    addAlarmController.selectedBackgroundImage.value =
                        imagePath;
                    addAlarmController.selectedMusicPath.value =
                        musicPath; // Pass music path
                    Get.toNamed(AppRoute.navBarScreen, arguments: {
                      'title': title,
                      'imagePath': imagePath,
                      'musicPath': musicPath,
                    });
                    Get.snackbar("Success", "Background set successfully!",
                        duration: const Duration(seconds: 2));
                  },
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
