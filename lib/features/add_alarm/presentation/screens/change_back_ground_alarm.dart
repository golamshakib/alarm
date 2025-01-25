import 'dart:io';

import 'package:alarm/features/add_alarm/presentation/screens/local_storage_preview_screen.dart';
import 'package:alarm/features/add_alarm/presentation/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/change_back_ground_controller.dart';
import '../../controller/create_new_back_ground_alarm_controller.dart';

class ChangeBackGroundAlarm extends StatelessWidget {
  const ChangeBackGroundAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeBackgroundController controller =
        Get.put(ChangeBackgroundController());
    final CreateAlarmController createAlarmController =
        Get.put(CreateAlarmController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbarWithLogo(
                text: "Change background",
                showBackIcon: true,
                iconPath: IconPath.addIconActive,
                onIconTap: () async {
                  createAlarmController.stopMusic();
                  final result =
                      await Get.toNamed(AppRoute.createNewAlarmScreen);
                  if (result != null && createAlarmController.items.isEmpty) {
                    createAlarmController.addItem(
                        result); // Add the returned result to the items list
                  }
                },
              ),
              SizedBox(height: getHeight(24)),

              // First ListView for `items`
              Expanded(
                child: Obx(() {
                  return ListView.separated(
                    itemCount: controller.items.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: getHeight(12)),
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PreviewScreen(
                                title: item['title'] ?? '',
                                imagePath: item['imagePath'] ?? '',
                                musicPath: item['musicPath'] ?? '',
                              ));
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xffF7F7F7),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.togglePlay(index);
                                      },
                                      child: Obx(() {
                                        return Row(
                                          children: [
                                            Icon(
                                              controller.isPlaying[index]
                                                  ? Icons
                                                      .play_circle_fill_rounded
                                                  : Icons
                                                      .play_circle_outline_rounded,
                                              color: Colors.orange,
                                              size: 25,
                                            ),
                                            // if (controller
                                            //     .isPlaying[index]) ...[
                                            //   SizedBox(width: getWidth(8)),
                                            //   Image.asset(
                                            //     item['musicPath'] ?? '',
                                            //     height: getHeight(25),
                                            //     width: getWidth(75),
                                            //   ),
                                            // ],
                                          ],
                                        );
                                      }),
                                    ),
                                    SizedBox(height: getHeight(16)),
                                    CustomText(
                                      text: item['title']!,
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
                                        : const AssetImage(ImagePath.dog),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: getHeight(24)),
              CustomText(text: 'Local Background', fontSize: getWidth(18)),
              SizedBox(height: getHeight(24)),
              Expanded(
                child: Obx(
                  () => createAlarmController.items.isEmpty
                      ? const Center(
                          child: CustomText(text: 'No Background available'))
                      : ListView.separated(
                          itemCount: createAlarmController.items.length,
                          separatorBuilder: (_, __) => SizedBox(
                            height: getHeight(12),
                          ),
                          itemBuilder: (context, index) {
                            final item = createAlarmController.items[index];
                            return GestureDetector(
                              onTap: () {
                                createAlarmController.stopMusic();
                                Get.to(
                                  () => LocalStoragePreviewScreen(
                                    id: item['id'],
                                    title: item['title'] ?? '',
                                    imagePath: item['imagePath'] ?? '',
                                    musicPath: item['musicPath'] ?? '',
                                   recordingPath: item['recordingPath']?? '',
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF7F7F7),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              createAlarmController
                                                  .playMusic(index);
                                            },
                                            child: Obx(() {
                                              return Row(
                                                children: [
                                                  Icon(
                                                    createAlarmController
                                                                .isPlaying
                                                                .value &&
                                                            createAlarmController
                                                                    .playingIndex
                                                                    .value ==
                                                                index
                                                        ? Icons
                                                            .play_circle_fill_rounded
                                                        : Icons
                                                            .play_circle_outline_rounded,
                                                    color: Colors.orange,
                                                    size: 25,
                                                  ),
                                                  // if (createAlarmController.isPlaying.value &&
                                                  //     createAlarmController.playingIndex.value == index) ...[
                                                  //   SizedBox(
                                                  //     height: getHeight(30),
                                                  //     child: AudioFileWaveforms(
                                                  //       playerController: createAlarmController.waveformControllers[index],
                                                  //       size: Size(getWidth(300), getHeight(80)),
                                                  //       enableSeekGesture: true,
                                                  //       waveformType: WaveformType.long,
                                                  //       playerWaveStyle: const PlayerWaveStyle(
                                                  //         fixedWaveColor: Colors.grey,
                                                  //         liveWaveColor: Color(0xffFFA845),
                                                  //         waveThickness: 2.0,
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ],
                                                ],
                                              );
                                            }),
                                          ),
                                          SizedBox(height: getHeight(16)),
                                          CustomText(
                                            text: item['title'] ?? '',
                                            fontSize: getWidth(14),
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff333333),
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                          // Add spacing
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
                                              : const AssetImage(ImagePath.dog),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
}
