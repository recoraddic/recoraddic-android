import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBlueColor = Color.fromRGBO(0, 122, 255, 0.7);
  static const Color darkBlueColor = Color.fromRGBO(0, 122, 255, 0.3);
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGreyColor = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color middleGreyColor = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color darkGreyColor = Color.fromRGBO(255, 255, 255, 0.05);
}

class AppFonts {
  static const TextStyle bigWhiteText = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 30,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    height: 1.6,
  );
  static const TextStyle middleWhiteText = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 24,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
  static const TextStyle smallWhiteText = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 18,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
  static const TextStyle smallLightGreyText = TextStyle(
    color: AppColors.lightGreyColor,
    fontSize: 18,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
}

class AppConstants {
  static const double bigPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double bigBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double bigBoxSize = 32.0;
  static const double smallBoxSize = 16.0;
}
