import 'package:get/get.dart';
import 'dart:io';

import 'package:record/record.dart';

class CreateAlarmController extends GetxController {
  var selectedImage = Rx<File?>(null); // Holds the selected image
  var selectedAudio = Rx<File?>(null); // Holds the selected audio file
  var isRecording = true.obs; // Manages recording state

  var isRecordingNow = true.obs;

  final AudioRecorder audioRecorder = AudioRecorder();

  void pickImage(File image) {
    selectedImage.value = image;
  }

  void pickAudio(File audio) {
    selectedAudio.value = audio;
  }

  void recording (){
    isRecordingNow.value = !isRecordingNow.value;

  }

  void startRecording() {
    isRecordingNow.value = true;
    // Add logic to start recording
  }

  void stopRecording() {
    isRecordingNow.value =  false;
    // Add logic to stop recording
  }
}
