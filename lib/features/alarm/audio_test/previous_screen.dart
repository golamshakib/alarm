import 'package:alarm/features/alarm/audio_test/preview_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_controller.dart';
import 'audio_test_show.dart';

class PreviousScreen extends StatelessWidget {
  const PreviousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = Get.arguments; // Retrieve the data passed back
    final String labelText = data?['labelText'] ?? '';
    final String? imagePath = data?['imagePath'];
    final String? musicUrl = data?['musicUrl'];

    final AudioController controller = Get.put(AudioController());

    // Play music if musicUrl is provided
    if (musicUrl != null && musicUrl.isNotEmpty) {
      controller.audioPlayer.setFilePath(musicUrl);
      controller.audioPlayer.play();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AudioTest());
        },
        child: const Icon(Icons.mic),
      ),
      appBar: AppBar(
        title: const Text("Previous Screen"),
      ),
      body: Expanded(
        child: Obx(() {
          return ListView.separated(
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.items[index];

              return GestureDetector(
                onTap: () {
                  Get.to(() => PreviewTestScreen(
                    title: item['labelText']!,
                    image: item['imagePath']!,
                    musicUrl: item['musicUrl'] ?? '',
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
                            GestureDetector(
                              onTap: () {
                                controller.togglePlay(index);
                              },
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Icon(
                                      controller.isPlaying.value
                                          ? Icons.play_circle_fill_rounded
                                          : Icons.play_circle_outline_rounded,
                                      color: Colors.orange,
                                      size: 25,
                                    ),
                                    if (controller.isPlaying.value) ...[
                                      SizedBox(width: 8),
                                      Image.asset(
                                        item['musicUrl'] ?? '',
                                        height: 25,
                                        width: 75,
                                      ),
                                    ],
                                  ],
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item['labelText']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xff333333),
                                overflow: TextOverflow.ellipsis,
                              ),
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
                            image: AssetImage(item['imagePath']!),
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
    );
  }
}
