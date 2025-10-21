import 'package:flutter/material.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.forSurface(
        AppTextStyles.headerSmall.copyWith(letterSpacing: -0.5),
        context,
      ),
    );
  }
}
