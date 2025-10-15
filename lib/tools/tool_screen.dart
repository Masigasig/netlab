import 'package:flutter/material.dart';

import 'package:netlab/tools/ip_converter.dart';
import 'package:netlab/tools/subnet_converter.dart';
import 'package:netlab/tools/ip_subnet_analyzer.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    const SizedBox(height: 16),

                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Text(
                        'Powerful networking utilities to help you convert IP addresses, analyze subnets, and perform network calculations with ease.',
                        style: AppTextStyles.forSurface(
                          AppTextStyles.bodyMedium.copyWith(height: 1.5),
                          context,
                        ).copyWith(color: cs.onSurface.withAlpha(179)),
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    IpConverter(),
                    SizedBox(height: 24),
                    SubnetConverter(),
                    SizedBox(height: 24),
                    IpSubnetAnalyzer(),
                    SizedBox(height: 24),
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
