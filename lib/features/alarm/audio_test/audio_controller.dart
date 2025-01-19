import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';

class AudioController extends GetxController {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final PlayerController playerController = PlayerController();

  Rx<String?> recordingPath = Rx<String?>(null);
  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  // Add items to the list
  void addItem(Map<String, dynamic> item) {
    items.add(item);
  }
  RxBool isPlaying = false.obs;

  RxBool isRecording = false.obs;

  Rx<String> labelText = ''.obs; // Store label text
  Rx<String?> imagePath = Rx<String?>(null); // Store image path
  Rx<String?> musicUrl = Rx<String?>(null); // Store music URL

  // Toggle play/pause for the audio
  void togglePlay(int index) {
    if (isPlaying.value) {
      audioPlayer.pause();  // Pause the music
    } else {
      // If not playing, start playing music from the given URL
      audioPlayer.setFilePath(items[index]['musicUrl']);
      audioPlayer.play();
    }
    isPlaying.value = !isPlaying.value;  // Toggle the playing state
  }



  Future<void> toggleRecording() async {
    if (isRecording.value) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        recordingPath.value = filePath;
        playerController.preparePlayer(path: filePath);
        isRecording.value = false;
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
        final String fileName =
            'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
        final String filePath = path.join(appDocumentsDir.path, fileName);
        await audioRecorder.start(const RecordConfig(), path: filePath);
        recordingPath.value = null;
        isRecording.value = true;
      }
    }
  }

  Future<void> togglePlayback() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      playerController.pausePlayer();
    } else {
      if (recordingPath.value != null) {
        await audioPlayer.setFilePath(recordingPath.value!);
        await audioPlayer.play();
        playerController.startPlayer();
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Set the image path
      imagePath.value = pickedFile.path;
    } else {
      // Handle the case where the user cancels the image picker
      imagePath.value = null;
    }
  }

  Future<void> pickMusic() async {
    // Open the file picker to select audio files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Filter for audio files
    );

    if (result != null) {
      // Get the file path
      musicUrl.value = result.files.single.path;

      // You can also use `result.files.single.name` for the file name
    } else {
      // Handle the case where the user cancels the file picker
      musicUrl.value = null;
    }
  }

  void saveData() {
    // Here you can save the labelText, imagePath, and musicUrl
    // and navigate back
    Get.back(result: {
      'labelText': labelText.value,
      'imagePath': imagePath.value,
      'musicUrl': musicUrl.value,
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    playerController.dispose();
    super.onClose();
  }
}

