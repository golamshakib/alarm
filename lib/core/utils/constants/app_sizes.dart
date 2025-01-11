import 'package:flutter/material.dart';

class AppSizes {
  static late MediaQueryData _mediaQueryData;
  static late double width;
  static late double height;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  double screenHeight() => AppSizes.height;
  double screenWidth() => AppSizes.width;
}

double screenHeight() => AppSizes.height;
double screenWidth() => AppSizes.width;

double getHeight(double inputHeight) {
  double screenHeight = AppSizes.height;
  var percent = ((screenHeight / 100) * inputHeight) / screenHeight;
  return (screenHeight * percent) / 10;
}

double getWidth(double inputWidth) {
  double screenWidth = AppSizes.width;
  return (inputWidth / 430) * screenWidth;
}
