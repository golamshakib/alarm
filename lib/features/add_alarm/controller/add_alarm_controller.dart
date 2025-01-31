import 'dart:convert';
import 'dart:io';

import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_controller/volume_controller.dart';


import '../../../core/utils/helpers/db_helper_alarm.dart';
import '../../alarm_notification/notification_helper.dart';
import '../../settings/controller/settings_controller.dart';
import '../data/alarm_model.dart';

class AddAlarmController extends GetxController {
  final SettingsController settingsController = Get.find<SettingsController>();

  final labelController = TextEditingController();

 /// T I M E   S E C T I O N
  var selectedHour = 7.obs;
  var selectedMinute = 0.obs;
  var isAm = true.obs;

  // Track the current time format (12-hour or 24-hour)
  var timeFormat = 12.obs;

  // Fetch and apply the user's time format preference
  Future<void> loadTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    timeFormat.value = prefs.getInt('timeFormat') ?? 12;
  }

  // Adjust the default selected time when time format changes
  void adjustTimeFormat() {
    if (timeFormat.value == 24) {
      // Convert to 24-hour format
      if (!isAm.value) {
        if (selectedHour.value < 12) {
          selectedHour.value += 12; // Convert PM times
        }
      } else {
        if (selectedHour.value == 12) {
          selectedHour.value = 0; // Convert 12 AM to 0
        }
      }
    } else {
      // Convert to 12-hour format
      if (selectedHour.value == 0) {
        selectedHour.value = 12;
        isAm.value = true; // Midnight is AM
      } else if (selectedHour.value == 12) {
        isAm.value = false; // Noon is PM
      } else if (selectedHour.value > 12) {
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
  /// E N D  T I M E   S E C T I O N


  @override
  void onInit() {
    super.onInit();
    initializeVolumeController(); // Initialize volume controller
    loadScreenPreferences(); // Load preferences on initialization
    fetchAlarmsFromDatabase();
    setCurrentTime();
    timeFormat.value = settingsController.selectedTime.value;

    // Watch for changes in time format and adjust time accordingly
    ever(settingsController.selectedTime, (_) {
      timeFormat.value = settingsController.selectedTime.value;
      adjustTimeFormat();
    });
  }

  /// S A V E   S C R E E N   S E T T I N G S
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

  // Load screen settings
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
    volume.value = prefs.getDouble('volume') ?? 0.5;
    selectedBackground.value = prefs.getString('selectedBackground') ?? "Cute Dog in bed";
    selectedBackgroundImage.value = prefs.getString('selectedBackgroundImage') ?? "assets/images/dog.png";
    selectedMusicPath.value = prefs.getString('selectedMusicPath') ?? '';
  }

  /// E N D   S A V E   &   L O A D  S C R E E N   S E T T I N G S


 /// A L A R M   L A B E L   S E C T I O N
  var label = 'Morning Alarm'.obs;

  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
    saveScreenPreferences(); // Save preferences on label change
  }
  /// E N D   A L A R M   L A B E L   S E C T I O N

  /// R E P E A T   D A Y S
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
  /// E N D   R E P E A T   D A Y S

  /// S N O O Z E   D U R A T I O N
  var selectedSnoozeDuration = 5.obs; // Default snooze duration (5 minutes)
  final List<int> snoozeOptions = [1, 5, 10, 15, 20, 25, 30];

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
    saveScreenPreferences(); // Save preferences on snooze change
  }
  /// S N O O Z E   D U R A T I O N

  /// V I B R A T I O N   S E C T I O N
  var isVibrationEnabled = true.obs;
  // Toggle vibration
  void toggleVibration() {
    isVibrationEnabled.value = !isVibrationEnabled.value;
    saveScreenPreferences(); // Save preferences on vibration toggle
  }

  // Trigger vibration when the alarm rings
  Future<void> triggerAlarmVibration(Alarm alarm) async {
    if (alarm.isVibrationEnabled) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 1000); // Vibrate for 1 second
      }
    }
  }

  // Stop vibration
  Future<void> stopAlarmVibration() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      Vibration.cancel();
    }
  }
  /// E N D   V I B R A T I O N   S E C T I O N


 /// V O L U M E   S E C T I O N
  var volume = 0.5.obs; // Default volume set to 50%
  late VolumeController volumeController; // VolumeController instance

  // Initialize volume controller
  Future<void> initializeVolumeController() async {
    volumeController = VolumeController.instance; // Initialize the VolumeController instance
    // Add a listener for volume changes
    volumeController.addListener((double newVolume) {
      volume.value = newVolume; // Update the volume value
    });
    // Get the initial system volume
    volume.value = await volumeController.getVolume();
  }

  // Set device volume
  Future<void> setDeviceVolume(double newVolume) async {
    volume.value = newVolume; // Update the volume value
    await volumeController.setVolume(newVolume); // Set the system volume
    saveScreenPreferences(); // Save the volume to preferences
  }
  /// E N D   V O L U M E   S E C T I O N

  /// S E T   B A C K G R O U N D
  var selectedBackground = "Cute Dog".obs;
  var selectedBackgroundImage = ImagePath.cat.obs;
  var selectedMusicPath = 'assets/audio/iphone_alarm.mp3'.obs;
  var selectedRecordingPath = ''.obs;

  // Update background
  void updateBackground(String title, String imagePath, String musicPath) {
    selectedBackground.value = title;
    selectedBackgroundImage.value = imagePath;
    selectedMusicPath.value = musicPath;
    saveScreenPreferences(); // Save preferences on background change
  }
  /// E N D   S E T   B A C K G R O U N D


  // List of alarms
  var alarms = <Alarm>[].obs;

  /// M U S I C   P L A Y / P A U S E
  final audioPlayer = AudioPlayer(); // Audio player instance
  var isPlaying = false.obs; // Track playback state
  var currentlyPlayingIndex = (-1).obs; // Track the currently playing alarm

  Future<void> togglePlayPause(int index, String musicPath) async {
    try {
      if (musicPath.isEmpty) {
        Get.snackbar("Error", "No music file available.", duration: const Duration(seconds: 2));
        return;
      }

      if (currentlyPlayingIndex.value == index && isPlaying.value) {
        await audioPlayer.pause();
        isPlaying.value = false;
        currentlyPlayingIndex.value = -1;
      } else {
        await audioPlayer.stop();

        if (musicPath.startsWith("http") || musicPath.startsWith("https")) {
          // Play from network URL
          await audioPlayer.setUrl(musicPath);
        } else if (File(musicPath).existsSync()) {
          // Play from local file
          await audioPlayer.setFilePath(musicPath);
        } else {
          Get.snackbar("Error", "Invalid music file.", duration: const Duration(seconds: 2));
          return;
        }

        currentlyPlayingIndex.value = index;
        isPlaying.value = true;
        await audioPlayer.play();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to play music: $e", duration: const Duration(seconds: 2));
    }
  }
  /// E N D   M U S I C   P L A Y / P A U S E

  /// S T O P   M U S I C
  Future<void> stopMusic() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop(); // Stop the music playback
    }
    isPlaying.value = false; // Update the playback state
  }
  /// E N D   S T O P   M U S I C

  ///  D A T A B A S E   S E R V I C E S
  // Save alarm to Database
  Future<void> saveAlarmToDatabase() async {
    final dbHelper = DBHelperAlarm();
    final newAlarm = Alarm(
      hour: selectedHour.value,
      minute: selectedMinute.value,
      isAm: isAm.value,
      label: label.value.isEmpty ? 'Morning Alarm' : label.value,
      backgroundTitle: selectedBackground.value,
      backgroundImage: selectedBackgroundImage.value,
      musicPath: selectedMusicPath.value, // Custom sound path from database
      recordingPath: selectedRecordingPath.value,
      repeatDays: repeatDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      isVibrationEnabled: isVibrationEnabled.value,
      snoozeDuration: selectedSnoozeDuration.value,
      volume: volume.value,
      isToggled: true,
    );

    try {
      final id = await dbHelper.insertAlarm(newAlarm);
      newAlarm.id = id; // Assign database ID
      alarms.add(newAlarm);

      // ✅ Get the next valid alarm time
      DateTime alarmTime = getNextAlarmTime(newAlarm);

      // ✅ Print Alarm Details
      print("Scheduled Alarm Time: ${alarmTime.toLocal()}");
      print("🚀 Alarm Saved!");
      print("⏰ User Set Alarm Time: ${newAlarm.hour}:${newAlarm.minute} ${newAlarm.isAm ? "AM" : "PM"}");
      print("📅 Repeat Days: ${newAlarm.repeatDays.isNotEmpty ? newAlarm.repeatDays.join(', ') : 'None'}");
      print("📆 Alarm Scheduled for: ${alarmTime.toLocal()}");
      print("🔔 Label: ${newAlarm.label}");
      print("🎵 Sound Path: ${newAlarm.musicPath.isEmpty ? 'Default' : newAlarm.musicPath}");
      print("📳 Vibration: ${newAlarm.isVibrationEnabled ? 'Enabled' : 'Disabled'}");
      print("🔊 Volume: ${newAlarm.volume}");


      // Schedule notification (without sound)
      await NotificationHelper.scheduleAlarm(
        id: id,
        title: "Alarm",
        body: newAlarm.label,
        // imagePath: newAlarm.backgroundImage,
        // soundPath: newAlarm.musicPath, // This will be used in AlarmTriggerScreen
        scheduledTime: alarmTime,
      );

      Get.snackbar("Success", "Alarm saved Successfully!", duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar("Error", "Failed to Save Alarm: $e", duration: const Duration(seconds: 2));
    }
  }

  // getNextAlarmTime
  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();

    // Convert user-set time to 24-hour format
    int alarmHour = alarm.isAm ? (alarm.hour == 12 ? 0 : alarm.hour) : (alarm.hour == 12 ? 12 : alarm.hour + 12);
    DateTime alarmDateTime = DateTime(now.year, now.month, now.day, alarmHour, alarm.minute);

    // If the alarm time is already past today, move to the next valid day
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(Duration(days: 1));
    }

    // If the user has selected repeat days, find the next valid day
    if (alarm.repeatDays.isNotEmpty) {
      List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      int todayIndex = now.weekday - 1; // Monday is index 0

      for (int i = 0; i < 7; i++) {
        int nextDayIndex = (todayIndex + i) % 7;
        if (alarm.repeatDays.contains(weekDays[nextDayIndex])) {
          return alarmDateTime.add(Duration(days: i));

        }
      }
    }

    // If no repeat days, return the next valid alarm time
    return alarmDateTime;
  }





  // Fetch alarms from the database
  Future<void> fetchAlarmsFromDatabase() async {
    final dbHelper = DBHelperAlarm();
    try {
      alarms.value = await dbHelper.fetchAlarms();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch alarms: $e", duration: const Duration(seconds: 2));
    }
  }



  // Update alarms from the database
  Future<void> updateAlarmInDatabase(Alarm existingAlarm) async {
    final dbHelper = DBHelperAlarm();
    final updatedAlarm = Alarm(
      id: existingAlarm.id, // Retain the existing alarm's ID
      hour: selectedHour.value,
      minute: selectedMinute.value,
      isAm: isAm.value,
      label: label.value.isEmpty ? 'Morning Alarm' : label.value,
      backgroundTitle: selectedBackground.value,
      backgroundImage: selectedBackgroundImage.value,
      musicPath: selectedMusicPath.value,
      recordingPath: selectedRecordingPath.value,
      repeatDays: repeatDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      isVibrationEnabled: isVibrationEnabled.value,
      snoozeDuration: selectedSnoozeDuration.value,
      volume: volume.value,
    );
    try {
      await dbHelper.updateAlarm(updatedAlarm); // Update the alarm in the database
      fetchAlarmsFromDatabase(); // Refresh the list of alarms
      Get.snackbar("Success", "Alarm updated successfully!", duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar("Error", "Failed to update alarm: $e", duration: const Duration(seconds: 2));
    }
  }
  // Delete an alarm from the SQLite database
  Future<void> deleteAlarmFromDatabase(int id) async {
    final dbHelper = DBHelperAlarm();
    try {
      await dbHelper.deleteAlarm(id);
      alarms.removeWhere((alarm) => alarm.id == id);
      Get.snackbar("Success", "Alarm deleted successfully!", duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar("Error", "Failed to delete alarm: $e", duration: const Duration(seconds: 2));
    }
  }
  /// E N D   D A T A B A S E   S E R V I C E S

  // Reset fields after saving
  void resetFields() {
    selectedHour.value = 1;
    selectedMinute.value = 0;
    isAm.value = true;
    label.value = '';
    repeatDays.updateAll((key, value) => false);
    selectedSnoozeDuration.value = 5;
    isVibrationEnabled.value = false;
    volume.value = 0.5;
  }


  @override
  void dispose() {
    labelController.dispose();
    audioPlayer.dispose();
    volumeController.removeListener();
    super.dispose();
  }

  @override
  void onClose() {
    stopMusic(); // Stop music playback
    audioPlayer.dispose(); // Dispose of the audio player when the controller is closed
    volumeController.removeListener();
    super.onClose();
  }
}



