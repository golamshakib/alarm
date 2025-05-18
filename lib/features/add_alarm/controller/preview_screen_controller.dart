import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PreviewScreenController extends GetxController {
  final RxBool isPlaying = false.obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  Future<void> togglePlay(String audioPath) async {
    try {
      if (audioPath.isEmpty) {
        Get.snackbar("Error", "Audio file path is empty.", duration: const Duration(seconds: 2));
        return;
      }

      if (isPlaying.value) {
        await audioPlayer.pause();
      } else {
        if (audioPath.startsWith("http") || audioPath.startsWith("https")) {
          await audioPlayer.setUrl(audioPath);
        } else {
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
