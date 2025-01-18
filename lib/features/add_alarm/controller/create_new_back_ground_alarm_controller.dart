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
  RxBool isRecordingNow  = false.obs;
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

  // Start recording
  Future<void> startRecording() async {
    if (await audioRecorder.hasPermission()) {
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDocumentsDir.path, 'recording.wav');
      await audioRecorder.start(const RecordConfig(), path: filePath);
      recordingPath.value = null;
      isRecordingNow.value = true;
    }
  }

  // Stop recording and prepare playback
  Future<void> stopRecording() async {
    String? filePath = await audioRecorder.stop();
    if (filePath != null) {
      recordingPath.value = filePath;
      playerController.preparePlayer(path: filePath);
      isRecordingNow.value = false;

      // Start playback automatically
      // togglePlayback();
    }
  }

  // Toggle playback
  Future<void> togglePlayback() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      playerController.pausePlayer();
      isPlaying.value = false;
    } else {
      if (recordingPath.value != null) {
        await audioPlayer.setFilePath(recordingPath.value!);
        await audioPlayer.play();
        playerController.startPlayer();
        isPlaying.value = true;
      }
    }
  }
  // List of alarms
  var backgrounds = <ChangeBackground>[].obs;

  void saveBackground() {
    final background = ChangeBackground(
      title: titleController.text.isEmpty ? 'Background Title' : titleController.text,
      image: selectedImage.value?.path ?? '', // Use path for the image file
      audio: selectedAudio.value?.path ?? '', // Use path for the audio file
      record: recordingPath.value ?? '', // Recording path

    );
    backgrounds.add(background);
    update(); // Notify listeners
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