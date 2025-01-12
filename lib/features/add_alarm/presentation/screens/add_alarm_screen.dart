import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/common/widgets/text_with_arrow.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/add_alarm_controller.dart';

class AddAlarmScreen extends StatelessWidget {
  const AddAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddAlarmController controller = Get.put(AddAlarmController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                CustomAppbarWithLogo(
                  text: 'Add Alarm',
                  iconPath: IconPath.check,
                ),

                // Time Picker
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.yellowContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Hour Dropdown
                      Obx(() => DropdownButton<int>(
                        value: controller.selectedHour.value,
                        items: List.generate(12, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              (index + 1).toString(),
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(30),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedHour.value = value;
                          }
                        },
                        dropdownColor: AppColors.yellowContainer,

                        menuMaxHeight: 200,
                      )),

                      // Minute Dropdown
                      Obx(() => DropdownButton<int>(
                        value: controller.selectedMinute.value,
                        items: List.generate(60, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(30),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedMinute.value = value;
                          }
                        },
                        dropdownColor: AppColors.yellowContainer,
                        menuMaxHeight: 200,
                      )),

                      // AM/PM Dropdown
                      Obx(() => DropdownButton<bool>(
                        value: controller.isAm.value,
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              "am",
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(30),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              "pm",
                              style: GoogleFonts.poppins(
                                fontSize: getWidth(30),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.isAm.value = value;
                          }
                        },
                        dropdownColor: AppColors.yellowContainer,
                        menuMaxHeight: 150,
                      )),
                    ],
                  ),
                ),


                // Background Section
                Container(
                  padding: EdgeInsets.all(getWidth(16)),
                  decoration: BoxDecoration(
                    color: AppColors.greyContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Background Info
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'Background:'),
                          TextWithArrow(text: 'Cute Dog in bed'),
                        ],
                      ),
                      SizedBox(height: getHeight(16)),
                      Image.asset(ImagePath.dog),
                      SizedBox(height: getHeight(24)),

                      // Repeat Section
                      const CustomText(text: 'Repeat:'),
                      SizedBox(height: getHeight(8)),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: controller.repeatDays.keys.map((day) {
                            final isSelected = controller.repeatDays[day]!;
                            return GestureDetector(
                              onTap: () {
                                controller.toggleDay(day);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.yellow
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CustomText(
                                  text: day,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.yellow,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),

                      SizedBox(height: getHeight(30)),

                      // Label Section
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'Label:'),
                          TextWithArrow(text: 'Morning Alarm'),
                        ],
                      ),

                      SizedBox(height: getHeight(24)),

                      // Snooze Section
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'Snooze:'),
                          TextWithArrow(text: '10 Minute'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(text: 'Vibration:'),
                          Obx(
                            () => Switch(
                              value: controller.vibrationEnabled.value,
                              onChanged: controller.toggleVibration,
                              activeColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Volume Label
                          const CustomText(
                            text:  'Volume:'),
                          SizedBox(width: getWidth(100)),
                          Expanded(
                            child: Obx(() {
                              return Slider(
                                value: controller.volume.value,
                                min: 0,
                                max: 100,
                                // divisions: 10,
                                onChanged: controller.setVolume,
                                activeColor: Colors.orange,
                              );
                            }),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(height: getHeight(24)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
