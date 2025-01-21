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
        Get.snackbar("Error", "Audio file does not exist.");
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
      Get.snackbar("Playback Error", "Could not play the audio file: $e");
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // Dispose of the audio player
    super.onClose();
  }
}
