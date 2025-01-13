import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:alarm/features/add_alarm/controller/add_alarm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/common/widgets/custom_text.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAlarmController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(getWidth(16)),
          child: Column(
            children: [
              // App Bar
              const CustomAppbarWithLogo(
                text: 'My Alarms',
              ),
              const SizedBox(height: 24),

              // Alarms or "No Alarms" Message
              Expanded(
                child: Obx(() {
                  if (controller.alarms.isEmpty) {
                    // Display "No Alarms" message
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagePath.alarmImage,
                          height: getHeight(346),
                          width: getWidth(375),
                        ),
                        SizedBox(height: getHeight(10)),
                        CustomText(
                          text: 'No Alarms Set Yet!',
                          fontWeight: FontWeight.w700,
                          fontSize: getWidth(32),
                          color: AppColors.textGrey,
                        ),
                      ],
                    );
                  } else {
                    // Display list of alarms
                    return ListView.builder(
                      itemCount: controller.alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = controller.alarms[index];
                        return Container(
                          width: getWidth(600),
                          height: getHeight(200),

                          decoration:  BoxDecoration(
                           image: const DecorationImage(image: AssetImage(ImagePath.dog)),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(
                            color: const Color(0xffFFF5E1).withOpacity(0.4),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.play_circle_outline_rounded,color: Colors.orange,)),
                                 Obx(()=> AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: getWidth(37),
                                    height: getHeight(21),
                                    decoration: BoxDecoration(
                                      color: controller.isToggled.value
                                          ? const Color(0xffFA72D1)
                                          : const Color(0xffA3B2C7).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: AnimatedAlign(
                                      duration: const Duration(milliseconds: 300),
                                      alignment: controller.isToggled.value
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        width: getWidth(18),
                                        height: getHeight(18),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  )),
                                ],),
                                Text(
                                  "${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')} ${alarm.isAm ? 'AM' : 'PM'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: getWidth(36),
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: getHeight(15),),
                                Row(
                                  children: [
                                    CustomText(text: "${alarm.repeatDays.first} to ${alarm.repeatDays.last}",fontSize: getWidth(14),fontWeight: FontWeight.w400,color:const Color(0xffA59F92) ,),
                                    Image.asset(ImagePath.lineImage2,height: getHeight(20),width: getWidth(20),),
                                    SizedBox(width: getWidth(8),),
                            
                                    CustomText(text: alarm.label,fontSize: getWidth(14),fontWeight: FontWeight.w400,color:const Color(0xffA59F92) ,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
