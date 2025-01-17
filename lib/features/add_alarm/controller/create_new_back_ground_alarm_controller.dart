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

  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final PlayerController playerController = PlayerController();

  // Image Picker
  void pickImage(File image) {
    selectedImage.value = image;
  }

  // Audio Picker
  void pickAudio(File audio) {
    selectedAudio.value = audio;
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

  @override
  void onClose() {
    audioPlayer.dispose();
    playerController.dispose();
    super.onClose();
  }

}
