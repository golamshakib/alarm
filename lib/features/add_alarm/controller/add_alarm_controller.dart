import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settings/controller/settings_controller.dart';

class AddAlarmController extends GetxController {
  final SettingsController settingsController = Get.find<SettingsController>();

  final labelController = TextEditingController();

  // Time selection
  var selectedHour = 7.obs;
  var selectedMinute = 0.obs;
  var isAm = true.obs;
  /// Track the current time format (12-hour or 24-hour)
  var timeFormat = 12.obs;

  /// Fetch and apply the user's time format preference
  Future<void> loadTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    timeFormat.value = prefs.getInt('timeFormat') ?? 12;
  }

  /// Adjust the default selected time when time format changes
  void adjustTimeFormat() {
    if (timeFormat.value == 24) {
      // Convert to 24-hour format
      if (!isAm.value) {
        selectedHour.value += 12;
      }
    } else {
      // Convert to 12-hour format
      if (selectedHour.value > 12) {
        selectedHour.value -= 12;
        isAm.value = false;
      } else {
        isAm.value = true;
      }
    }
  }

  void setCurrentTime() {
    // Set the current time to the selected hour and minute
    DateTime now = DateTime.now();
    selectedHour.value = now.hour > 12 ? now.hour - 12 : now.hour;
    selectedMinute.value = now.minute;
    isAm.value = now.hour < 12;
  }

  @override
  void onInit() {
    super.onInit();
    loadScreenPreferences(); // Load preferences on initialization
    setCurrentTime();
    timeFormat.value = settingsController.selectedTime.value;

    /// Watch for changes in time format and adjust time accordingly
    ever(settingsController.selectedTime, (_) {
      timeFormat.value = settingsController.selectedTime.value;
      adjustTimeFormat();
    });
  }
  /// Save screen state to `SharedPreferences`
  Future<void> saveScreenPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedHour', selectedHour.value);
    await prefs.setInt('selectedMinute', selectedMinute.value);
    await prefs.setBool('isAm', isAm.value);
    await prefs.setString('label', label.value);
    await prefs.setString('repeatDays', jsonEncode(repeatDays));
    await prefs.setInt('snoozeDuration', selectedSnoozeDuration.value);
    await prefs.setBool('isVibrationEnabled', isVibrationEnabled.value);
    await prefs.setDouble('volume', volume.value);
    await prefs.setString('selectedBackground', selectedBackground.value);
    await prefs.setString('selectedBackgroundImage', selectedBackgroundImage.value);
    await prefs.setString('selectedMusicPath', selectedMusicPath.value);
  }

  /// Load screen state from `SharedPreferences`
  Future<void> loadScreenPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    label.value = prefs.getString('label') ?? 'Morning Alarm';
    final repeatDaysString = prefs.getString('repeatDays');
    if (repeatDaysString != null) {
      final Map<String, dynamic> repeatDaysMap = jsonDecode(repeatDaysString);
      repeatDays.value = repeatDaysMap.map((key, value) => MapEntry(key, value as bool));
    }
    selectedSnoozeDuration.value = prefs.getInt('snoozeDuration') ?? 5;
    isVibrationEnabled.value = prefs.getBool('isVibrationEnabled') ?? true;
    volume.value = prefs.getDouble('volume') ?? 100.0;
    selectedBackground.value = prefs.getString('selectedBackground') ?? "Cute Dog in bed";
    selectedBackgroundImage.value = prefs.getString('selectedBackgroundImage') ?? "assets/images/dog.png";
    selectedMusicPath.value = prefs.getString('selectedMusicPath') ?? '';
  }



  // Alarm label
  var label = 'Morning Alarm'.obs;

  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
    saveScreenPreferences(); // Save preferences on label change
  }

  // Repeat days
  var repeatDays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  }.obs;

  // Toggle a repeat day
  void toggleDay(String day) {
    repeatDays[day] = !repeatDays[day]!;
    repeatDays.refresh();
    saveScreenPreferences(); // Save preferences on day toggle
  }

  // Snooze duration
  var selectedSnoozeDuration = 5.obs; // Default snooze duration (5 minutes)
  final List<int> snoozeOptions = [5, 10, 15, 20, 25, 30];

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
    saveScreenPreferences(); // Save preferences on snooze change
  }

  // Vibration toggle
  var isVibrationEnabled = true.obs;
  // Toggle vibration
  void toggleVibration() {
    isVibrationEnabled.value = !isVibrationEnabled.value;
    saveScreenPreferences(); // Save preferences on vibration toggle
  }

  // Volume
  var volume = 100.0.obs; // Default volume set to 50%

  // Set volume
  void setVolume(double newVolume) {
    volume.value = newVolume;
    saveScreenPreferences(); // Save preferences on volume change
  }

  // Set Background
  var selectedBackground = "Cute Dog in bed".obs;
  var selectedBackgroundImage = "assets/images/dog.png".obs;
  var selectedMusicPath = ''.obs;

  // Update background
  void updateBackground(String title, String imagePath, String musicPath) {
    selectedBackground.value = title;
    selectedBackgroundImage.value = imagePath;
    selectedMusicPath.value = musicPath;
    saveScreenPreferences(); // Save preferences on background change
  }


  // List of alarms
  var alarms = <Alarm>[].obs;

  final audioPlayer = AudioPlayer(); // Audio player instance
  var isPlaying = false.obs; // Track playback state
  var currentlyPlayingIndex = (-1).obs; // Track the currently playing alarm

  Future<void> togglePlayPause(int index) async {
    if (currentlyPlayingIndex.value == index && isPlaying.value) {
      // Pause the current playback
      isPlaying.value = false; // Update UI immediately
      await audioPlayer.pause();
    } else {
      // Play a new alarm's music
      if (currentlyPlayingIndex.value != -1 && isPlaying.value) {
        await audioPlayer.stop(); // Stop previous playback
      }

      final musicPath = alarms[index].musicPath;
      if (musicPath.isNotEmpty) {
        try {
          currentlyPlayingIndex.value = index; // Update playing index
          isPlaying.value = true; // Update UI immediately
          await audioPlayer.setFilePath(musicPath);
          await audioPlayer.play();
        } catch (e) {
          // Handle errors (e.g., file not found)
          isPlaying.value = false;
          currentlyPlayingIndex.value = -1;
          Get.snackbar("Error", "Failed to play audio: $e");
        }
      } else {
        Get.snackbar("Error", "No music file found for this alarm.");
      }
    }
  }


  // Save the current alarm
  void saveAlarm() {
    final alarm = Alarm(
      hour: selectedHour.value,
      minute: selectedMinute.value,
      isAm: isAm.value,
      backgroundImage: selectedBackgroundImage.value,
      musicPath: selectedMusicPath.value,
      label: label.value.isEmpty ? 'Morning Alarm' : label.value,
      repeatDays: repeatDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      isToggled: false,
    );
    alarms.add(alarm);
    update(); // Notify listeners
  }

  // Reset fields after saving
  void resetFields() {
    selectedHour.value = 1;
    selectedMinute.value = 0;
    isAm.value = true;
    label.value = '';
    repeatDays.updateAll((key, value) => false);
    selectedSnoozeDuration.value = 5;
    isVibrationEnabled.value = false;
    volume.value = 50.0;
  }


  // Alarm Screen Method
  void toggleAlarm(int index) {
    alarms[index].isToggled.value = !alarms[index].isToggled.value;
    alarms.refresh(); // Notify the UI to rebuild
  }

  // Selection mode on the Alarm Screen
  var isSelectionMode = false.obs;
  var selectedAlarms = <int>[].obs;

  // Enable selection mode
  void enableSelectionMode(int index) {
    isSelectionMode.value = true;
    selectedAlarms.add(index);
  }

  // Toggle selection
  void toggleSelection(int index) {
    if (selectedAlarms.contains(index)) {
      selectedAlarms.remove(index);
    } else {
      selectedAlarms.add(index);
    }
  }

  // Exit selection mode
  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedAlarms.clear();
  }

  // Delete selected alarms
  void deleteSelectedAlarms() {
    alarms.removeWhere((alarm) => selectedAlarms.contains(alarms.indexOf(alarm)));
    exitSelectionMode();
  }

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // Dispose of the audio player when the controller is closed
    super.onClose();
  }
}

// Alarm model
class Alarm {
  int hour;
  int minute;
  bool isAm;
  String label;
  String backgroundImage;
  String musicPath;
  List<String> repeatDays;
  RxBool isToggled;

  Alarm({
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.label,
    required this.backgroundImage,
    required this.musicPath,
    required this.repeatDays,
    bool isToggled = false,
  }) : isToggled = isToggled.obs;
}