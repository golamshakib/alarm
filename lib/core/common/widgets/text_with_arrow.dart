import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:alarm/core/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'custom_text.dart'; // Import your CustomText widget

class TextWithArrow extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final TextOverflow? textOverflow;
  final Color? color;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;

  const TextWithArrow({
    super.key,
    this.text,
    this.fontSize,
    this.textOverflow,
    this.color,
    this.fontWeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CustomText Widget
          Flexible(
            child: CustomText(
              text: text ?? '',
              fontSize: fontSize ?? getWidth(14),
              textOverflow: TextOverflow.ellipsis,
              color: AppColors.textGrey,
              fontWeight: fontWeight ?? FontWeight.w400
            ),
          ),
          SizedBox(width: getWidth(8)),
          // Arrow Icon
          Icon(
            Icons.arrow_forward_ios,
            size: getWidth(16),
            color: AppColors.textGrey,
          ),
        ],
      ),
    );
  }
}
