import 'dart:io';

import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_sizes.dart';
import 'audio_controller.dart';
import 'audio_test.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class PreviousScreen extends StatelessWidget {
  final AudioController controller = Get.put(AudioController());

  PreviousScreen({super.key});

  Map<String, dynamic>? currentItem;

  Future<void> navigateToAudioTest() async {
    final result = await Get.to(() => const AudioTest());
    if (result != null) {
      controller.addItem(result);
      currentItem = result; // Store the current item to later use when play is pressed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Screen"),
      ),
      body: Obx(
            () => controller.items.isEmpty
            ? const Center(child: Text("No data available"))
            : ListView.separated(
          itemCount: controller.items.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return GestureDetector(
              onTap: () {
                // Get.to(() => PreviewScreen(
                //   title: item['labelText'] ?? '',
                //   image: item['imagePath'] ?? '',
                //   musicUrl: item['musicUrl'] ?? '',
                // ));
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
                          GestureDetector(
                            onTap: () {
                              controller.playMusic(index);
                            },
                            child: Obx(() {
                              return Row(
                                children: [
                                  Icon(
                                    controller.isPlaying.value &&
                                        controller.playingIndex.value == index
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.orange,
                                    size: 25,
                                  ),
                                  if (controller.isPlaying.value &&
                                      controller.playingIndex.value == index) ...[
                                    SizedBox(width: getWidth(10)),
                                    SizedBox(
                                      height: 50,
                                      child: AudioFileWaveforms(
                                        playerController: controller.waveformControllers[index],
                                        size: Size(getWidth(300), getHeight(80)),
                                        enableSeekGesture: true,
                                        waveformType: WaveformType.long,
                                        playerWaveStyle: const PlayerWaveStyle(
                                          fixedWaveColor: Colors.grey,
                                          liveWaveColor: Color(0xffFFA845),
                                          waveThickness: 2.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }),
                          ),
                          SizedBox(height: getHeight(16)),
                          CustomText(
                            text: item['labelText'] ?? '',
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
      floatingActionButton: FloatingActionButton(
    onPressed: () async {
    // Stop music before navigating
    controller.stopMusic();
    await navigateToAudioTest();
    },
    child: const Icon(Icons.add),
    ));
  }
}
