class AlarmModel {
  final int hour;
  final int minute;
  final bool isAm;
  final String label;
  final String backgroundName;
  final String backgroundImage;
  final List<String> repeatDays;
  final bool vibrationEnabled;
  final int snoozeDuration;
  final double volume;

  AlarmModel({
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.label,
    required this.backgroundName,
    required this.backgroundImage,
    required this.repeatDays,
    required this.vibrationEnabled,
    required this.snoozeDuration,
    required this.volume,
  });
}
