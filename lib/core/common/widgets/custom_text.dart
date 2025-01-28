import 'package:alarm/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/app_sizes.dart';



class CustomText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  const CustomText(
      {super.key,
      required this.text, this.textAlign,
      this.maxLines,
      this.textOverflow,
      this.fontSize,
      this.color,
        this.fontWeight, this.decoration, this.decorationColor });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        decoration:decoration,
          decorationColor: decorationColor??const Color(0xffA59F92),
          fontSize: fontSize ?? getWidth(16),
          color: color ?? AppColors.textPrimary,
          fontWeight: fontWeight ?? FontWeight.w600),
      overflow: textOverflow,
      maxLines: maxLines,

    );
  }
}
