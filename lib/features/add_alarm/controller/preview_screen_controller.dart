import 'package:get/get.dart';

class PreviewScreenController extends GetxController {

  RxBool isPlaying = false.obs;
  RxBool showExtraImage = false.obs; // Observable for extra image visibility

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    showExtraImage.value = isPlaying.value; // Show extra image when playing
  }
}
