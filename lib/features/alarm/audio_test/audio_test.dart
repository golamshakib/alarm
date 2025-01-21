import 'package:alarm/features/alarm/audio_test/test_wave_form_section.dart';
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
          onPressed: controller.isMicDisabled.value
              ? null
              : controller.toggleRecording,
          child: Icon(
            controller.isRecording.value ? Icons.stop : Icons.mic,
            color: controller.isMicDisabled.value
                ? Colors.grey // Disabled color
                : Colors.orange, // Enabled color
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Audio Test"),
        actions: [
          // Disable music button if recording is in progress
          Obx(
            () => IconButton(
              onPressed: controller.isRecording.value
                  ? null // Disable if recording is happening or music is already selected
                  : () async {
                      await controller.pickMusic(); // Trigger Music Picker
                    },
              icon: const Icon(Icons.music_note),
              color: controller.isRecording.value || controller.isMusicDisabled.value
                  ? Colors.grey // Disabled color
                  : Colors.orange, // Enabled color
            ),
          ),
          // Disable image picker if recording or music is selected
          IconButton(
            onPressed: () async {
              await controller.pickImage();
            },
            icon: const Icon(Icons.image),
            color: Colors.orange,
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

          // This section will display waveform and controls after recording is stopped
          Obx(() {
            if (controller.isRecording.value == false &&
                controller.recordingPath.value != null) {
              return Column(
                children: [
                  TestWaveFormSection(controller: controller),
                  // Display waveform section
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return Container(); // Show nothing if not recording or if there is no path
            }
          }),
          ElevatedButton(
            onPressed: () {
              controller.saveData(); // Save the data and go back
              controller.resetFields(); // Reset all fields after saving
            },
            child: const Text("Save and Go Back"),
          ),
        ],
      ),
    );
  }
}
