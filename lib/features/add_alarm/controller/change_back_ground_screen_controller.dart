
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
        final responseData = response.responseData as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          final List<dynamic> dataList = responseData['data'];
          items.value = dataList.map((item) {
            return {
              'title': item['description'],
              'imagePath': item['images'],
              'musicPath': item['audio'],
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

      if (currentlyPlayingIndex == index && isPlaying[index]) {
        isPlaying[index] = false;
        currentlyPlayingIndex = null;
        isPlaying.refresh();
        await player.pause();
      } else {
        if (currentlyPlayingIndex != null) {
          isPlaying[currentlyPlayingIndex!] = false;
          isPlaying.refresh();
          await player.stop();
        }

        currentlyPlayingIndex = index;
        isPlaying[index] = true;
        isPlaying.refresh();
        await player.setUrl(musicPath);
        await player.play();
      }
    } catch (e) {
      // Get.snackbar("Error", "Failed to play audio: $e", duration: const Duration(seconds: 2));
    } finally {
      isPlaying.refresh();
    }
  }
  /// Method to stop music playback
  Future<void> stopMusic() async {
    if (currentlyPlayingIndex != null) {
      isPlaying[currentlyPlayingIndex!] = false;
      currentlyPlayingIndex = null;
      isPlaying.refresh();
      await player.stop();
    }
  }

  @override
  void onClose() {
    super.onClose();
    stopMusic();
    player.dispose();
  }
}