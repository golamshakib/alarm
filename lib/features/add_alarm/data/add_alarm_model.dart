import 'dart:convert';
import 'package:get/get.dart';

class AlarmModel {
  int? id; // Nullable ID for database purposes
  int hour;
  int minute;
  bool isAm;
  String label;
  String backgroundTitle; // Title of the background
  String backgroundImagePath; // Path to the background image
  String musicPath; // Path to the music file
  String recordingPath; // Path to the recording file
  List<String> repeatDays; // Days to repeat the alarm
  int snoozeDuration; // Duration of snooze in minutes
  bool isVibrationEnabled; // Whether vibration is enabled
  double volume; // Volume of the alarm
  RxBool isToggled; // Whether the alarm is toggled on/off

  AlarmModel({
    this.id,
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.label,
    required this.backgroundTitle,
    required this.backgroundImagePath,
    required this.musicPath,
    required this.recordingPath,
    required this.repeatDays,
    this.snoozeDuration = 5, // Default snooze duration (5 minutes)
    this.isVibrationEnabled = false,
    this.volume = 0.5, // Default volume (50%)
    bool isToggled = false,
  }) : isToggled = isToggled.obs;

  // Convert AlarmModel object to a Map for storing in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'isAm': isAm ? 1 : 0, // Store bool as 1 or 0
      'label': label,
      'backgroundTitle': backgroundTitle,
      'backgroundImagePath': backgroundImagePath,
      'musicPath': musicPath,
      'recordingPath': recordingPath,
      'repeatDays': jsonEncode(repeatDays), // Store as JSON string
      'snoozeDuration': snoozeDuration,
      'vibrationEnabled': isVibrationEnabled ? 1 : 0, // Store bool as 1 or 0
      'volume': volume,
      'isToggled': isToggled.value ? 1 : 0, // Store bool as 1 or 0
    };
  }

  // Create an AlarmModel object from a Map retrieved from SQLite
  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      isAm: map['isAm'] == 1,
      label: map['label'],
      backgroundTitle: map['backgroundTitle'],
      backgroundImagePath: map['backgroundImagePath'],
      musicPath: map['musicPath'],
      recordingPath: map['recordingPath'],
      repeatDays: List<String>.from(jsonDecode(map['repeatDays'])),
      snoozeDuration: map['snoozeDuration'],
      isVibrationEnabled: map['vibrationEnabled'] == 1,
      volume: map['volume'],
      isToggled: map['isToggled'] == 1,
    );
  }
}
