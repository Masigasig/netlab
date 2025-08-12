import 'package:flutter/material.dart';
import 'package:netlab/core/constants/app_colors.dart';
import 'package:netlab/core/components/gradient_border.dart'; // Import your new widget

class ButtonStyle extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const ButtonStyle({
    super.key,
    required this.text,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBorder(
      borderRadius: 30,
      borderWidth: 2,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}