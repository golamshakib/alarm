import 'dart:developer';
import 'dart:io';

import 'package:alarm/features/add_alarm/presentation/screens/local_background_screen.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/db_helpers/db_helper_local_background.dart';

class CreateNewBackgroundController extends GetxController {
  ImagePicker picker = ImagePicker();
  Rx<String> labelText = ''.obs; // Store label text

  /// -- P L A Y   M U S I C

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  // List<PlayerController> waveformControllers = []; // Create a PlayerController for each item
  RxBool isPlaying = false.obs;
  RxInt playingIndex = (-1).obs; // To track the currently playing item
  RxString musicHoverMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBackgroundsFromDB(); // Reload backgrounds from the database
    // checkPermissions();
    // Initialize waveform controllers
    // for (var _ in items) {
    //   waveformControllers.add(PlayerController());
    //
    // }
  }

  void addItem(Map<String, dynamic> item) {
    items.add(item);
    // waveformControllers
    //     .add(PlayerController()); // Add a controller for the new item
  }

  ///---- Fetch Data from Local Storage ----///

  Future<void> fetchBackgroundsFromDB() async {
    final dbHelper = DBHelperMusic();
    try {
      final data = await dbHelper.fetchBackgrounds();

      // Update the items and recreate waveform controllers
      items.value = data.toList();
      // waveformControllers.clear(); // Clear existing controllers
      // for (var _ in items) {
      //   waveformControllers.add(PlayerController()); // Create a controller for each item
      // }

      log('Fetched backgrounds: $items');
    } catch (e) {
      log('Error fetching backgrounds: $e');
    }
  }

  ///---- End  Fetch Data from Local Storage ----///

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
        // waveformControllers[index].pausePlayer();
      } else {
        // Stop the previous track if playing
        if (playingIndex.value != -1 && playingIndex.value != index) {
          await audioPlayer.stop();
          // waveformControllers[playingIndex.value].pausePlayer();
        }

        // Play the new track
        isPlaying.value = true;
        playingIndex.value = index;
        Get.forceAppUpdate();
        await audioPlayer.setFilePath(filePath);
        await audioPlayer.play();
        // waveformControllers[index].startPlayer();
      }
    } catch (e) {
      musicHoverMessage.value =
          "Failed to play audio: $e"; // Update hover message
    }
  }

  /// -- E N D  P L A Y   M U S I C

  void stopMusic() async {
    if (isPlaying.value) {
      await audioPlayer.stop(); // Stop the audio player
      isPlaying.value = false;
      if (playingIndex.value != -1) {
        // waveformControllers[playingIndex.value].pausePlayer(); // Pause the waveform controller
      }
      playingIndex.value = -1; // Reset the playing index
    }
  }

  /// -- S T A R T   R E C O R D I N G

  final PlayerController playerController = PlayerController();

  // final AudioRecorder audioRecorder = AudioRecorder();
  // RxBool isRecording = false.obs;
  // RxString recordingPath = ''.obs;
  Rx<String?> musicPath = Rx<String?>(null); // Store music URL
  // RxBool isMicDisabled = false.obs; // To disable the mic button
  RxBool isMusicDisabled = false.obs; // To disable the music button
  // RxString recordingHoverMessage = ''.obs;

  /// **Check & Request Permissions**
  // Future<void> checkPermissions() async {
  //   await Permission.microphone.request();
  //   await Permission.storage.request();
  //   await Permission.manageExternalStorage.request();
  //   await Permission.notification.request();
  // }

  /// **Launch Any Available Voice Recorder**
  // Future<void> openVoiceRecorder() async {
  //   try {
  //     final intent = AndroidIntent(
  //       action: 'android.provider.MediaStore.RECORD_SOUND',
  //       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
  //     );
  //
  //     await intent.launch();
  //   } catch (e) {
  //     Get.snackbar("Error", "No voice recorder found!", duration: const Duration(seconds: 2));
  //   }
  // }

  /// **Pick the Recorded File Manually**
  // Future<void> pickRecordedFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
  //
  //   if (result != null) {
  //     recordingPath.value = result.files.single.path!;
  //     Get.snackbar("Success", "Recording Selected", duration: const Duration(seconds: 2));
  //   } else {
  //     Get.snackbar("Error", "No file selected", duration: const Duration(seconds: 2));
  //   }
  // }

  /// -- Start Recording
  // Future<void> toggleRecording() async {
  //   try {
  //     if (isMicDisabled.value) {
  //       recordingHoverMessage.value = "Music is selected. Reset to enable mic recording.";
  //       return;
  //     }
  //
  //     if (isRecording.value) {
  //       String? filePath = await audioRecorder.stop();
  //       if (filePath != null) {
  //         recordingPath.value = filePath;
  //
  //         // Ensure the file exists before attempting playback
  //         if (await File(filePath).exists()) {
  //           playerController.preparePlayer(
  //             path: filePath,
  //             shouldExtractWaveform: true, // Ensure waveform data is extracted
  //           );
  //           isRecording.value = false;
  //           isMusicDisabled.value = true;
  //           recordingHoverMessage.value = "Recording saved successfully.";
  //         } else {
  //           recordingHoverMessage.value = "Recording file not found!";
  //         }
  //       }
  //     } else {
  //       if (!await audioRecorder.hasPermission()) {
  //         recordingHoverMessage.value = "Permission denied for recording!";
  //         return;
  //       }
  //
  //       final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  //       final String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
  //       final String filePath = path.join(appDocumentsDir.path, fileName);
  //
  //       // Check if the directory exists, create if not
  //       if (!await appDocumentsDir.exists()) {
  //         await appDocumentsDir.create(recursive: true);
  //       }
  //
  //       await audioRecorder.start(const RecordConfig(), path: filePath);
  //       isRecording.value = true;
  //       musicPath.value = null;
  //       recordingHoverMessage.value = "Recording started.";
  //     }
  //   } catch (e) {
  //     log("Error in recording: $e");
  //     print("Error in recording: $e");
  //     recordingHoverMessage.value = "Error starting/stopping recording.";
  //   }
  // }

  /// -- E N D   R E C O R D I N G

  /// -- P L A Y    R E C O R D I N G

  /// **Play Selected Recording**
  // Future<void> playRecording() async {
  //   if (recordingPath.value.isNotEmpty && File(recordingPath.value).existsSync()) {
  //     try {
  //       await audioPlayer.setFilePath(recordingPath.value);
  //       await audioPlayer.play();
  //     } catch (e) {
  //       log("Error playing recording: $e");
  //     }
  //   }
  // }

  /// **Stop Playing Recording**
  // Future<void> stopPlayback() async {
  //   await audioPlayer.stop();
  //   isPlaying.value = false;
  // }

  // var isRecordingPlaying = false.obs;
  //
  // void toggleRecordingPlayback({String? filePath}) async {
  //   if (recordingPath.value != null &&
  //       File(recordingPath.value!).existsSync()) {
  //     isRecordingPlaying.toggle(); // Toggles the playback state
  //     if (isRecordingPlaying.value) {
  //       // Logic to start playback
  //       playerController.startPlayer();
  //     } else {
  //       // Logic to pause playback
  //       playerController.pausePlayer();
  //     }
  //   }
  // }
  /// -- E N D    P L A Y    R E C O R D I N G

  /// -- P I C K    I M A G E    A N D    M U S I C

  Rx<String?> imagePath = Rx<String?>(null); // Store image path
  RxBool isImageSelected = false.obs; // Track if an image is selected

  // Pick Image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Set the image path
      imagePath.value = pickedFile.path;
      isImageSelected.value = true; // Mark image as selected
    } else {
      // Handle the case where the user cancels the image picker
      imagePath.value = null;
    }
  }

  // Pick Music
  RxBool isMusicSelected = false.obs; // Track if music is selected

  Future<void> pickMusic() async {
    if (isMusicDisabled.value) {
      musicHoverMessage.value =
          "Recording is in progress or completed. Reset to enable music selection.";
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      musicPath.value = result.files.single.path;
      isMusicSelected.value = true; // Mark music as selected
      // isMicDisabled.value = true; // Disable the mic button
      musicHoverMessage.value = "Music file selected successfully.";
    }
  }

  /// -- E N D   P I C K    I M A G E    A N D    M U S I C

  void saveData({int? id}) async {
    if (!isImageSelected.value) {
      Get.snackbar("Error", "Please select an image before saving background.",
          duration: const Duration(seconds: 2));
      return;
    }
    if (!isMusicSelected.value) {
      Get.snackbar(
          "Error", "Please select a music file before saving background.",
          duration: const Duration(seconds: 2));
      return;
    }

    final result = {
      'title':
          labelText.value.isNotEmpty ? labelText.value : 'Background Title',
      'imagePath': imagePath.value,
      'musicPath': musicPath.value,
      // 'recordingPath': recordingPath.value,
      'type': musicPath.value != null ? 'music' : 'recording',
    };

    final dbHelper = DBHelperMusic();

    try {
      if (id != null) {
        // Update existing entry
        int rowsUpdated = await dbHelper.updateBackground(result, id);
        if (rowsUpdated > 0) {
          Get.snackbar("Success", "Background updated successfully!",
              duration: const Duration(seconds: 2));
          // Update the local list
          int indexToUpdate =
              items.indexWhere((element) => element['id'] == id);
          if (indexToUpdate != -1) {
            items[indexToUpdate] = {...result, 'id': id}; // Update local list
            items.refresh();
          }
        } else {
          Get.snackbar("Error", "Failed to update background.",
              duration: const Duration(seconds: 2));
        }
      } else {
        // Insert new entry
        await dbHelper.insertBackground(result);
        // result['id'] = newId; // Add the ID to the result
        addItem(result); // Add the new item to the list

        // waveformControllers.add(PlayerController()); // Add a controller for the new item
        Get.snackbar("Success", "Background saved successfully!",
            duration: const Duration(seconds: 2));
      }

      resetFields(); // Reset fields

      Get.off(const LocalBackgroundScreen(), arguments: result);
      // Get.offNamedUntil(
      //     AppRoute.localBackgroundScreen,
      //     (Route route) =>
      //         route.settings.name == AppRoute.createNewBackgroundScreen,
      //     arguments: result);
    } catch (e) {
      log('Error saving data: $e');
      Get.snackbar("Error", "Failed to save background: $e",
          duration: const Duration(seconds: 2));
    }
  }

  void resetFields() {
    labelText.value = ''; // Clear the label text
    imagePath.value = null; // Clear the image path
    musicPath.value = null; // Clear the music URL
    // recordingPath.value = ''; // Clear the recording path
    // isRecording.value = false; // Reset recording state
    // isMicDisabled.value = false; // Enable mic button
    isMusicDisabled.value = false; // Enable music button
    // isRecordingPlaying.value = false; // Stop recording playback
    playerController.stopPlayer(); // Stop the player controller
    // recordingHoverMessage.value = "";
    musicHoverMessage.value = "";
  }

  @override
  void onClose() {
    stopMusic();
    audioPlayer.dispose();
    // for (var controller in waveformControllers) {
    //   controller.dispose();
    // }
    super.onClose();
  }
}
