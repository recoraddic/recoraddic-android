import 'package:flutter/material.dart';

// 기록 블록에 해당하는 클래스
class RecordBlock extends StatelessWidget {
  final double width;
  final double height;
  final Color blockColor;
  final BorderRadius? borderRadius;
  final Widget facialExpression;

  const RecordBlock({
    super.key,
    this.width = 75,
    this.height = 50,
    this.blockColor = Colors.brown,
    this.borderRadius,
    // 일단은 표정만 파라미터로 받자
    required this.facialExpression,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 2), // Offset in x and y directions
          ),
        ],
      ),
      child: Center(
        child: facialExpression,
      ),
    );
  }
}
