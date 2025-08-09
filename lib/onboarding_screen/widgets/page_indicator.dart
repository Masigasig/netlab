import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const PageIndicator({super.key, required this.currentIndex, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentIndex ? 12 : 8,
          height: index == currentIndex ? 12 : 8,
          decoration: BoxDecoration(
            color: index == currentIndex ? AppColors.active : AppColors.inactive,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}