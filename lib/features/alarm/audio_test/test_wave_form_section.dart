import 'dart:io';

import 'package:alarm/features/alarm/audio_test/audio_controller.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/app_sizes.dart';

class TestWaveFormSection extends StatelessWidget {
  const TestWaveFormSection({
    super.key,
    required this.controller,
  });

  final AudioController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          if (controller.recordingPath.value != null &&
              File(controller.recordingPath.value!).existsSync())
            Column(
              children: [
                AudioFileWaveforms(
                  playerController: controller.playerController,
                  size: Size(getWidth(300), getHeight(80)),
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.grey,
                    liveWaveColor: Color(0xffFFA845),
                    waveThickness: 2.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.toggleRecordingPlayback( filePath: controller.recordingPath.value);
                  },
                  icon: Icon(
                    controller.isRecordingPlaying.value ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xffFFA845),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
