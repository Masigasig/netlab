import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientText extends StatelessWidget {
  final String text;
  final List<String> gradientWords;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double height;
  final List<Color> gradientColors;
  final Color defaultColor;

  const GradientText({
    super.key,
    required this.text,
    this.gradientWords = const [],
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.center,
    this.height = 1.2,
    this.gradientColors = const [
      Color(0xFF6C63FF),
      Color(0xFFD77EFF), 
      Color(0xFFFF4D94),
    ],
    this.defaultColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: defaultColor,
    );

    // Create gradient shader once for reuse
    final gradientShader = LinearGradient(colors: gradientColors)
        .createShader(const Rect.fromLTWH(0, 0, 300, 70));

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
      final isGradient = gradientWords.any((gw) => 
          gw.toLowerCase() == cleanWord.toLowerCase());
      
      return TextSpan(
        text: word + (isLast ? '' : ' '),
        style: isGradient 
            ? baseStyle.copyWith(foreground: Paint()..shader = gradientShader)
            : null,
      );
    }).toList();
  }
}