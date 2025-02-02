
import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widgets_easier/widgets_easier.dart';
import 'dart:io';

import '../../controller/create_new_back_ground_screen_controller.dart';
import '../../widgets/save_background_button_section.dart';
import '../../widgets/upload_background_image_section.dart';
import '../../widgets/upload_tone_section.dart';

class CreateNewBackgroundScreen extends StatelessWidget {
  const CreateNewBackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Fetch the arguments
    final Map<String, dynamic>? arguments = Get.arguments;
    final int? id = arguments?['id'];
    final String? title = arguments?['title'];
    final String? imagePath = arguments?['imagePath'];
    final String? musicPath = arguments?['musicPath'];
    // final String? recordingPath = arguments?['recordingPath'];

    final CreateNewBackgroundController controller = Get.put(CreateNewBackgroundController());

    // Pre-fill the fields if arguments are provided
    if (title != null) controller.labelText.value = title;
    if (imagePath != null) controller.imagePath.value = imagePath;
    if (musicPath != null) controller.musicPath.value = musicPath;
    // if (recordingPath != null) controller.recordingPath.value = recordingPath;

    return Scaffold(
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
                  iconPath: IconPath.deleteIcon,
                  onIconTap: (){
                    controller.resetFields();
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
                          initialValue: title, // Pre-fill with the passed title
                          onChanged: (value) {
                            controller.labelText.value = value;
                          },
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

                      UploadBackgroundImageSection(controller: controller, picker: controller.picker),

                      SizedBox(height: getHeight(16)),

                      GestureDetector(
                        onTap: ()  {controller.pickImage();},
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
                              child: controller.imagePath.value != null
                                  ? Image.file(
                                File(controller.imagePath.value!), // Create a File object here
                                fit: BoxFit.cover,
                              )
                                  : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: getHeight(48),
                                      width: getWidth(48),
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xffFFF8F1),
                                        child: Center(
                                          child: SizedBox(
                                            height: getWidth(18),
                                            width: getWidth(18),
                                            child: Image.asset(IconPath.imageUploadIcon),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getWidth(8),
                                    ),
                                    CustomText(
                                      text: "Upload your image",
                                      color: const Color(0xffA59F92),
                                      fontWeight: FontWeight.w400,
                                      fontSize: getWidth(14),
                                      decoration: TextDecoration.underline,
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
                      Obx(() => Tooltip(
                        message: controller.musicHoverMessage.value.isNotEmpty
                            ? controller.musicHoverMessage.value
                            : "Pick an audio file",
                          child: GestureDetector(
                            onTap: controller.isMusicDisabled.value
                                ? null // Disable interaction if isMusicDisabled is true
                                : () async {
                              controller.pickMusic();
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
                                return controller.musicPath.value != null
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
                                                    .musicPath.value!
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
                                        child: Opacity(
                                          opacity: controller.isMusicDisabled.value ? 0.5 : 1.0, // Visual indication
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: getHeight(48),
                                                  width: getWidth(48),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    controller.isMusicDisabled.value
                                                        ? Colors.grey // Change text color when disabled
                                                        : const Color(0xffFFF8F1),
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
                                                color: controller.isMusicDisabled.value
                                                    ? Colors.grey // Change text color when disabled
                                                      : const Color(0xffA59F92),
                                                decoration: TextDecoration.underline,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              }),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: getHeight(8)),

                      // Record Your Tune
                      // Center(
                      //     child: CustomText(
                      //   text: "Or",
                      //   color: const Color(0xffA59F92),
                      //   fontSize: getWidth(14),
                      // )),

                      const SizedBox(height: 16),
                      // RecordTuneSection(controller: controller),
                      // WaveFormSection(controller: controller),
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(50),
                ),
                SaveBackgroundButtonSection(controller: controller, id: id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

