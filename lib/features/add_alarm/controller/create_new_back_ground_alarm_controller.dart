import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';

class CreateAlarmController extends GetxController {
  ImagePicker picker = ImagePicker();
  Rx<String> labelText = ''.obs; // Store label text

  /// -- P L A Y   M U S I C

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  List<PlayerController> waveformControllers = []; // Create a PlayerController for each item
  RxBool isPlaying = false.obs;
  RxInt playingIndex = (-1).obs; // To track the currently playing item
  RxString musicHoverMessage = ''.obs;



  @override
  void onInit() {
    super.onInit();
    // Initialize waveform controllers
    for (var _ in items) {
      waveformControllers.add(PlayerController());
    }
  }

  void addItem(Map<String, dynamic> item) {
    items.add(item);
    waveformControllers
        .add(PlayerController()); // Add a controller for the new item
  }

  // Play Music
  Future<void> playMusic(int index) async {
    final item = items[index];
    final filePath = item['musicPath'] ?? item['recordingPath'];

    if (filePath == null || !File(filePath).existsSync()) {
      musicHoverMessage.value = "No audio file found!"; // Update hover message

      return;
    }

    try {
      if (playingIndex.value == index && isPlaying.value) {
        // Pause the current track
        isPlaying.value = false;
        await audioPlayer.pause();
        waveformControllers[index].pausePlayer();
      } else {
        // Stop the previous track if playing
        if (playingIndex.value != -1 && playingIndex.value != index) {
          await audioPlayer.stop();
          waveformControllers[playingIndex.value].pausePlayer();
        }

        // Play the new track
        isPlaying.value = true;
        playingIndex.value = index;
        Get.forceAppUpdate();
        await audioPlayer.setFilePath(filePath);
        await audioPlayer.play();
        waveformControllers[index].startPlayer();
      }
    } catch (e) {
      musicHoverMessage.value = "Failed to play audio: $e"; // Update hover message
    }
  }

  /// -- E N D  P L A Y   M U S I C


  void stopMusic() async {
    if (isPlaying.value) {
      await audioPlayer.stop();
      isPlaying.value = false;
      playingIndex.value = -1;
    }
  }

  /// -- S T A R T   R E C O R D I N G

  final PlayerController playerController = PlayerController();
  final AudioRecorder audioRecorder = AudioRecorder();
  RxBool isRecording = false.obs;
  Rx<String?> recordingPath = Rx<String?>(null);
  Rx<String?> musicPath = Rx<String?>(null); // Store music URL
  RxBool isMicDisabled = false.obs; // To disable the mic button
  RxBool isMusicDisabled = false.obs; // To disable the music button
  RxString recordingHoverMessage = ''.obs;

  // Start Recording
  Future<void> toggleRecording() async {
    if (isMicDisabled.value) {
      recordingHoverMessage.value = "Music is selected. Reset to enable mic recording.";
      return;
    }

    if (isRecording.value) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        recordingPath.value = filePath;
        playerController.preparePlayer(
          path: filePath,
          shouldExtractWaveform: true, // Ensure waveform data is extracted
        );
        isRecording.value = false;
        isMusicDisabled.value = true;
        recordingHoverMessage.value = "Recording saved successfully."; // Update hover message
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
        final String fileName =
            'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
        final String filePath = path.join(appDocumentsDir.path, fileName);
        await audioRecorder.start(const RecordConfig(), path: filePath);
        isRecording.value = true;
        musicPath.value = null;
        recordingHoverMessage.value = "Recording started.";
      }
    }
  }
  /// -- E N D   R E C O R D I N G

  /// -- P L A Y    R E C O R D I N G

  var isRecordingPlaying = false.obs;

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
  /// -- E N D    P L A Y    R E C O R D I N G


  /// -- P I C K    I M A G E    A N D    M U S I C

  Rx<String?> imagePath = Rx<String?>(null); // Store image path

  // Pick Image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Set the image path
      imagePath.value = pickedFile.path;
    } else {
      // Handle the case where the user cancels the image picker
      imagePath.value = null;
    }
  }

  // Pick Music
  Future<void> pickMusic() async {
    if (isMusicDisabled.value) {
      musicHoverMessage.value = "Recording is in progress or completed. Reset to enable music selection.";
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      musicPath.value = result.files.single.path;
      isMicDisabled.value = true; // Disable the mic button
      musicHoverMessage.value = "Music file selected successfully.";    }
  }

  /// -- E N D   P I C K    I M A G E    A N D    M U S I C


  void saveData() {
    final result = {
      'title': labelText.value.isNotEmpty
          ? labelText.value
          : 'Background Title',
      'image': imagePath.value,
      'musicPath': musicPath.value,
      'recordingPath': recordingPath.value,
      'type': musicPath.value != null ? 'music' : 'recording',
    };

    addItem(result); // Add the saved data to the items list
    resetFields();   // Reset the fields
    Get.back(result: result); // Navigate back to the previous screen
  }

  void resetFields() {
    labelText.value = ''; // Clear the label text
    imagePath.value = null; // Clear the image path
    musicPath.value = null; // Clear the music URL
    recordingPath.value = null; // Clear the recording path
    isRecording.value = false; // Reset recording state
    isMicDisabled.value = false; // Enable mic button
    isMusicDisabled.value = false; // Enable music button
    isRecordingPlaying.value = false; // Stop recording playback
    playerController.stopPlayer(); // Stop the player controller
    recordingHoverMessage.value = "";
    musicHoverMessage.value = "";
  }

  @override
  void onClose() {
    stopMusic();
    audioPlayer.dispose();
    for (var controller in waveformControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
