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
  static const TextStyle tinyLightGreyText = TextStyle(
    color: AppColors.lightGreyColor,
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
}

class AppConstants {
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
            style: AppFonts.smallWhiteText,
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
            style: AppFonts.smallWhiteText,
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
            style: AppFonts.smallWhiteText,
          ),
        ),
      ],
    );
  }
}
