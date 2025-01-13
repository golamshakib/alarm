import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // For audio file selection
import 'package:widgets_easier/widgets_easier.dart';
import 'dart:io';

import '../../controller/create_new_back_ground_alarm_controller.dart';

class CreateNewAlarmScreen extends StatelessWidget {
  const CreateNewAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateAlarmController controller = Get.put(CreateAlarmController());
    final ImagePicker picker = ImagePicker(); // Create an instance of ImagePicker

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              CustomAppbarWithLogo(text: "Create New",showBackIcon: true,onBackTap: (){
                Get.back();
              },),
               SizedBox(height: getHeight(24)),

              // Upload Background Image
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Upload Background Image:",fontSize: getWidth(16),fontWeight: FontWeight.w600,color: const Color(0xff333333),),

                    const SizedBox(height: 12),

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
                          shape: DashedBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Obx(() {
                            return controller.selectedImage.value != null
                                ? Image.file(
                              controller.selectedImage.value!,
                              fit: BoxFit.cover,
                            )
                                : const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text("Upload your image",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          })
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Upload Tone
                    const Text(
                      "Upload your tone:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
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
                    ),
                    const SizedBox(height: 16),

                    // Record Your Tune
                    const Center(child: Text("Or,")),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Record your tune:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          return ElevatedButton.icon(
                            onPressed: () {
                              if (controller.isRecording.value) {
                                controller.stopRecording();
                              } else {
                                controller.startRecording();
                              }
                            },
                            icon: Icon(
                              controller.isRecording.value
                                  ? Icons.stop
                                  : Icons.mic,
                              color: Colors.white,
                            ),
                            label: Text(controller.isRecording.value
                                ? "Stop"
                                : "Record"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
