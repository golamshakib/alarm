import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LocalStoragePreviewScreenController extends GetxController {
  final RxBool isPlaying = false.obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  void togglePlay(String audioPath) async {
    try {
      if (!File(audioPath).existsSync()) {
        Get.snackbar("Error", "Audio file does not exist.", duration: const Duration(seconds: 2));
        return;
      }

      if (isPlaying.value) {
        await audioPlayer.pause();
      } else {
        if (audioPlayer.processingState == ProcessingState.idle) {
          await audioPlayer.setFilePath(audioPath);
        }
        await audioPlayer.play();
      }
    } catch (e) {
      // Get.snackbar("Playback Error", "Could not play the audio file: $e", duration: const Duration(seconds: 2));
    }
  }

  Future<void> stopMusic() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.stop();
        isPlaying.value = false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to stop the audio: $e", duration: const Duration(seconds: 2));
    }
  }

  @override
  void onClose() {
    stopMusic();
    audioPlayer.dispose();
    super.onClose();
  }
}
