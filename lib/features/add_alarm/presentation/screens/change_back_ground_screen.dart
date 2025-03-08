import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/features/add_alarm/presentation/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar_with_logo.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/change_back_ground_screen_controller.dart';

class ChangeBackGroundScreen extends StatelessWidget {
  const ChangeBackGroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeBackgroundScreenController controller = Get.put(ChangeBackgroundScreenController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbarWithLogo(
                text: "Change background",
                showBackIcon: true,
                onBackTap: () async {
                  controller.stopMusic();
                  Get.back();
                },
              ),
              SizedBox(height: getHeight(24)),
              InkWell(
                onTap: (){
                  controller.stopMusic();
                  Get.toNamed(AppRoute.localBackgroundScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: 'Local Background', fontSize: getWidth(18)),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: getWidth(16),
                      color: AppColors.textGrey,
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(24)),

              // First ListView for `items`
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller
                        .fetchBackgroundsFromNetwork(); // Reload custom backgrounds
                  },
                  child: Obx(() {
                    if (controller.items.isEmpty) {
                      return const Center(
                          child: CustomText(text: 'No Backgrounds Found'));
                    }
                    return ListView.separated(
                      itemCount: controller.items.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: getHeight(12)),
                      itemBuilder: (context, index) {
                        final item = controller.items[index];
                        return GestureDetector(
                          onTap: () {
                            controller.stopMusic();
                            Get.to(() => PreviewScreen(
                                  title: item['title'] ?? '',
                                  imagePath: item['imagePath'] ?? '',
                                  musicPath: item['musicPath'] ?? '',
                                ));
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xffF7F7F7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.togglePlay(index);
                                        },
                                        child: Obx(() {
                                          return Icon(
                                            controller.isPlaying[index]
                                                ? Icons.play_circle_fill_rounded
                                                : Icons
                                                    .play_circle_outline_rounded,
                                            color: Colors.orange,
                                            size: 25,
                                          );
                                        }),
                                      ),
                                      SizedBox(height: getHeight(16)),
                                      CustomText(
                                        text: item['title'] ?? '',
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
                                  width: getWidth(100),
                                  height: getHeight(120),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      item['imagePath'] ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          ImagePath.cat,
                                          fit: BoxFit.cover,
                                        );
                                      },
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
              ),
              SizedBox(height: getHeight(24)),
            ],
          ),
        ),
      ),
    );
  }
}
