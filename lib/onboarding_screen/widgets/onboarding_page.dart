import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String lottiePath;
  final Widget? bottomWidget;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.lottiePath,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return SizedBox.expand(
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          isLandscape
              ? Row(
                  children: [
                    // Left side
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildGradientTitle(title, isLandscape),
                                const SizedBox(height: 16),
                                Text(
                                  description,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                            if (bottomWidget != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: bottomWidget!,
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Right side
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 450),
                            child: Lottie.asset(lottiePath),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(lottiePath, height: 250),
                    const SizedBox(height: 20),
                    _buildGradientTitle(title, isLandscape),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (bottomWidget != null) bottomWidget!,
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildGradientTitle(String title, bool isLandscape) {
    const gradientWords = ['NetLab', 'Build', 'Simulate'];

    final regex = RegExp(r'(\s+|[^\s]+)');
    final tokens = regex.allMatches(title).map((m) => m.group(0)!).toList();

    final defaultStyle = GoogleFonts.poppins(
      fontSize: isLandscape ? 42 : 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
      color: Colors.white,
    );

    return RichText(
      textAlign: isLandscape ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: tokens.map((token) {
          final clean = token.trim().replaceAll(RegExp(r'[^\w]'), '');
          final isGradient = gradientWords.contains(clean);

          if (isGradient) {
            return TextSpan(
              text: token,
              style: defaultStyle.copyWith(
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      Color(0xFF6C63FF),
                      Color(0xFFD77EFF),
                      Color(0xFFFF4D94),
                    ],
                  ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
              ),
            );
          } else {
            return TextSpan(text: token); 
          }
        }).toList(),
      ),
    );
  }
}
