import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/dashboard/study/widgets/chapter_card.dart';

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
                  Text(
                    'Learn Networking\nFundamentals',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 42,
                      height: 1.2,
                      letterSpacing: -1.0,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
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
                    final chapterData = entry.value;

                    return ChapterCard(chapterData: chapterData);
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
