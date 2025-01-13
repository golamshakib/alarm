import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/change_back_ground_controller.dart';

class ChangeBackGroundAlarm extends StatelessWidget {
  const ChangeBackGroundAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeBackgroundController controller =
    Get.find<ChangeBackgroundController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: getWidth(16), right: getWidth(16)),
          child: Column(
            children: [
              CustomAppbarWithLogo(
                text: "Change background",
                showBackIcon: true,
                onBackTap: () {
                  Get.back();
                },
                iconPath: IconPath.addIconActive,
                onIconTap: () {
                  Get.toNamed(AppRoute.createNewAlarmScreen);
                },
              ),
              SizedBox(
                height: getHeight(24),
              ),
              Obx(() {
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: getHeight(12)),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xffF7F7F7),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {

                                    debugPrint("---------------------------------------------------------------");
                                    debugPrint("------------------------------------Tapped------------------------");
                                    controller.togglePlay(index);
                                  },
                                  child: Icon(
                                    controller.isPlaying[index]
                                        ? Icons.play_circle_fill_rounded
                                        : Icons.play_circle_outline_rounded,
                                    color: Colors.orange,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: getHeight(16),
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      text: item['title']!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff333333),
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                    if (controller.isPlaying[index]) ...[
                                      SizedBox(width: getWidth(8)),
                                      Container(
                                        width: getWidth(50),
                                        height: getHeight(50),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                item['extraImage'] ?? ''),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: getWidth(138),
                            height: getHeight(97),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(item['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
