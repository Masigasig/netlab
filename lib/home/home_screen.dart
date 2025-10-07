import 'package:flutter/material.dart';
import 'package:netlab/core/routing/go_router.dart';
// import 'package:netlab/core/components/app_theme.dart';
import '../temp/core/constants/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HERO SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Hero Text
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to \nNetLab!',
                            style: AppTextStyles.forSurface(
                              AppTextStyles.headerLarge.copyWith(
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                                height: 1.2,
                              ),
                              context,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Text(
                              'Simulate and explore networking concepts through interactive labs and visual tools designed for learners.',
                              style: AppTextStyles.withOpacity(
                                AppTextStyles.forSurface(
                                  AppTextStyles.bodyLarge.copyWith(height: 1.5),
                                  context,
                                ),
                                0.7,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              context.go(Routes.simulation);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              'Open Simulation',
                              style: AppTextStyles.forPrimary(
                                AppTextStyles.buttonLarge,
                                context,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 32),

                    // RIGHT: Hero Image
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: cs.onSurface.withOpacity(0.08),
                              blurRadius: 8,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/sample.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
