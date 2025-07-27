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
                    // Content first
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(80.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const Spacer(),
                            if (bottomWidget != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: bottomWidget!,
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Animation on the right
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Lottie.asset(lottiePath),
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

    // Split by space but preserve original structure
    final regex = RegExp(r'(\s+|[^\s]+)');
    final tokens = regex.allMatches(title).map((m) => m.group(0)!).toList();

    return RichText(
      textAlign: isLandscape ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: isLandscape ? 42 : 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
        children: tokens.map((token) {
          final clean = token.trim().replaceAll(RegExp(r'[^\w]'), '');
          final hasGradient = gradientWords.contains(clean);

          if (hasGradient) {
            return WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: Text(
                  token,
                  style: GoogleFonts.poppins(
                    fontSize: isLandscape ? 42 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
