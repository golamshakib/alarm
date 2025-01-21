import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LocalStoragePreviewScreenController extends GetxController {
  final RxBool isPlaying = false.obs; // Tracks playback state
  final AudioPlayer audioPlayer = AudioPlayer(); // AudioPlayer instance

  void togglePlay(String audioPath) async {
    try {
      if (!File(audioPath).existsSync()) {
        Get.snackbar("Error", "Audio file does not exist.");
        return;
      }

      if (isPlaying.value) {
        // Pause the playback
        await audioPlayer.pause();
      } else {
        // Set the file path and play the audio
        await audioPlayer.setFilePath(audioPath);
        await audioPlayer.play();
      }

      // Toggle the playing state
      isPlaying.toggle();
    } catch (e) {
      Get.snackbar("Playback Error", "Could not play the audio file: $e");
    }
  }

  Future<void> stopPlayback() async {
    try {
      await audioPlayer.stop();
      isPlaying.value = false;
    } catch (e) {
      Get.snackbar("Error", "Unable to stop playback: $e");
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // Dispose of the audio player
    super.onClose();
  }
}
