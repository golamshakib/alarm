
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/models/response_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/api_constants.dart';
import 'create_new_back_ground_screen_controller.dart';


class ChangeBackgroundScreenController extends GetxController {
  final CreateNewBackgroundController createAlarmController = Get.find<CreateNewBackgroundController>();
  final NetworkCaller networkCaller = NetworkCaller();
  var items = <Map<String, dynamic>>[].obs;
  final player = AudioPlayer();
  int? currentlyPlayingIndex;
  var isPlaying = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBackgroundsFromNetwork();
    isPlaying.value = List.generate(items.length, (_) => false);
  }


  Future<void> fetchBackgroundsFromNetwork() async {
    const String endpoint = AppUrls.getAllBackgrounds;
    try {
      final ResponseData response = await networkCaller.getRequest(endpoint);
      if (response.isSuccess && response.responseData != null) {
        // Ensure responseData is a Map and extract the "data" field
        final responseData = response.responseData as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          final List<dynamic> dataList = responseData['data'];
          // Map the list to your items format
          items.value = dataList.map((item) {
            return {
              'title': item['description'],
              'imagePath': item['images'], // Image URL
              'musicPath': item['audio'], // Audio URL
            };
          }).toList();
          isPlaying.value = List.generate(items.length, (_) => false);
        } else {
          Get.snackbar("Error", "Invalid response: data field missing.", duration: const Duration(seconds: 2));
        }
      } else {
        Get.snackbar("Error", response.errorMessage, duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred while fetching data.", duration: const Duration(seconds: 2));
    }
  }

  Future<void> togglePlay(int index) async {
    try {
      final musicPath = items[index]['musicPath'];
      if (musicPath == null || musicPath.isEmpty) {
        Get.snackbar("Error", "Invalid music path for this item.", duration: const Duration(seconds: 2));
        return;
      }

      // Update the state immediately to reflect the icon change
      if (currentlyPlayingIndex == index && isPlaying[index]) {
        // Pause the currently playing audio
        isPlaying[index] = false;
        currentlyPlayingIndex = null;
        isPlaying.refresh(); // Ensure UI updates immediately
        await player.pause();
      } else {
        // Stop any currently playing audio
        if (currentlyPlayingIndex != null) {
          isPlaying[currentlyPlayingIndex!] = false;
          isPlaying.refresh(); // Update UI before stopping
          await player.stop();
        }

        // Start playing the new audio
        currentlyPlayingIndex = index;
        isPlaying[index] = true;
        isPlaying.refresh(); // Ensure UI updates immediately
        await player.setUrl(musicPath);
        await player.play();
      }
    } catch (e) {
      // Get.snackbar("Error", "Failed to play audio: $e", duration: const Duration(seconds: 2));
    } finally {
      isPlaying.refresh(); // Final UI refresh to ensure proper state
    }
  }
  /// Method to stop music playback
  Future<void> stopMusic() async {
    if (currentlyPlayingIndex != null) {
      isPlaying[currentlyPlayingIndex!] = false;
      currentlyPlayingIndex = null;
      isPlaying.refresh(); // Ensure UI updates immediately
      await player.stop();
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Stop audio playback when the controller is closed
    stopMusic();
    player.dispose();
  }
}