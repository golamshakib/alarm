import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static final InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle:  TextStyle(
      fontSize: getWidth(14),
      color: Colors.black,
    ),
    hintStyle: TextStyle(
      fontSize: getWidth(14),
      color: Colors.black,
    ),
    errorStyle: TextStyle(
      fontSize: getWidth(12),
      color: Colors.red,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.black.withOpacity(0.8),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
          color: Colors.black), // You can replace with a specific color
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.orange),
    ),
  );

  static final InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(
      fontSize: getWidth(14),
      color: Colors.white,
    ),
    hintStyle: TextStyle(
      fontSize: getWidth(14),
      color: Colors.white70,
    ),
    errorStyle: TextStyle(
      fontSize: getWidth(12),
      color: Colors.redAccent,
    ),
    floatingLabelStyle: const TextStyle(
      color: Colors.white70,
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(
          color: Colors.white), // You can replace with a specific color
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.orangeAccent),
    ),
  );
}
