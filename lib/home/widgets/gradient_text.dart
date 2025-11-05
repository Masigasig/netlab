import 'package:flutter/material.dart';
import '../../temp/core/constants/app_text.dart';

class CustomGradientText extends StatelessWidget {
  final String text;
  final List<String> gradientWords;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double? height;
  final double? letterSpacing;
  final List<Color> gradientColors;
  final Color defaultColor;

  const CustomGradientText({
    super.key,
    required this.text,
    this.gradientWords = const [],
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.center,
    this.height,
    this.letterSpacing,
    required this.gradientColors,
    required this.defaultColor,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.custom(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(color: defaultColor);

    final gradientShader = LinearGradient(
      colors: gradientColors,
    ).createShader(const Rect.fromLTWH(0, 0, 300, 70));

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: baseStyle,
        children: _buildTextSpans(baseStyle, gradientShader),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(TextStyle baseStyle, Shader gradientShader) {
    final words = text.split(' ');

    return words.asMap().entries.map((entry) {
      final index = entry.key;
      final word = entry.value;
      final isLast = index == words.length - 1;

      final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
      final isGradient = gradientWords.any(
        (gw) => gw.toLowerCase() == cleanWord.toLowerCase(),
      );

      return TextSpan(
        text: word + (isLast ? '' : ' '),
        style: isGradient
            ? baseStyle.copyWith(foreground: Paint()..shader = gradientShader)
            : null,
      );
    }).toList();
  }
}
