import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

class AppTextTheme {
  AppTextTheme._();

  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: getWidth(57),
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: getWidth(45),
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    displaySmall: TextStyle(
      fontSize: getWidth(36),
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    headlineLarge: TextStyle(
      fontSize: getWidth(32),
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: getWidth(28),
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle(
      fontSize: getWidth(24),
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleLarge: TextStyle(
      fontSize: getWidth(22),
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontSize: getWidth(16),
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleSmall: TextStyle(
      fontSize: getWidth(14),
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(
      fontSize: getWidth(16),
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: getWidth(14),
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontSize: getWidth(12),
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
    labelLarge: TextStyle(
      fontSize: getWidth(14),
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontSize: getWidth(12),
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    ),
    labelSmall: TextStyle(
      fontSize: getWidth(11),
      fontWeight: FontWeight.w500,
      color: Colors.black45,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: getWidth(57),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: getWidth(45),
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    displaySmall: TextStyle(
      fontSize: getWidth(36),
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    headlineLarge: TextStyle(
      fontSize: getWidth(32),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: getWidth(28),
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    headlineSmall: TextStyle(
      fontSize: getWidth(24),
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    titleLarge: TextStyle(
      fontSize: getWidth(22),
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    titleMedium: TextStyle(
      fontSize: getWidth(16),
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    titleSmall: TextStyle(
      fontSize: getWidth(14),
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    bodyLarge: TextStyle(
      fontSize: getWidth(16),
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    bodyMedium: TextStyle(
      fontSize: getWidth(14),
      fontWeight: FontWeight.normal,
      color: Colors.white60,
    ),
    bodySmall: TextStyle(
      fontSize: getWidth(12),
      fontWeight: FontWeight.normal,
      color: Colors.white54,
    ),
    labelLarge: TextStyle(
      fontSize: getWidth(14),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: getWidth(12),
      fontWeight: FontWeight.w500,
      color: Colors.white60,
    ),
    labelSmall: TextStyle(
      fontSize: getWidth(11),
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    ),
  );
}
