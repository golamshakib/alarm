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
  RxBool isPlaying = false.obs;

  // var title = 'Background Title'.obs;
  // Rx<String?> img = ''.obs;
  // Rx<String?> aud = ''.obs;
  // Rx<String?> rec = ''.obs;

  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final PlayerController playerController = PlayerController();

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

  // Start recording
  // Future<void> startRecording() async {
  //   if (!await audioRecorder.hasPermission()) {
  //     return;
  //   }
  //     final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  //     final String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
  //     final String filePath = path.join(appDocumentsDir.path, fileName);
  //
  //     await audioRecorder.start(const RecordConfig(), path: filePath);
  //     recordingPath.value = filePath;
  //     isRecordingNow.value = true;
  //     update();
  // }
  //
  // // Stop recording and prepare playback
  // Future<void> stopRecording() async {
  //   String? filePath = await audioRecorder.stop();
  //   if (filePath != null) {
  //     recordingPath.value = filePath;
  //     await playerController.preparePlayer(path: filePath);
  //     isRecordingNow.value = false;
  //     update();
  //     // Start playback automatically
  //     // togglePlayback();
  //   }
  // }

  // Toggle playback
  Future<void> togglePlayback({String? filePath}) async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      playerController.pausePlayer();
      isPlaying.value = false;
    } else {
      if (filePath != null && File(filePath).existsSync()) {
        await audioPlayer.setFilePath(filePath);
        await audioPlayer.play();
        playerController.startPlayer();
        isPlaying.value = true;
      } else {
        Get.snackbar('Error', 'Audio file not found or invalid.');
      }
    }
  }

  // List of alarms
  var backgrounds = <ChangeBackground>[].obs;

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
    print(background);
  }

  // Reset method to clear fields
  void resetBackground() {
    titleController.clear();
    selectedImage.value = null;
    selectedAudio.value = null;
    recordingPath.value = null;
    isRecordingNow.value = false;
    isPlaying.value = false;
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
