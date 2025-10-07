import 'dart:developer';
import 'dart:io';

import 'package:alarm/features/add_alarm/presentation/screens/local_background_screen.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/db_helpers/db_helper_local_background.dart';

class CreateNewBackgroundController extends GetxController {
  ImagePicker picker = ImagePicker();
  Rx<String> labelText = ''.obs;

  /// -- P L A Y   M U S I C

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  RxBool isPlaying = false.obs;
  RxInt playingIndex = (-1).obs;
  RxString musicHoverMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBackgroundsFromDB();
  }

  void addItem(Map<String, dynamic> item) {
    items.add(item);
  }

  ///---- Fetch Data from Local Storage ----///

  Future<void> fetchBackgroundsFromDB() async {
    final dbHelper = DBHelperMusic();
    try {
      final data = await dbHelper.fetchBackgrounds();

      items.value = data.toList();
      log('Fetched backgrounds: $items');
    } catch (e) {
      log('Error fetching backgrounds: $e');
    }
  }

  ///---- End  Fetch Data from Local Storage ----///

  Future<void> playMusic(int index) async {
    final item = items[index];
    final filePath = item['musicPath'] ?? item['recordingPath'];

    if (filePath == null || !File(filePath).existsSync()) {
      musicHoverMessage.value = "Aucun fichier audio trouvé !";

      return;
    }

    try {
      if (playingIndex.value == index && isPlaying.value) {
        isPlaying.value = false;
        await audioPlayer.pause();
      } else {
        if (playingIndex.value != -1 && playingIndex.value != index) {
          await audioPlayer.stop();
        }

        // Play the new track
        isPlaying.value = true;
        playingIndex.value = index;
        Get.forceAppUpdate();
        await audioPlayer.setFilePath(filePath);
        await audioPlayer.play();
      }
    } catch (e) {
      musicHoverMessage.value =
          "Échec de la lecture audio: $e";
    }
  }

  /// -- E N D  P L A Y   M U S I C

  void stopMusic() async {
    if (isPlaying.value) {
      await audioPlayer.stop();
      isPlaying.value = false;
      if (playingIndex.value != -1) {
      }
      playingIndex.value = -1;
    }
  }

  /// -- S T A R T   R E C O R D I N G

  final PlayerController playerController = PlayerController();
  Rx<String?> musicPath = Rx<String?>(null);
  RxBool isMusicDisabled = false.obs;

  /// -- E N D   R E C O R D I N G

  /// -- P I C K    I M A G E    A N D    M U S I C

  Rx<String?> imagePath = Rx<String?>(null);
  RxBool isImageSelected = false.obs;


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      isImageSelected.value = true;
    } else {
      imagePath.value = null;
    }
  }

  RxBool isMusicSelected = false.obs;

  Future<void> pickMusic() async {
    if (isMusicDisabled.value) {
      musicHoverMessage.value =
          "L'enregistrement est en cours ou terminé. Réinitialiser pour activer la sélection musicale.";
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      musicPath.value = result.files.single.path;
      isMusicSelected.value = true;
      musicHoverMessage.value = "Fichier musical sélectionné avec succès";
    }
  }

  /// -- E N D   P I C K    I M A G E    A N D    M U S I C

  void saveData({int? id}) async {
    if (!isImageSelected.value) {
      Get.snackbar("Erreur", "Veuillez sélectionner une image avant d'enregistrer l'arrière-plan.",
          duration: const Duration(seconds: 2));
      return;
    }
    if (!isMusicSelected.value) {
      Get.snackbar(
          "Erreur", "Veuillez sélectionner un fichier musical avant d'enregistrer l'arrière-plan",
          duration: const Duration(seconds: 2));
      return;
    }

    final result = {
      'title':
          labelText.value.isNotEmpty ? labelText.value : "Titre de l'arrière-plan",
      'imagePath': imagePath.value,
      'musicPath': musicPath.value,
      'type': musicPath.value != null ? 'musique' : 'recording',
    };

    final dbHelper = DBHelperMusic();

    try {
      if (id != null) {
        int rowsUpdated = await dbHelper.updateBackground(result, id);
        if (rowsUpdated > 0) {
          Get.snackbar("Succès", "L'arrière-plan a été mis à jour avec succès !",
              duration: const Duration(seconds: 2));
          int indexToUpdate =
              items.indexWhere((element) => element['id'] == id);
          if (indexToUpdate != -1) {
            items[indexToUpdate] = {...result, 'id': id};
            items.refresh();
          }
        } else {
          Get.snackbar("Erreur", "Échec de la mise à jour de l'arrière-plan.",
              duration: const Duration(seconds: 2));
        }
      } else {
        await dbHelper.insertBackground(result);
        addItem(result);
        Get.snackbar("Succès", "Sauvegarder avec succès",
            duration: const Duration(seconds: 2));
      }

      resetFields();

      Get.off(const LocalBackgroundScreen(), arguments: result);
    } catch (e) {
      log('Error saving data: $e');
      Get.snackbar("Erreur", "Échec de l'enregistrement de l'arrière-plan: $e",
          duration: const Duration(seconds: 2));
    }
  }

  void resetFields() {
    labelText.value = '';
    imagePath.value = null;
    musicPath.value = null;
    isMusicDisabled.value = false;
    playerController.stopPlayer();
    musicHoverMessage.value = "";
  }
  @override
  void onClose() {
    stopMusic();
    audioPlayer.dispose();
    super.onClose();
  }
}
