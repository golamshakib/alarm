import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

import '../../core/utils/constants/app_colors.dart';
import '../../core/utils/constants/app_sizes.dart';

class AudioController extends GetxController {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final PlayerController playerController = PlayerController();

  Rx<String?> recordingPath = Rx<String?>(null);
  RxBool isRecording = false.obs;

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        recordingPath.value = filePath;
        playerController.preparePlayer(path: filePath);
        isRecording.value = false;
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
        final String filePath = p.join(appDocumentsDir.path, 'recording.wav');
        await audioRecorder.start(const RecordConfig(), path: filePath);
        recordingPath.value = null;
        isRecording.value = true;
      }
    }
  }

  Future<void> togglePlayback() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      playerController.pausePlayer();
    } else {
      if (recordingPath.value != null) {
        await audioPlayer.setFilePath(recordingPath.value!);
        await audioPlayer.play();
        playerController.startPlayer();
      }
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    playerController.dispose();
    super.onClose();
  }
}



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
      body: Obx(() => _buildUI(controller)),
    );
  }

  Widget _buildUI(AudioController controller) {
    return SizedBox(
      width: AppSizes.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (controller.recordingPath.value != null)
            Column(
              children: [
                AudioFileWaveforms(
                  playerController: controller.playerController,
                  size: Size(AppSizes.width * 0.9, 100),
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.grey,
                    liveWaveColor: AppColors.yellow,
                    waveThickness: 2.0,
                  ),
                ),
                IconButton(
                  onPressed: controller.togglePlayback,
                  icon: Icon(
                    controller.audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          if (controller.recordingPath.value == null)
            const Text(
              'No recording found. Record something!',
              style: TextStyle(color: Colors.black),
            ),
        ],
      ),
    );
  }
}
