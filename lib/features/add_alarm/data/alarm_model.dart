import 'dart:convert';

import 'package:get/get.dart';

class Alarm {
  int? id;
  int hour, minute;
  bool isAm;
  String label, backgroundTitle, backgroundImage, musicPath, recordingPath;
  List<String> repeatDays;
  bool isVibrationEnabled;
  int snoozeDuration;
  double volume;
  RxBool isToggled;

  Alarm({
    this.id,
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.label,
    required this.backgroundTitle,
    required this.backgroundImage,
    required this.musicPath,
    required this.recordingPath,
    required this.repeatDays,
    this.isVibrationEnabled = false,
    this.snoozeDuration = 5,
    this.volume = 0.5,
    bool isToggled = false,
  }) : isToggled = isToggled.obs;

  Map<String, dynamic> toMap() => {
    'id': id,
    'hour': hour,
    'minute': minute,
    'isAm': isAm ? 1 : 0,
    'label': label,
    'backgroundTitle': backgroundTitle,
    'backgroundImage': backgroundImage,
    'musicPath': musicPath,
    'recordingPath': recordingPath,
    'repeatDays': repeatDays.join(','),
    'isVibrationEnabled': isVibrationEnabled ? 1 : 0,
    'snoozeDuration': snoozeDuration,
    'volume': volume,
    'isToggled': isToggled.value ? 1 : 0,
  };

  factory Alarm.fromMap(Map<String, dynamic> map) => Alarm(
    id: map['id'],
    hour: map['hour'],
    minute: map['minute'],
    isAm: map['isAm'] == 1,
    label: map['label'],
    backgroundTitle: map['backgroundTitle'],
    backgroundImage: map['backgroundImage'],
    musicPath: map['musicPath'],
    recordingPath: map['recordingPath'],
    repeatDays: (map['repeatDays'] as String).split(','),
    isVibrationEnabled: map['isVibrationEnabled'] == 1,
    snoozeDuration: map['snoozeDuration'],
    volume: map['volume'],
    isToggled: map['isToggled'] == 1,
  );


}
