import 'package:alarm/core/common/widgets/custom_appbar_with_logo.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';

import '../../core/common/widgets/custom_text.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(getWidth(16)),
          child: Column(
            children: [
              const CustomAppbarWithLogo(
                text: 'My Alarms',
              ),
              const Spacer(),
              Column(
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
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
