import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBlueColor = Color.fromRGBO(0, 122, 255, 0.7);
  static const Color darkBlueColor = Color.fromRGBO(0, 122, 255, 0.3);
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGreyColor = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color middleGreyColor = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color darkGreyColor = Color.fromRGBO(255, 255, 255, 0.05);

  // 기록보관함 배경 색상
  // static const Color recordBackground = Color.fromRGBO(100, 181, 246, 1);
  static const Color recordBackground = Color.fromRGBO(44, 62, 80, 0.7);


  // 목표 배경 색상
  // static const Color goalBackground = Color.fromRGBO(129, 199, 132, 1);
  static const Color goalBackground =  Color.fromRGBO(60, 110, 60, 0.7);

  // 골 목록 색상
  static const Color goalBlock = Color.fromRGBO(200, 230, 201, 0.7);
}

class FontSize {
  static double scaleFont(BuildContext context, double fontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Adjust the factor as needed, usually a value between 0.001 to 0.002
    return fontSize * screenWidth * 0.002;
  }
}

class AppFonts {
  static TextStyle bigWhiteText(BuildContext context) {
    return TextStyle(
      color: AppColors.whiteColor,
      fontSize: FontSize.scaleFont(context, 30),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      height: 1.6,
    );
  }
  static TextStyle middleWhiteText(BuildContext context) {
    return TextStyle(
    color: AppColors.whiteColor,
    fontSize: FontSize.scaleFont(context, 24),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
  }
  static TextStyle smallWhiteText(BuildContext context) {
    return TextStyle(
    color: AppColors.whiteColor,
    fontSize: FontSize.scaleFont(context, 18),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
  }
  static TextStyle smallLightGreyText(BuildContext context) {
    return TextStyle(
      color: AppColors.lightGreyColor,
      fontSize: FontSize.scaleFont(context, 18),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      height: 1.6,
  );
  }
  static TextStyle tinyLightGreyText(BuildContext context) {
    return TextStyle(
      color: AppColors.lightGreyColor,
      fontSize: FontSize.scaleFont(context, 14),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      height: 1.6,
  );
  }
}

class AppConstants {
  static const double topPadding = 50.0;
  static const double bigPadding = 16.0;
  static const double middlePadding = 12.0;
  static const double smallPadding = 8.0;
  static const double bigBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double bigBoxSize = 32.0;
  static const double smallBoxSize = 16.0;
}

class OneButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const OneButtonWidget(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallBoxSize),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBlueColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.bigBorderRadius),
            ),
          ),
          child: Text(
            buttonText,
            style: AppFonts.smallWhiteText(context),
          ),
        ),
      ],
    );
  }
}

class TwoButtonWidget extends StatelessWidget {
  final String buttonText1;
  final VoidCallback onPressed1;
  final String buttonText2;
  final VoidCallback onPressed2;

  const TwoButtonWidget({
    super.key,
    required this.buttonText1,
    required this.onPressed1,
    required this.buttonText2,
    required this.onPressed2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onPressed1,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBlueColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.bigBorderRadius),
            ),
          ),
          child: Text(
            buttonText1,
            style: AppFonts.smallWhiteText(context),
          ),
        ),
        const SizedBox(width: AppConstants.smallBoxSize),
        ElevatedButton(
          onPressed: onPressed2,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBlueColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.bigBorderRadius),
            ),
          ),
          child: Text(
            buttonText2,
            style: AppFonts.smallWhiteText(context),
          ),
        ),
      ],
    );
  }
}

