import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:audio_waveforms/audio_waveforms.dart'; // Import for waveform handling
import 'package:get/get.dart';

class ChangeBackgroundController extends GetxController {
  // Database Data List
  var items = [
    {'title': 'Cute Dog in bed', 'image': ImagePath.dog3, 'musicUrl': ImagePath.extraImage},
    {'title': 'Cute Cat under blanket', 'image': ImagePath.dog2, 'musicUrl': ImagePath.extraImage},
    {'title': 'Cute Bird over sink', 'image': ImagePath.dog3, 'musicUrl': ImagePath.extraImage},
    {'title': 'Cute Dog in bed', 'image': ImagePath.dog3, 'musicUrl': ImagePath.extraImage},
    {'title': 'Cute Dog in bed', 'image': ImagePath.dog3, 'musicUrl': ImagePath.extraImage},
    {'title': 'Cute Cat under blanket', 'image': ImagePath.dog3, 'musicUrl': ImagePath.extraImage},
  ].obs;

  // To track if audio is playing for each item
  var isPlaying = <bool>[].obs;

  // List to hold PlayerController instances for waveform display
  var playerControllers = <PlayerController>[];

  @override
  void onInit() {
    super.onInit();
    isPlaying.value = List.generate(items.length, (_) => false);

    // Initialize player controllers for each item
    for (int i = 0; i < items.length; i++) {
      playerControllers.add(PlayerController());
    }
  }

  // Method to toggle playback of audio and manage waveform
  void togglePlay(int index) {
    // Set all items to false, except the current index
    for (int i = 0; i < isPlaying.length; i++) {
      isPlaying[i] = (i == index) ? !isPlaying[i] : false;
    }
    isPlaying.refresh(); // Notify observers to rebuild the UI

    // Play or pause the audio based on current state
    if (isPlaying[index]) {
      // Start playing the audio and the waveform
      playerControllers[index].startPlayer();
    } else {
      // Pause the audio and waveform
      playerControllers[index].pausePlayer();
    }
  }

  @override
  void onClose() {
    // Dispose all player controllers when the controller is disposed
    for (var playerController in playerControllers) {
      playerController.dispose();
    }
    super.onClose();
  }
}
