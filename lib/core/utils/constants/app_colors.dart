import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF1E3A5F);
  static const Color secondary = Color(0xFFFEC601);
  static const Color yellow = Color(0xFFFFA845);
  static const Color accent = Color(0xFF89A7FF);
  static const Color black = Colors.black;

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xfffff9a9e),
      Color(0xFFFAD0C4),
      Color(0xFFFAD0C4),
    ],
  );



  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xff4D4A44);
  static const Color textGrey = Color(0xffA59F92);
  static const Color textYellow = Color(0xffFFAB4C);
  static const Color textWhite = Color(0xffF7F7F7);
  static const Color white = Colors.white;


  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color primaryBackground = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFE0E0E0);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Container Colors
  static const Color greyContainer = Color(0xFFF7F7F7);
  static const Color lightYellowContainer = Color(0xFFFFF5E1);
  static const Color yellowContainer = Color(0xFFFFA845);

  // Utility Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF29B6F6);
}