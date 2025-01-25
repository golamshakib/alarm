import 'package:alarm/core/common/widgets/custom_text.dart';
import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbarWithLogo extends StatelessWidget {
  final String? profileImagePath;
  final String? text;
  final TextStyle? messageTextStyle;
  final String? subText;
  final TextStyle? subTextStyle;
  final String? iconPath;
  final VoidCallback? onIconTap;
  final VoidCallback? onBackTap;
  final Color? notificationBackgroundColor;
  final double? avatarSize;
  final double? spacing;
  final double? iconSize;
  final Color? iconPathColor;
  final bool showBackIcon;

  const CustomAppbarWithLogo({
    super.key,
    this.profileImagePath,
    this.text,
    this.messageTextStyle,
    this.subText,
    this.subTextStyle,
    this.iconPath,
    this.onIconTap,
    this.onBackTap,
    this.notificationBackgroundColor,
    this.avatarSize,
    this.spacing,
    this.iconSize,
    this.iconPathColor,
    this.showBackIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (showBackIcon)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: (iconSize ?? getWidth(24)),
                  ),
                  onPressed: onBackTap ?? () => Get.back(),
                ),
              if (profileImagePath != null)
                SizedBox(
                  height: (avatarSize ?? getHeight(45)),
                  width: (avatarSize ?? getHeight(45)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(profileImagePath!),
                  ),
                ),
              SizedBox(width: spacing ?? getWidth(12)),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (text != null)
                        CustomText(
                          text: text!,
                          fontSize: getWidth(24),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      if (subText != null)
                        SizedBox(height: getHeight(4)),
                      if (subText != null)
                        CustomText(
                         text: subText!,
                          fontSize: getWidth(14),
                          fontWeight: FontWeight.w400,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (iconPath != null)
          GestureDetector(
            onTap: onIconTap,
            child: Center(
              child: Image.asset(
                iconPath!,
                color: iconPathColor,
                height: (iconSize ?? getWidth(24)),
                width: (iconSize ?? getWidth(24)),
              ),
            ),
          ),
      ],
    );
  }

}
