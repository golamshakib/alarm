import 'dart:io';

import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/features/add_alarm/controller/local_storage_preview_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/add_alarm_controller.dart';

class LocalStoragePreviewScreen extends StatelessWidget {
  const LocalStoragePreviewScreen({
    super.key,
    required this.title,
    required this.image,
    required this.musicPath,
    required this.recordingPath,
  });

  final String title;
  final String image;
  final String musicPath;
  final String recordingPath;

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(LocalStoragePreviewScreenController()); // Initialize controller
    // Determine which path to use for playback
    final audioPlay = musicPath.isNotEmpty ? musicPath : recordingPath;
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
                    Flexible(
                      child: CustomText(
                        text: title,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const CustomText(text: ' :'),
                    SizedBox(width: getWidth(8)),
                    GestureDetector(
                      onTap: () => controller.togglePlay(audioPlay),
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
                SizedBox(height: getHeight(16)),

                // Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: image.isNotEmpty && File(image).existsSync()
                      ? Image.file(
                          File(image), // Display local image
                          width: double.infinity,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          ImagePath.dog, // Fallback asset image
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                ),
                SizedBox(height: getHeight(20)),

                GestureDetector(
                  onTap: () {
                    // Set the background image and title in AddAlarmController
                    final addAlarmController = Get.find<AddAlarmController>();
                    addAlarmController.selectedBackground.value = title;
                    addAlarmController.selectedBackgroundImage.value = image;
                    Get.snackbar(
                        "Success", "Successfully Change the background");
                    Get.back();
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
