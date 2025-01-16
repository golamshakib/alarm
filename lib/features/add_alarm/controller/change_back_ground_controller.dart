import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';

class ChangeBackgroundController extends GetxController {
  var items = [
    {'title': 'Cute Dog in bed', 'image': ImagePath.dog3,'extraImage': ImagePath.extraImage,},
    {'title': 'Cute Cat under blanket', 'image': ImagePath.dog2,'extraImage': ImagePath.extraImage,},
    {'title': 'Cute Bird over sink', 'image': ImagePath.dog3,'extraImage': ImagePath.extraImage,},
    {'title': 'Cute Dog in bed', 'image': ImagePath.dog3,'extraImage': ImagePath.extraImage,},
    {'title': 'Cute Dog in bed', 'image': ImagePath.dog3,'extraImage': ImagePath.extraImage,},
    {'title': 'Cute Cat under blanket', 'image': ImagePath.dog3,'extraImage': ImagePath.extraImage,},
  ].obs;

  var isPlaying = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    isPlaying.value = List.generate(items.length, (_) => false);
  }

  void togglePlay(int index) {
    for (int i = 0; i < isPlaying.length; i++) {
      isPlaying[i] = (i == index) ? !isPlaying[i] : false;
    }
    isPlaying.refresh(); // Notify observers to rebuild
  }
}