import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:record/record.dart';

class CreateAlarmController extends GetxController {
  final titleController = TextEditingController();
  var selectedImage = Rx<File?>(null); // Holds the selected image
  var selectedAudio = Rx<File?>(null); // Holds the selected audio file
  Rx<String?> recordingPath = Rx<String?>(null);
  RxBool isRecordingNow = false.obs;
  var isRecordingPlaying = false.obs;

  final AudioRecorder audioRecorder = AudioRecorder();

  // Image Picker
  void pickImage(File image) {
    selectedImage.value = image;
    // img.value = File(image.path) as String?;
  }

  // Audio Picker
  void pickAudio(File audio) {
    selectedAudio.value = audio;
    // aud.value = File(audio.path) as String?;
  }

  Future<void> toggleRecording() async {
    if (isRecordingNow.value) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        recordingPath.value = filePath;
        playerController.preparePlayer(path: filePath);
        isRecordingNow.value = false;
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();
        final String fileName =
            'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
        final String filePath = path.join(appDocumentsDir.path, fileName);
        await audioRecorder.start(const RecordConfig(), path: filePath);
        recordingPath.value = null;
        isRecordingNow.value = true;
      }
    }
  }


  // Toggle playback using a simplified method
  void toggleRecordingPlayback({String? filePath}) async {
    if (recordingPath.value != null &&
        File(recordingPath.value!).existsSync()) {
      isRecordingPlaying.toggle(); // Toggles the playback state
      if (isRecordingPlaying.value) {
        // Logic to start playback
        playerController.startPlayer();
      } else {
        // Logic to pause playback
        playerController.pausePlayer();
      }
    }
  }


// List of alarms
  var backgrounds = <ChangeBackground>[].obs;

// Initialize isPlayingList dynamically based on backgrounds size
  var isPlayingList = <bool>[].obs; // Ensure this matches the list size at initialization
  final AudioPlayer audioPlayer = AudioPlayer();
  final PlayerController playerController = PlayerController();

  void togglePlayback(int index, {String? filePath}) async {
    if (index >= isPlayingList.length) {
      // Dynamically adjust the list size if needed
      isPlayingList.add(false);
    }

    // Stop current playback if any audio is already playing
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      playerController.pausePlayer();

      // Reset all other indexes to false
      isPlayingList.fillRange(0, isPlayingList.length, false);

      // Schedule the refresh after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isPlayingList.refresh(); // Ensure the UI updates after the build phase
      });
    }

    // Play the clicked index if not already playing
    if (filePath != null && File(filePath).existsSync()) {
      await audioPlayer.setFilePath(filePath);
      await audioPlayer.play();
      playerController.startPlayer();

      // Update only the selected index to true
      isPlayingList.fillRange(0, isPlayingList.length, false); // Reset all
      isPlayingList[index] = true;

      // Schedule the refresh after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isPlayingList.refresh(); // Ensure the UI updates after the build phase
      });

      // Listen for the playback starting
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isPlayingList[index] = true;
        isPlayingList.refresh(); // Ensure the UI updates after the build phase
      });
    } else {
      Get.snackbar('Error', 'Audio file not found or invalid.');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Ensure that the playback state is correctly initialized when navigating back to this screen
    isPlayingList.value = List.generate(backgrounds.length, (index) => false);
  }

// // Function to toggle playback
//   Future<void> togglePlayback(int index, {String? filePath}) async {
//     if (index >= isPlayingList.length) {
//       // Dynamically adjust the list size if needed
//       isPlayingList.add(false);
//     }
//
//     // Stop current playback if any audio is already playing
//     if (audioPlayer.playing) {
//       await audioPlayer.pause();
//       playerController.pausePlayer();
//
//       // Reset all other indexes to false
//       isPlayingList.fillRange(0, isPlayingList.length, false);
//
//       // Schedule the refresh after the build phase
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         isPlayingList.refresh(); // Ensure the UI updates after the build phase
//       });
//     }
//
//     // Play the clicked index if not already playing
//     if (filePath != null && File(filePath).existsSync()) {
//       await audioPlayer.setFilePath(filePath);
//       await audioPlayer.play();
//       playerController.startPlayer();
//
//       // Update only the selected index to true
//       isPlayingList.fillRange(0, isPlayingList.length, false); // Reset all
//       isPlayingList[index] = true;
//
//       // Schedule the refresh after the build phase
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         isPlayingList.refresh(); // Ensure the UI updates after the build phase
//       });
//
//       // Listen for the playback starting
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         isPlayingList[index] = true;
//         isPlayingList.refresh(); // Ensure the UI updates after the build phase
//       });
//     } else {
//       Get.snackbar('Error', 'Audio file not found or invalid.');
//     }
//   }

  void saveBackground() {
    final background = ChangeBackground(
      title: titleController.text.isEmpty
          ? 'Background Title'
          : titleController.text,
      image: selectedImage.value?.path ?? '',
      audio: selectedAudio.value?.path ?? '',
      record: recordingPath.value ?? '',
    );
    // Prepare waveform for uploaded audio
    if (selectedAudio.value != null) {
      playerController.preparePlayer(path: selectedAudio.value!.path);
    }
    backgrounds.add(background);
    update(); // Notify listeners
  }

// Reset method to clear fields
  void resetBackground() {
    titleController.clear();
    selectedImage.value = null;
    selectedAudio.value = null;
    recordingPath.value = null;
    isRecordingNow.value = false;
    // isPlayingList.value = false as List<bool>;
    playerController.stopPlayer();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    playerController.dispose();
    super.onClose();
  }
}

class ChangeBackground {
  final String title;
  final String image;
  final String audio;
  final String record;

  ChangeBackground({
    required this.title,
    required this.image,
    required this.audio,
    required this.record,
  });
}
