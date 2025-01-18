import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/app_sizes.dart';
import '../controller/create_new_back_ground_alarm_controller.dart';

class WaveFormSection extends StatelessWidget {
  const WaveFormSection({
    super.key,
    required this.controller,
  });

  final CreateAlarmController controller;

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
                    controller.togglePlayback(filePath: controller.recordingPath.value);
                  },
                  icon: Icon(
                    controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
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
