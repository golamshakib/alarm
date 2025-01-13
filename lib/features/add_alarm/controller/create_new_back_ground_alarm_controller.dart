import 'package:get/get.dart';
import 'dart:io';

class CreateAlarmController extends GetxController {
  var selectedImage = Rx<File?>(null); // Holds the selected image
  var selectedAudio = Rx<File?>(null); // Holds the selected audio file
  var isRecording = false.obs; // Manages recording state

  void pickImage(File image) {
    selectedImage.value = image;
  }

  void pickAudio(File audio) {
    selectedAudio.value = audio;
  }

  void startRecording() {
    isRecording.value = true;
    // Add logic to start recording
  }

  void stopRecording() {
    isRecording.value = false;
    // Add logic to stop recording
  }
}
