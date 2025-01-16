import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:alarm/features/alarm/audio%20test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // For audio file selection
import 'package:widgets_easier/widgets_easier.dart';
import 'dart:io';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/create_new_back_ground_alarm_controller.dart';

class CreateNewAlarmScreen extends StatelessWidget {
  const CreateNewAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateAlarmController controller = Get.put(CreateAlarmController());
    final ImagePicker picker =
        ImagePicker(); // Create an instance of ImagePicker

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){Get.to(()=> const AudioTest());}, child: Icon(Icons.add),),
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
                      Obx(() => controller.selectedImage.value == null
                          ? CustomText(
                              text: "Upload Background Image:",
                              fontSize: getWidth(16),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff333333),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Upload Background Image:",
                                  fontSize: getWidth(16),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff333333),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      try {
                                        final XFile? image =
                                            await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (image != null) {
                                          controller
                                              .pickImage(File(image.path));
                                        }
                                      } catch (e) {
                                        Get.snackbar(
                                            "Error", "Failed to pick image: $e",
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    },
                                    child: CustomText(
                                      text: "Change",
                                      color: const Color(0xffFFA845),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getWidth(16),
                                      decoration: TextDecoration.underline,
                                      decorationColor: const Color(0xffFFA845),
                                    ))
                              ],
                            )),

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
                      Obx(() => controller.selectedAudio.value == null
                          ? CustomText(
                              text: "Upload your tone:",
                              fontSize: getWidth(16),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff333333),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Upload Background Image:",
                                  fontSize: getWidth(16),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff333333),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      try {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.audio,
                                        );
                                        if (result != null &&
                                            result.files.single.path != null) {
                                          controller.pickAudio(
                                              File(result.files.single.path!));
                                        }
                                      } catch (e) {
                                        Get.snackbar(
                                            "Error", "Failed to pick audio: $e",
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    },
                                    child: CustomText(
                                      text: "Change",
                                      color: const Color(0xffFFA845),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getWidth(16),
                                      decoration: TextDecoration.underline,
                                      decorationColor: const Color(0xffFFA845),
                                    ))
                              ],
                            )),

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
                      /*GestureDetector(
                        onTap: () async {
                          try {
                            FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                              type: FileType.audio,
                            );
                            if (result != null && result.files.single.path != null) {
                              controller.pickAudio(File(result.files.single.path!));
                            }
                          } catch (e) {
                            Get.snackbar("Error", "Failed to pick audio: $e",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(() {
                            return controller.selectedAudio.value != null
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.audiotrack,
                                    color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  controller.selectedAudio.value!.path
                                      .split('/')
                                      .last,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                                : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.audiotrack, color: Colors.orange),
                                  Text("Upload your Audio file",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),*/
                      SizedBox(height: getHeight(8)),

                      // Record Your Tune
                      Center(
                          child: CustomText(
                        text: "Or",
                        color: const Color(0xffA59F92),
                        fontSize: getWidth(14),
                      )),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Record your tune:",
                            fontSize: getWidth(16),
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w600,
                          ),
                          Obx(() {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!controller.isRecording.value) {
                                      controller.startRecording();
                                    } else {
                                      controller.stopRecording();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const CustomText(
                                        text: "Record",
                                        color: Color(0xffFFA845),
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xffFFA845),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          if (controller.isRecordingNow.value) {
                                            controller.stopRecording();
                                          } else {
                                            controller.startRecording();
                                          }
                                        },
                                        child: controller
                                                    .isRecordingNow.value !=
                                                false
                                            ? Radio<bool>(
                                                value: true,
                                                activeColor:
                                                    const Color(0xffF34100),
                                                groupValue: controller
                                                    .isRecordingNow.value,
                                                onChanged: (value) {
                                                  if (value == true) {
                                                    controller.startRecording();
                                                  }
                                                },
                                              )
                                            : SizedBox(
                                                height: getHeight(30),
                                                width: getWidth(30),
                                                child: const CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      IconPath.recordingOnIcon),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(94),
                ),
                Obx(() => controller.selectedImage.value != null ||
                        controller.selectedAudio.value != null ||
                        controller.isRecordingNow.value != true
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: getHeight(12)),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: 'Save background',
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      )
                    : const Text("")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
