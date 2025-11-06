import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/dashboard/study/widgets/chapter_card.dart';
import 'package:netlab/home/widgets/gradient_text.dart';

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final json = ref.read(materialDetailProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomGradientText(
                    text: 'Learn Networking\nFundamentals',
                    gradientWords: const ['Learn'],
                    fontSize: 42,
                    height: 1.2,
                    letterSpacing: -1.0,
                    fontWeight: FontWeight.bold,
                    gradientColors: [cs.primary, cs.secondary],
                    defaultColor: cs.onSurface,
                    textAlign: TextAlign.start,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Text(
                      'Master the essentials of networking with clear, practical explanations designed to build a strong foundation without the unnecessary complexity.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                        color: cs.onSurface.withAlpha(180),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...json.entries.map((entry) {
                    final chapterKey = entry.key;

                    return ChapterCard(chapterId: chapterKey);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
