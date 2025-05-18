import 'dart:convert';
import 'dart:io';

import 'package:alarm/core/utils/constants/image_path.dart';
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



  final labelController = TextEditingController();

  /// -- T I M E   S E C T I O N --
  var selectedHour = 7.obs;
  var selectedMinute = 0.obs;
  var isAm = true.obs;

  var timeFormat = 12.obs;

  Future<void> loadTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    timeFormat.value = prefs.getInt('timeFormat') ?? 12;
  }

  void adjustTimeFormat() {
    if (timeFormat.value == 24) {
      if (!isAm.value) {
        if (selectedHour.value < 12) {
          selectedHour.value += 12;
        }
      } else {
        if (selectedHour.value == 12) {
          selectedHour.value = 0;
        }
      }
    } else {
      if (selectedHour.value == 0) {
        selectedHour.value = 12;
        isAm.value = true;
      } else if (selectedHour.value == 12) {
        isAm.value = false;
      } else if (selectedHour.value > 12) {
        selectedHour.value -= 12;
        isAm.value = false;
      } else {
        isAm.value = true;
      }
    }
  }

  void setCurrentTime() {
    DateTime now = DateTime.now();
    selectedHour.value = now.hour > 12 ? now.hour - 12 : now.hour;
    selectedMinute.value = now.minute;
    isAm.value = now.hour < 12;
  }

  /// -- E N D  T I M E   S E C T I O N --

  @override
  void onInit() {
    super.onInit();
    loadSavedVolume();
    loadScreenPreferences();
    fetchAlarmsFromDatabase();
    setCurrentTime();

    timeFormat.value = settingsController.selectedTime.value;

    ever(settingsController.selectedTime, (_) {
      timeFormat.value = settingsController.selectedTime.value;
      adjustTimeFormat();
    });
    handleAlarmOnAppStart();
  }

  /// -- S E T   B A C K G R O U N D --
  var selectedBackground = "Cute Dog".obs;
  var selectedBackgroundImage = ImagePath.cat.obs;
  var selectedMusicPath = 'assets/audio/iphone_alarm.mp3'.obs;
  var selectedRecordingPath = ''.obs;

  void updateBackground(String title, String imagePath, String musicPath) {
    selectedBackground.value = title;
    selectedBackgroundImage.value = imagePath;
    selectedMusicPath.value = musicPath;
    saveScreenPreferences();
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

  void toggleDay(String day) {
    repeatDays[day] = !repeatDays[day]!;
    repeatDays.refresh();
    saveScreenPreferences();
  }

  /// -- E N D   R E P E A T   D A Y S --

  /// -- A L A R M   L A B E L   S E C T I O N --
  var label = 'Morning Alarm'.obs;

  void updateLabel(String text) {
    label.value = text;
    labelController.text = text;
    saveScreenPreferences();
  }

  /// -- E N D   A L A R M   L A B E L   S E C T I O N --

  /// -- S N O O Z E   D U R A T I O N --
  var selectedSnoozeDuration = 5.obs;
  final List<int> snoozeOptions = [1, 5, 10, 15, 20, 25, 30];

  void updateSnoozeDuration(int duration) {
    selectedSnoozeDuration.value = duration;
    saveScreenPreferences();
  }

  /// -- S N O O Z E   D U R A T I O N --

  /// -- V I B R A T I O N   S E C T I O N --
  var isVibrationEnabled = true.obs;

  void toggleVibration() {
    isVibrationEnabled.value = !isVibrationEnabled.value;
    saveScreenPreferences();
  }

  Future<void> triggerAlarmVibration(Alarm alarm) async {
    if (alarm.isVibrationEnabled) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 1000);
      }
    }
  }

  Future<void> stopAlarmVibration() async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.cancel();
    }
  }

  /// -- E N D   V I B R A T I O N   S E C T I O N --

  /// -- V O L U M E   S E C T I O N --

  var volume = 1.0.obs;



  Future<void> loadSavedVolume() async {
    double savedVolume = 1.0;
    volume.value = savedVolume;
  }

  Future<void> setDeviceVolume(double newVolume) async {
    volume.value = newVolume;
    try {
      await FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(newVolume);

    } catch (e) { 
      debugPrint("Failed to set volume: $e");
    }
  }

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

  var alarms = <Alarm>[].obs;

  /// -- M U S I C   P L A Y / P A U S E --

  final audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentlyPlayingIndex = (-1).obs;

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
          await audioPlayer.setUrl(musicPath);
        } else if (File(musicPath).existsSync()) {
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
      await audioPlayer.stop();
    }
    isPlaying.value = false;
  }

  /// -- E N D   S T O P   M U S I C --

  static const MethodChannel _channel = MethodChannel('alarm_channel');

  Future<void> setAlarmNative(int timeInMillis, int alarmId, List<String> repeatDays) async {
    try {
      final dbHelper = DBHelperAlarm();
      final Alarm? alarm = await dbHelper.getAlarm(alarmId);
      if (alarm != null && alarm.isToggled.value) {
        await _channel.invokeMethod('setAlarm', {
          'time': timeInMillis,
          'alarmId': alarmId,
          'repeatDays': repeatDays.isNotEmpty ? repeatDays : [],
        });
      } else {
        debugPrint("Alarm with ID $alarmId is toggled off. Not setting alarm.");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to set alarm: ${e.message}");
    }
  }

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
    int alarmHour = selectedHour.value;

    if (timeFormat.value == 12) {
      if (selectedHour.value == 12 && isAm.value) {
        alarmHour = 0;
      } else if (selectedHour.value == 12 && !isAm.value) {
        alarmHour = 12;
      } else if (!isAm.value) {
        alarmHour += 12;
      }
    } else {
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
      newAlarm.id = id;
      alarms.add(newAlarm);
      sortAlarmsChronologically(alarms);
      DateTime alarmTime = getNextAlarmTime(newAlarm);
      int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;
      await setAlarmNative(
        alarmTimeInMillis,
        newAlarm.id!,
        newAlarm.repeatDays,
      );
      Duration remainingTime = alarmTime.difference(DateTime.now());

      int hours = remainingTime.inHours;
      int minutes = remainingTime.inMinutes % 60;

      String message;
      String repeatDaysFormatted = formatRepeatDays(newAlarm.repeatDays);
      if (remainingTime.isNegative || remainingTime.inHours >= 24) {
        message = 'Alarm set for $repeatDaysFormatted';
      } else {
        message = "Alarm set for $hours hour${hours == 1 ? '' : 's'} and $minutes minute${minutes == 1 ? '' : 's'}";
      }

      Get.snackbar(
        "",
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      String alarmTimeFormatted = "$alarmHour:${selectedMinute.value < 10 ? '0' : ''}${selectedMinute.value}";
      await NotificationHelper.showPersistentNotification(newAlarm.id!, alarmTimeFormatted, newAlarm.label, newAlarm.repeatDays);
    } catch (e) {
      Get.snackbar("Error", "Failed to Save Alarm: $e",
          duration: const Duration(seconds: 2));
    }
  }

  String formatRepeatDays(List<String> repeatDays) {
    if (repeatDays.isEmpty) return "Today";
    if (repeatDays.length == 7) return "Everyday";
    return repeatDays.join(', ');
  }

  DateTime getNextAlarmTime(Alarm alarm) {
    DateTime now = DateTime.now();

    int alarmHour = alarm.hour;

    if (!alarm.isAm && alarm.hour < 12) {
      alarmHour += 12;
    } else if (alarm.isAm && alarm.hour == 00) {
      alarmHour = 0;
    } else if (!alarm.isAm && alarm.hour == 12) {
      alarmHour = 12;
    }

    DateTime alarmDateTime = DateTime(now.year, now.month, now.day, alarmHour, alarm.minute);

    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    if (alarm.repeatDays.isNotEmpty) {
      List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      int todayIndex = now.weekday - 1;

      for (int i = 0; i < 7; i++) {
        int nextDayIndex = (todayIndex + i) % 7;
        if (alarm.repeatDays.contains(weekDays[nextDayIndex])) {
          return alarmDateTime.add(Duration(days: i));
        }
      }
    }
    return alarmDateTime;
  }

  Future<void> fetchAlarmsFromDatabase() async {
    final dbHelper = DBHelperAlarm();
    try {
      alarms.value = await dbHelper.fetchAlarms();
      sortAlarmsChronologically(alarms.toList());
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch alarms: $e",
          duration: const Duration(seconds: 2));
    }
  }
  void sortAlarmsChronologically(List<Alarm> alarms) {
    alarms.sort((a, b) {
      final aTime = a.isAm ? a.hour % 12 : (a.hour % 12) + 12;
      final bTime = b.isAm ? b.hour % 12 : (b.hour % 12) + 12;

      final aTotalMinutes = aTime * 60 + a.minute;
      final bTotalMinutes = bTime * 60 + b.minute;

      return aTotalMinutes.compareTo(bTotalMinutes);
    });
  }

  Future<void> updateAlarmInDatabase(Alarm existingAlarm) async {
    final dbHelper = DBHelperAlarm();

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
      int indexToUpdate = alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
      if (indexToUpdate != -1) {
        alarms[indexToUpdate] = updatedAlarm;
      }
      sortAlarmsChronologically(alarms.toList());
      update();
      DateTime alarmTime = getNextAlarmTime(updatedAlarm);
      int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;

      await setAlarmNative(
        alarmTimeInMillis,
        updatedAlarm.id!,
        updatedAlarm.repeatDays,
      );

      Duration remainingTime = alarmTime.difference(DateTime.now());

      int hours = remainingTime.inHours;
      int minutes = remainingTime.inMinutes % 60;

      String updateMessage;
      String repeatDaysFormatted = formatRepeatDays(updatedAlarm.repeatDays);

      if (remainingTime.isNegative || remainingTime.inHours >= 24) {
        updateMessage = 'Alarm updated for $repeatDaysFormatted';
      } else {
        updateMessage = "Alarm updated for $hours hour${hours == 1 ? '' : 's'} and $minutes minute${minutes == 1 ? '' : 's'}";
      }

      Get.snackbar(
        "",
        updateMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      String alarmTimeFormatted = "${selectedHour.value}:${selectedMinute.value < 10 ? '0' : ''}${selectedMinute.value}";
      await NotificationHelper.showPersistentNotification(updatedAlarm.id!, alarmTimeFormatted, updatedAlarm.label, updatedAlarm.repeatDays);
    } catch (e) {
      Get.snackbar("Error", "Failed to update alarm: $e",
          duration: const Duration(seconds: 2)); 
    } 
  }
  Future<void> handleAlarmOnAppStart() async {
    try {
      final dbHelper = DBHelperAlarm();
      List<Alarm> alarms = await dbHelper.fetchAlarms();
 
      for (var alarm in alarms) {
        DateTime alarmTime = getNextAlarmTime(alarm);
        int alarmTimeInMillis = alarmTime.millisecondsSinceEpoch;

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
