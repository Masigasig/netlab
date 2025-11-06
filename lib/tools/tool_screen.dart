import 'package:flutter/material.dart';

import 'package:netlab/tools/ip_converter.dart';
import 'package:netlab/tools/subnet_converter.dart';
import 'package:netlab/tools/ip_subnet_analyzer.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:netlab/temp/core/components/animations.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimationPresets.titleFadeIn(
                    delay: 100,
                    child: Text(
                      'Network Tools',
                      style: AppTextStyles.forSurface(
                        AppTextStyles.headerLarge.copyWith(
                          fontSize: 42,
                          height: 1.2,
                          letterSpacing: -1.0,
                        ),
                        context,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  AnimationPresets.textFadeIn(
                    delay: 300,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Text(
                        'Powerful networking utilities to help you convert IP addresses, analyze subnets, and perform network calculations with ease.',
                        style: AppTextStyles.forSurface(
                          AppTextStyles.bodyMedium.copyWith(height: 1.5),
                          context,
                        ).copyWith(color: cs.onSurface.withAlpha(179)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  AnimationPresets.cardEntrance(
                    delay: 500,
                    scaleFrom: 0.95,
                    child: const IpConverter(),
                  ),
                  const SizedBox(height: 24),
                  AnimationPresets.cardEntrance(
                    delay: 650,
                    scaleFrom: 0.95,
                    child: const SubnetConverter(),
                  ),
                  const SizedBox(height: 24),
                  AnimationPresets.cardEntrance(
                    delay: 800,
                    scaleFrom: 0.95,
                    child: const IpSubnetAnalyzer(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
