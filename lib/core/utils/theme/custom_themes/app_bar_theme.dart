import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_sizes.dart';

class App_BarTheme {
  App_BarTheme._();

  static final AppBarTheme lightAppBarTheme = AppBarTheme(
    foregroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),

    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: getWidth(20),
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(color: Colors.black),
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.dark, // Control status bar color and icons
  );

  static final AppBarTheme darkAppBarTheme = AppBarTheme(
    foregroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    backgroundColor: Colors.grey[900],
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: getWidth(20),
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(color: Colors.white),
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light, // Control status bar color and icons
  );
}
