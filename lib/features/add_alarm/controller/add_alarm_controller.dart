import 'dart:convert';
import 'dart:io';

import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:alarm/features/alarm/controller/alarm_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import '../../../core/db_helpers/db_helper_alarm.dart';
import '../../../core/services/notification_helper.dart';
import '../../settings/controller/settings_controller.dart';
import '../data/alarm_model.dart';

class AddAlarmController extends GetxController {
  final SettingsController settingsController = Get.find<SettingsController>();
  // final AlarmScreenController alarmScreenController = Get.put(AlarmScreenController());
  // final AlarmController alarmController = Get.find<AlarmController>();


  final labelController = TextEditingController();

  /// -- T I M E   S E C T I O N --
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

  /// -- E N D  T I M E   S E C T I O N --

  @override
  void onInit() {
    super.onInit();
    loadSavedVolume(); // Initialize volume controller
    loadScreenPreferences(); // Load preferences on initialization
    fetchAlarmsFromDatabase();
    setCurrentTime();

    timeFormat.value = settingsController.selectedTime.value;


    // Watch for changes in time format and adjust time accordingly
    ever(settingsController.selectedTime, (_) {
      timeFormat.value = settingsController.selectedTime.value;
      adjustTimeFormat();
    });
    handleAlarmOnAppStart();
    // alarmController.rescheduleAlarms();
  }

  /// -- S E T   B A C K G R O U N D --
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

  /// -- E N D   S E T   B A C K G R O U N D --

  /// -- R E P E A T   D A Y S --
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

  /// -- E N D   R E P E A T   D A Y S --

  /// -- A L A R M   L A B E L   S E C T I O N --
  var label = 'Morning Alarm'.obs;

  // Update label value
  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
    saveScreenPreferences(); // Save preferences on label change
  }

  /// -- E N D   A L A R M   L A B E L   S E C T I O N --

  /// -- S N O O Z E   D U R A T I O N --
  var selectedSnoozeDuration = 5.obs; // Default snooze duration (5 minutes)
  final List<int> snoozeOptions = [1, 5, 10, 15, 20, 25, 30];

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
    saveScreenPreferences(); // Save preferences on snooze change
  }

  /// -- S N O O Z E   D U R A T I O N --

  /// -- V I B R A T I O N   S E C T I O N --
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

  /// -- E N D   V I B R A T I O N   S E C T I O N --

  /// -- V O L U M E   S E C T I O N --

  var volume = 1.0.obs; // Independent volume variable


  // Load the saved volume (optional)
  Future<void> loadSavedVolume() async {
    // Simulate loading from shared preferences or local storage
    double savedVolume = 1.0; // Default value
    volume.value = savedVolume;
  }

  // Set the device volume using flutter_volume_controller
  Future<void> setDeviceVolume(double newVolume) async {
    volume.value = newVolume; // Update local state (UI won't reflect)
    try {
      // Set the system volume (values between 0.0 and 1.0)
      await FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(newVolume);

    } catch (e) { 
      debugPrint("Failed to set volume: $e");
    }
  }

  // Function to adjust the app's volume slider
  void setAppVolume(double newVolume) {
    setDeviceVolume(newVolume);
  }

  /// -- E N D   V O L U M E   S E C T I O N --

  /// -- S A V E   S C R E E N   S E T T I N G S --
  Future<void> saveScreenPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt('selectedHour', selectedHour.value),
      prefs.setInt('selectedMinute', selectedMinute.value),
      prefs.setBool('isAm', isAm.value),
      prefs.setString('label', label.value),
      prefs.setString('repeatDays', jsonEncode(repeatDays)),
      prefs.setInt('snoozeDuration', selectedSnoozeDuration.value),
      prefs.setBool('isVibrationEnabled', isVibrationEnabled.value),
      prefs.setDouble('volume', volume.value),
      prefs.setString('selectedBackground', selectedBackground.value),
      prefs.setString('selectedBackgroundImage', selectedBackgroundImage.value),
      prefs.setString('selectedMusicPath', selectedMusicPath.value),
    ]);
  }

  // Load screen settings
  Future<void> loadScreenPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    label.value = prefs.getString('label') ?? 'Morning Alarm';
    final repeatDaysString = prefs.getString('repeatDays');
    if (repeatDaysString != null) {
      final Map<String, dynamic> repeatDaysMap = jsonDecode(repeatDaysString);
      repeatDays.value =
          repeatDaysMap.map((key, value) => MapEntry(key, value as bool));
    }
    selectedSnoozeDuration.value = prefs.getInt('snoozeDuration') ?? 5;
    isVibrationEnabled.value = prefs.getBool('isVibrationEnabled') ?? true;
    volume.value = prefs.getDouble('volume') ?? 1.0;
    selectedBackground.value =
        prefs.getString('selectedBackground') ?? "Cute Dog";
    selectedBackgroundImage.value =
        prefs.getString('selectedBackgroundImage') ?? ImagePath.cat;
    selectedMusicPath.value = prefs.getString('selectedMusicPath') ?? '';
  }

  /// -- E N D   S A V E   &   L O A D  S C R E E N   S E T T I N G S --

  // List of alarms
  var alarms = <Alarm>[].obs;

  /// -- M U S I C   P L A Y / P A U S E --

  final audioPlayer = AudioPlayer(); // Audio player instance
  var isPlaying = false.obs; // Track playback state
  var currentlyPlayingIndex = (-1).obs; // Track the currently playing alarm

  Future<void> togglePlayPause(int index, String musicPath) async {
    try {
      if (musicPath.isEmpty) {
        Get.snackbar("Error", "No music file available.",
            duration: const Duration(seconds: 2));
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
          Get.snackbar("Error", "Invalid music file.",
              duration: const Duration(seconds: 2));
          return;
        }

        currentlyPlayingIndex.value = index;
        isPlaying.value = true;
        await audioPlayer.play();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to play music: $e",
          duration: const Duration(seconds: 2));
    }
  }

  /// -- E N D   M U S I C   P L A Y / P A U S E --

  /// -- S T O P   M U S I C --
  Future<void> stopMusic() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop(); // Stop the music playback
    }
    isPlaying.value = false; // Update the playback state
  }

  /// -- E N D   S T O P   M U S I C --


  /// **Set an Alarm in Native Code**

  static const MethodChannel _channel = MethodChannel('alarm_channel');

  /// Set an alarm at the given time (in milliseconds since epoch)
  Future<void> setAlarmNative(int timeInMillis, int alarmId, List<String> repeatDays) async {
    try {
      final dbHelper = DBHelperAlarm();  // Get the singleton instance
      // Fetch the alarm object from the database to check its toggle status
      final Alarm? alarm = await dbHelper.getAlarm(alarmId);

      // If the alarm exists and is toggled on, proceed with setting the alarm
      if (alarm != null && alarm.isToggled.value) {
        // Proceed with scheduling the alarm
        await _channel.invokeMethod('setAlarm', {
          'time': timeInMillis,
          'alarmId': alarmId,
          'repeatDays': repeatDays.isNotEmpty ? repeatDays : [],
        });
        debugPrint("============>>>>Native Alarm Set with Repeat Days: $repeatDays;");
      } else {
        debugPrint("Alarm with ID $alarmId is toggled off. Not setting alarm.");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to set alarm: ${e.message}");
    }
  }

  /// **Cancel an Alarm in Native Code**
  Future<void> cancelAlarmNative(int alarmId) async {
    try {
      await _channel.invokeMethod('cancelAlarm', {'alarmId': alarmId});
      debugPrint("Native Alarm Canceled for ID: $alarmId");
    } on PlatformException catch (e) {
      debugPrint("Failed to cancel alarm: ${e.message}");
    }
  }

  /// --  D A T A B A S E   S E R V I C E S --

  /// -- S E T   A L A R M   N A T I V E
  Future<void> saveAlarmToDatabase() async {
    final dbHelper = DBHelperAlarm();

    // Adjust time based on format
    // int alarmHour = selectedHour.value;
    //
    // // If using 24-hour format
    // if (timeFormat.value == 24) {
    //   if (selectedHour.value == 00 && isAm.value) {
    //     alarmHour = 0; // Handle 12 AM as 00:00 (Midnight)
    //   } else if (selectedHour.value == 12) {
    //     alarmHour = 12; // Keep 12 PM as 12:00 (Noon)
    //   } else if (!isAm.value && selectedHour.value < 12) {
    //     alarmHour += 12; // Handle PM time (convert 1 PM to 13:00, 2 PM to 14:00, etc.)
    //   }
    // } else {
    //   // If 12-hour format
    //   if (selectedHour.value == 12 && !isAm.value) {
    //     alarmHour = 12; // Keep 12 PM as 12:00
    //   } else if (selectedHour.value == 12 && isAm.value) {
    //     alarmHour = 0; // Midnight should be 00:00
    //   } else if (!isAm.value) {
    //     alarmHour += 12; // Convert PM times (1 PM to 13:00, 2 PM to 14:00, etc.)
    //   }
    // }

// Convert time based on format
    int alarmHour = selectedHour.value;

// For 12-hour format, do AM/PM conversion
    if (timeFormat.value == 12) {
      if (selectedHour.value == 12 && isAm.value) {
        alarmHour = 0;
      } else if (selectedHour.value == 12 && !isAm.value) {
        alarmHour = 12;
      } else if (!isAm.value) {
        alarmHour += 12;
      }
    } else {
      // For 24-hour format, determine AM/PM automatically
      isAm.value = selectedHour.value < 12;
    }

    final newAlarm = Alarm(
      hour: alarmHour,
      minute: selectedMinute.value,
      isAm: isAm.value,
      label: label.value.isEmpty ? 'Morning Alarm' : label.value,
      backgroundTitle: selectedBackground.value,
      backgroundImage: selectedBackgroundImage.value,
      musicPath: selectedMusicPath.value.isNotEmpty == true
          ? selectedMusicPath.value
          : "assets/audio/iphone_alarm.mp3",
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

      sortAlarmsChronologically(alarms);

      // ✅ Get the next valid alarm time
      DateTime alarmTime = getNextAlarmTime(newAlarm);
      int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;

      await setAlarmNative(
        alarmTimeInMillis,
        newAlarm.id!,
        newAlarm.repeatDays,
      );

      // Calculate remaining time
      Duration remainingTime = alarmTime.difference(DateTime.now());

      // Format remaining time
      int hours = remainingTime.inHours;
      int minutes = remainingTime.inMinutes % 60;

      String message;
      // Format next repeat days using the formatRepeatDays method
      String repeatDaysFormatted = formatRepeatDays(newAlarm.repeatDays);
      // Format next repeat days
      if (remainingTime.isNegative || remainingTime.inHours >= 24) {
        message = 'Alarm set for $repeatDaysFormatted';
      } else {
        message = "Alarm set for $hours hour${hours == 1 ? '' : 's'} and $minutes minute${minutes == 1 ? '' : 's'}";
      }

      // ✅ Print Alarm Details
      debugPrint("Scheduled Alarm Time: ${alarmTime.toLocal()}");
      debugPrint("🚀 Alarm Saved!");
      debugPrint(
          "⏰ User Set Alarm Time: ${newAlarm.hour}:${newAlarm.minute} ${newAlarm.isAm ? "AM" : "PM"}");
      debugPrint("Alarm set for repeat days: ${newAlarm.repeatDays}");
      debugPrint("📆 Alarm Scheduled for: ${alarmTime.toLocal()}");
      debugPrint("🔔 Label: ${newAlarm.label}");
      debugPrint(
          "🎵 Sound Path: ${newAlarm.musicPath.isEmpty ? 'Default' : newAlarm.musicPath}");
      debugPrint(
          "📳 Vibration: ${newAlarm.isVibrationEnabled ? 'Enabled' : 'Disabled'}");
      debugPrint("🔊 Volume: ${newAlarm.volume}");

      Get.snackbar(
        "",
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      // Show notification
      String alarmTimeFormatted = "$alarmHour:${selectedMinute.value < 10 ? '0' : ''}${selectedMinute.value}";
      await NotificationHelper.showPersistentNotification(newAlarm.id!, alarmTimeFormatted, newAlarm.label, newAlarm.repeatDays);

    } catch (e) {
      Get.snackbar("Error", "Failed to Save Alarm: $e",
          duration: const Duration(seconds: 2));
    }
  }

  // Repeating days method
  String formatRepeatDays(List<String> repeatDays) {
    if (repeatDays.isEmpty) return "Today"; // Default if empty
    if (repeatDays.length == 7) return "Everyday"; // If all days are selected
    return repeatDays.join(', '); // Otherwise, join with commas
  }

  // getNextAlarmTime
  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();

    int alarmHour = alarm.hour;

    // Adjust hour for 24-hour format
    if (!alarm.isAm && alarm.hour < 12) {
      alarmHour += 12; // PM times should be 12+ (e.g., 1 PM should be 13)
    } else if (alarm.isAm && alarm.hour == 00) {
      alarmHour = 0; // 12 AM should be 00:00 in 24-hour format
    } else if (!alarm.isAm && alarm.hour == 12) {
      alarmHour = 12; // Noon should stay 12:00 in 24-hour format
    }

    DateTime alarmDateTime = DateTime(now.year, now.month, now.day, alarmHour, alarm.minute);

    // If the alarm time is already past today, move to the next valid day
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
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

    return alarmDateTime;
  }


  ///** Fetch Alarm From Database
  Future<void> fetchAlarmsFromDatabase() async {
    final dbHelper = DBHelperAlarm();
    try {
      alarms.value = await dbHelper.fetchAlarms();
      sortAlarmsChronologically(alarms.toList());  // Sort after fetching
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch alarms: $e",
          duration: const Duration(seconds: 2));
    }
  }
  /// Sort Alarms Chronologically
  void sortAlarmsChronologically(List<Alarm> alarms) {
    alarms.sort((a, b) {
      final aTime = a.isAm ? a.hour % 12 : (a.hour % 12) + 12;
      final bTime = b.isAm ? b.hour % 12 : (b.hour % 12) + 12;

      final aTotalMinutes = aTime * 60 + a.minute;
      final bTotalMinutes = bTime * 60 + b.minute;

      return aTotalMinutes.compareTo(bTotalMinutes);
    });
  }

  ///** Update Alarm In Database
  Future<void> updateAlarmInDatabase(Alarm existingAlarm) async {
    final dbHelper = DBHelperAlarm();

    //Recalculate AM/PM in 24-hour format
    if (timeFormat.value == 24) {
      isAm.value = selectedHour.value < 12;
    }

    final updatedAlarm = Alarm(
      id: existingAlarm.id,
      hour: selectedHour.value,
      minute: selectedMinute.value,
      isAm: isAm.value,
      label: label.value.isEmpty ? 'Morning Alarm' : label.value,
      backgroundTitle: selectedBackground.value,
      backgroundImage: selectedBackgroundImage.value,
      musicPath: selectedMusicPath.value,
      // recordingPath: selectedRecordingPath.value,
      repeatDays: repeatDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      isVibrationEnabled: isVibrationEnabled.value,
      snoozeDuration: selectedSnoozeDuration.value,
      volume: volume.value,
    );

    try {
      await dbHelper.updateAlarm(updatedAlarm);
      // Manually update the alarms list to reflect the changes
      int indexToUpdate = alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
      if (indexToUpdate != -1) {
        alarms[indexToUpdate] = updatedAlarm;
      }
      // await fetchAlarmsFromDatabase();
      // Sort the alarms after updating
      sortAlarmsChronologically(alarms.toList());
      update(); // Trigger UI update after sorting
      DateTime alarmTime = getNextAlarmTime(updatedAlarm);
      int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;

      await setAlarmNative(
        alarmTimeInMillis,
        updatedAlarm.id!,
        updatedAlarm.repeatDays,
      );

      // Calculate remaining time
      Duration remainingTime = alarmTime.difference(DateTime.now());

      // Format remaining time
      int hours = remainingTime.inHours;
      int minutes = remainingTime.inMinutes % 60;

      String updateMessage;
      String repeatDaysFormatted = formatRepeatDays(updatedAlarm.repeatDays);

      // Format next repeat days
      if (remainingTime.isNegative || remainingTime.inHours >= 24) {
        // If the alarm is set for a future day or the remaining time is more than 24 hours
        updateMessage = 'Alarm updated for $repeatDaysFormatted';
      } else {
        // If the alarm is within the next 24 hours
        updateMessage = "Alarm updated for $hours hour${hours == 1 ? '' : 's'} and $minutes minute${minutes == 1 ? '' : 's'}";
      }

      Get.snackbar(
        "",
        updateMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      // Show notification
      String alarmTimeFormatted = "${selectedHour.value}:${selectedMinute.value < 10 ? '0' : ''}${selectedMinute.value}";
      await NotificationHelper.showPersistentNotification(updatedAlarm.id!, alarmTimeFormatted, updatedAlarm.label, updatedAlarm.repeatDays);
    } catch (e) {
      Get.snackbar("Error", "Failed to update alarm: $e",
          duration: const Duration(seconds: 2)); 
    } 
  } 

  // **Handle Alarm on App Start (for rescheduling alarms after app restart)**
  Future<void> handleAlarmOnAppStart() async {
    try {
      final dbHelper = DBHelperAlarm();
      List<Alarm> alarms = await dbHelper.fetchAlarms();
 
      // Iterate over the alarms and reschedule each one
      for (var alarm in alarms) {
        DateTime alarmTime = getNextAlarmTime(alarm);
        int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;

        // Set the alarm natively
        await setAlarmNative(
          alarmTimeInMillis,
          alarm.id!,
          alarm.repeatDays,
        );
      }
    } catch (e) {
      debugPrint("Failed to reschedule alarms: $e");
    }
  }



  ///** Delete an alarm from the SQLite database
  Future<void> deleteAlarmFromDatabase(int id) async {
    final dbHelper = DBHelperAlarm();
    try {
      await dbHelper.deleteAlarm(id);
      alarms.removeWhere((alarm) => alarm.id == id);
      Get.snackbar("Success", "Alarm deleted successfully!",
          duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar("Error", "Failed to delete alarm: $e",
          duration: const Duration(seconds: 2));
    }
  }

  /// -- E N D   D A T A B A S E   S E R V I C E S --

  /// -- Reset fields after saving --
  void resetFields() {
    selectedHour.value = 1;
    selectedMinute.value = 0;
    isAm.value = true;
    label.value = '';
    repeatDays.updateAll((key, value) => false);
    selectedSnoozeDuration.value = 5;
    isVibrationEnabled.value = false;
    volume.value = 1.0;
  }

  @override
  void dispose() {
    labelController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    stopMusic();
    audioPlayer.dispose();
    super.onClose();
  }
}
