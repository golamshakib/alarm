import 'package:get/get.dart';

class SettingsController extends GetxController {

  var selectedTime = 12.obs;
  final List<int> timeFormat = [12, 24];

  void updateTime(int duration) {
    selectedTime.value = duration;
  }
}
