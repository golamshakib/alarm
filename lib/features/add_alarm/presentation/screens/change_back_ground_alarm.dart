import 'package:alarm/features/add_alarm/presentation/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/change_back_ground_controller.dart';

class ChangeBackGroundAlarm extends StatelessWidget {
  const ChangeBackGroundAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeBackgroundController controller = Get.find<ChangeBackgroundController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
          child: Column(
            children: [
              CustomAppbarWithLogo(
                text: "Change background",
                showBackIcon: true,
                iconPath: IconPath.addIconActive,
                onIconTap: () {
                  Get.toNamed(AppRoute.createNewAlarmScreen);
                },
              ),
              SizedBox(height: getHeight(24)),
              Expanded(
                child: Obx(() {
                  return ListView.separated(
                    itemCount: controller.items.length,
                    separatorBuilder: (_, __) => SizedBox(height: getHeight(12)),
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PreviewScreen(
                            title: item['title']!,
                            image: item['image']!,
                            musicUrl: item['extraImage'] ?? '',
                          ));
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xffF7F7F7),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.togglePlay(index);
                                      },
                                      child: Obx(() {
                                        return Row(
                                          children: [
                                            Icon(
                                              controller.isPlaying[index]
                                                  ? Icons.play_circle_fill_rounded
                                                  : Icons.play_circle_outline_rounded,
                                              color: Colors.orange,
                                              size: 25,
                                            ),
                                            if (controller.isPlaying[index]) ...[
                                              SizedBox(width: getWidth(8)),
                                              Image.asset(item['extraImage'] ?? '', height: getHeight(25), width: getWidth(75),),
                                            ],
                                          ],
                                        );
                                      }),
                                    ),
                                    SizedBox(height: getHeight(16)),
                                    CustomText(
                                      text: item['title']!,
                                      fontSize: getWidth(14),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff333333),
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                // width: getWidth(100),
                                // height: getHeight(100),
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    image:AssetImage(item['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
