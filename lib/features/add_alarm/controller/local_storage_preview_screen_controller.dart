import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LocalStoragePreviewScreenController extends GetxController {
  final RxBool isPlaying = false.obs; // Tracks playback state
  final AudioPlayer audioPlayer = AudioPlayer(); // AudioPlayer instance

  @override
  void onInit() {
    super.onInit();
    // Sync `isPlaying` with the AudioPlayer's playing state
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing; // Updates based on actual playback state
    });
  }

  void togglePlay(String audioPath) async {
    try {
      if (!File(audioPath).existsSync()) {
        Get.snackbar("Error", "Audio file does not exist.", duration: const Duration(seconds: 2));
        return;
      }

      if (isPlaying.value) {
        // Pause the playback
        await audioPlayer.pause();
      } else {
        // Set the file path (if not already set) and play the audio
        if (audioPlayer.processingState == ProcessingState.idle) {
          await audioPlayer.setFilePath(audioPath);
        }
        await audioPlayer.play();
      }
    } catch (e) {
      // Get.snackbar("Playback Error", "Could not play the audio file: $e", duration: const Duration(seconds: 2));
    }
  }

  // Stop music playback
  Future<void> stopMusic() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.stop(); // Stop the audio playback
        isPlaying.value = false; // Reset the playing state
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to stop the audio: $e", duration: const Duration(seconds: 2));
    }
  }

  @override
  void onClose() {
    stopMusic(); // Ensure music is stopped before disposing
    audioPlayer.dispose(); // Dispose of the audio player
    super.onClose();
  }
}
