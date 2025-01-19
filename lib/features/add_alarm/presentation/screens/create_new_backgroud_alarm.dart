
import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:widgets_easier/widgets_easier.dart';
import 'dart:io';

import '../../../alarm/audio_test/previous_screen.dart';
import '../../controller/create_new_back_ground_alarm_controller.dart';
import '../../widgets/record_tune_section.dart';
import '../../widgets/save_background_button_section.dart';
import '../../widgets/upload_background_image_section.dart';
import '../../widgets/upload_tone_section.dart';
import '../../widgets/wave_form_section.dart';

class CreateNewAlarmScreen extends StatelessWidget {
  const CreateNewAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateAlarmController controller = Get.put(CreateAlarmController());
    final ImagePicker picker =
        ImagePicker(); // Create an instance of ImagePicker

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(() => const PreviousScreen());
      }, child: const Icon(Icons.mic),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                CustomAppbarWithLogo(
                  text: "Create New",
                  showBackIcon: true,
                  onBackTap: () {
                    Get.back();
                  },
                ),
                SizedBox(height: getHeight(24)),

                // Upload Background Image
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Background Title:",
                        fontSize: getWidth(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff333333),
                      ),
                      SizedBox(height: getHeight(16)),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(10)),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: controller.titleController,
                          decoration: InputDecoration(
                            hintText: 'Background title',
                            hintStyle: GoogleFonts.poppins(color: const Color(0xffA59F92), fontSize: getWidth(14)),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(height: getHeight(16)),

                      UploadBackgroundImageSection(controller: controller, picker: picker),

                      SizedBox(height: getHeight(16)),

                      GestureDetector(
                        onTap: () async {
                          try {
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              controller.pickImage(File(image.path));
                            }
                          } catch (e) {
                            Get.snackbar("Error", "Failed to pick image: $e",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            color: const Color(0xffFFFFFF),
                            shape: DashedBorder(
                              color: const Color(0xffA59F92),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Obx(() {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: controller.selectedImage.value != null
                                  ? Image.file(
                                      controller.selectedImage.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: getHeight(48),
                                              width: getWidth(48),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color(0xffFFF8F1),
                                                child: Center(
                                                    child: SizedBox(
                                                        height: getWidth(18),
                                                        width: getWidth(18),
                                                        child: Image.asset(IconPath
                                                            .imageUploadIcon))),
                                              )),
                                          SizedBox(
                                            width: getWidth(8),
                                          ),
                                          CustomText(
                                            text: "Upload your image",
                                            color: const Color(0xffA59F92),
                                            fontWeight: FontWeight.w400,
                                            fontSize: getWidth(14),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ],
                                      ),
                                    ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: getHeight(24)),
                      UploadToneSection(controller: controller),

                      // Upload Tone

                      SizedBox(height: getHeight(16)),
                      GestureDetector(
                        onTap: () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.audio,
                            );
                            if (result != null &&
                                result.files.single.path != null) {
                              controller
                                  .pickAudio(File(result.files.single.path!));
                            }
                          } catch (e) {
                            Get.snackbar("Error", "Failed to pick audio: $e",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            color: const Color(0xffFFFFFF),
                            shape: DashedBorder(
                              color: const Color(0xffA59F92),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Obx(() {
                            return controller.selectedAudio.value != null
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: getHeight(48),
                                            width: getWidth(48),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  const Color(0xffFFF8F1),
                                              child: Center(
                                                  child: SizedBox(
                                                      height: getWidth(18),
                                                      width: getWidth(18),
                                                      child: Image.asset(IconPath
                                                          .fileUploadIcon))),
                                            )),
                                        SizedBox(
                                          width: getWidth(8),
                                        ),
                                        SizedBox(
                                          width: getWidth(253),
                                          child: CustomText(
                                            text: controller
                                                .selectedAudio.value!.path
                                                .split('/')
                                                .last,
                                            color: const Color(0xff333333),
                                            textOverflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: getHeight(48),
                                            width: getWidth(48),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  const Color(0xffFFF8F1),
                                              child: Center(
                                                  child: SizedBox(
                                                      height: getWidth(18),
                                                      width: getWidth(18),
                                                      child: Image.asset(IconPath
                                                          .fileUploadIcon))),
                                            )),
                                        SizedBox(
                                          width: getWidth(8),
                                        ),
                                        CustomText(
                                          text: "Upload your Audio file",
                                          fontSize: getWidth(14),
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xffA59F92),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ],
                                    ),
                                  );
                          }),
                        ),
                      ),

                      SizedBox(height: getHeight(8)),

                      // Record Your Tune
                      Center(
                          child: CustomText(
                        text: "Or",
                        color: const Color(0xffA59F92),
                        fontSize: getWidth(14),
                      )),

                      const SizedBox(height: 16),
                      RecordTuneSection(controller: controller),
                      WaveFormSection(controller: controller),
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(50),
                ),
                SaveBackgroundButtonSection(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

