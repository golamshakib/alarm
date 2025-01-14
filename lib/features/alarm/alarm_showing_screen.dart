import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/constants/image_path.dart';
import '../add_alarm/controller/add_alarm_controller.dart';

class AlarmShowingScreen extends StatelessWidget {
  const AlarmShowingScreen({super.key, required this.alarm});

  final Alarm alarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(ImagePath.dog2,height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
            Positioned(
              bottom: getHeight(92),
              left: getWidth(50),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomText(text:  "${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')} ${alarm.isAm ? 'AM' : 'PM'}",color: Colors.white,fontSize: getWidth(40),fontWeight: FontWeight.w300,),
                      SizedBox(width: getWidth(16),),
                      Container(
                        height: getHeight(50),
                        width: getWidth(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: getWidth(16),),
                      CustomText(
                        text: alarm.repeatDays.isNotEmpty
                            ? "${alarm.repeatDays.first} to ${alarm.repeatDays.last}"
                            : "No Repeat Days",
                        fontSize: getWidth(14),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  
                  CustomText(
                    text: alarm.label,
                    fontSize: getWidth(48),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  SizedBox(height: getHeight(24),),
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8),

                      ),
                      child:  Center(child: Padding(
                        padding: EdgeInsets.only(left: getWidth(38),top: getHeight(15),right: getWidth(38),bottom: getHeight(15)),
                        child: const CustomText(text: "Snooze",color: AppColors.yellow,fontWeight: FontWeight.w600,),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
