import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_controller.dart';

class AudioTest extends StatelessWidget {
  const AudioTest({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioController controller = Get.put(AudioController());

    return Scaffold(
      floatingActionButton: Obx(
            () => FloatingActionButton(
          onPressed: controller.toggleRecording,
          child: Icon(controller.isRecording.value ? Icons.stop : Icons.mic),
        ),
      ),
      appBar: AppBar(
        title: const Text("Audio Test"),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.pickImage(); // Trigger Image Picker
            },
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () async {
              await controller.pickMusic(); // Trigger Music Picker
            },
            icon: const Icon(Icons.music_note),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              controller.labelText.value = value;
            },
            decoration: const InputDecoration(
              labelText: 'Enter label text',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.saveData(); // Save the data and go back
            },
            child: const Text("Save and Go Back"),
          )

        ],
      ),
    );
  }
}
