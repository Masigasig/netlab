import 'package:flutter/material.dart';
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
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Lottie.asset(lottiePath),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: Colors.white)),
                            const SizedBox(height: 16),
                            Text(description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white)),
                            const SizedBox(height: 32),
                            if (bottomWidget != null) bottomWidget!,
                          ],
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
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(height: 32),
                    if (bottomWidget != null) bottomWidget!,
                  ],
                ),
        ],
      ),
    );
  }
}