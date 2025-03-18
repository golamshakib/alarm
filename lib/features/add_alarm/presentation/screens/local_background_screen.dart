import 'dart:io';

import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/features/add_alarm/presentation/screens/local_storage_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../core/db_helpers/db_helper_local_background.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/create_new_back_ground_screen_controller.dart';
import 'change_back_ground_screen.dart';

class LocalBackgroundScreen extends StatelessWidget {
  const LocalBackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateNewBackgroundController createAlarmController = Get.put(CreateNewBackgroundController());
    final DBHelperMusic dbHelper = DBHelperMusic();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbarWithLogo(
                text: "Change background",
                showBackIcon: true,
                  onBackTap: () async {
                    createAlarmController.stopMusic();
                    Get.back();
                  },
                  iconPath: IconPath.addIconActive,
                  onIconTap: () async {
                    createAlarmController.stopMusic();
                    final result =
                    await Get.toNamed(AppRoute.createNewAlarmScreen);
                    if (result != null && createAlarmController.items.isEmpty) {
                      createAlarmController.addItem(result);
                    }
                  }
              ),
              SizedBox(height: getHeight(24)),
              Expanded(
                child: Obx(
                      () => createAlarmController.items.isEmpty
                      ? const Center(
                      child: CustomText(text: 'No Background available'))
                      : ListView.separated(
                    itemCount: createAlarmController.items.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: getHeight(12)),
                        itemBuilder: (context, index) {
                          final item = createAlarmController.items[index];

                          return Dismissible(
                            key: ValueKey(item['id']), // Use ID to prevent unnecessary rebuilding
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) async {
                              final confirmed = await showDeleteConfirmationPopup(context);

                              if (confirmed) {
                                final id = item['id'];
                                // Ensure the ID is not null before proceeding
                                if (id != null) {
                                  await dbHelper.deleteBackground(id); // Delete the background from DB
                                  createAlarmController.items.removeAt(index); // Remove the item from list immediately
                                  Get.snackbar("Success", "Background deleted successfully!", duration: const Duration(seconds: 2));
                                  Get.off(const LocalBackgroundScreen());
                                } else {
                                  // If ID is null, show an error or handle it gracefully
                                  Get.snackbar("Error", "Invalid background ID. Could not delete the item.", duration: const Duration(seconds: 2));
                                }
                              } else {
                                // If the dismissal is canceled, we don't need to remove the item
                                Get.off(const ChangeBackGroundScreen());
                              }
                            },

                            child: GestureDetector(
                              onTap: () {
                                createAlarmController.stopMusic();
                                Get.to(() => LocalStoragePreviewScreen(
                                  id: item['id'],
                                  title: item['title'] ?? '',
                                  imagePath: item['imagePath'] ?? '',
                                  musicPath: item['musicPath'] ?? '',
                                  recordingPath: item['recordingPath'] ?? '',
                                ));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF7F7F7),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          /// ✅ **Isolate the Play Button**
                                          PlayButton(index: index), // Use a separate widget

                                          SizedBox(height: getHeight(16)),
                                          CustomText(
                                            text: item['title'] ?? '',
                                            fontSize: getWidth(14),
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff333333),
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(50),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: item['imagePath'] != null
                                              ? FileImage(File(item['imagePath']!))
                                              : const AssetImage(ImagePath.cat),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> showDeleteConfirmationPopup(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            text: "Delete Background",
            fontSize: getWidth(18),
          ),
          content: CustomText(
            text: "Are you sure you want to delete this background?",
            color: AppColors.textPrimary.withOpacity(0.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              // Cancel action
              child: CustomText(
                  text: "Cancel",
                  color: AppColors.textPrimary.withOpacity(0.5)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              // Confirm action
              child: const CustomText(
                text: "Delete",
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    ) ??
        false; // Return false if dialog is dismissed without action
  }
}
class PlayButton extends StatelessWidget {
  final int index;

  const PlayButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final CreateNewBackgroundController createAlarmController = Get.find<CreateNewBackgroundController>();

    return GestureDetector(
      onTap: () {
        createAlarmController.playMusic(index);
      },
      child: Obx(() {
        return Icon(
          createAlarmController.isPlaying.value &&
              createAlarmController.playingIndex.value == index
              ? Icons.play_circle_fill_rounded
              : Icons.play_circle_outline_rounded,
          color: Colors.orange,
          size: 25,
        );
      }),
    );
  }
}

