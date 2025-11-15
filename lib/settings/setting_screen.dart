import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_history_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/study_time_notifier.dart';
import 'package:netlab/settings/providers/firebase_backup_service.dart';
import 'widgets/section_title.dart';
import 'widgets/setting_card.dart';
import 'widgets/theme_selector.dart';
import 'widgets/font_size_selector.dart';
import 'package:netlab/temp/core/constants/app_text.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:netlab/temp/core/components/animations.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: AnimationPresets.titleFadeIn(
                delay: 100,
                child: Text(
                  'Settings',
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimationPresets.textFadeIn(
                    delay: 250,
                    child: const SectionTitle('Appearance'),
                  ),
                  const SizedBox(height: 12),
                  AnimationPresets.cardEntrance(
                    delay: 350,
                    scaleFrom: 0.95,
                    child: SettingCard(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedPaintBoard,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      label: 'Theme',
                      child: const ThemeSelector(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationPresets.cardEntrance(
                    delay: 450,
                    scaleFrom: 0.95,
                    child: SettingCard(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedTextFont,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      label: 'Font Size (in Lesson/Quiz)',
                      child: FontSizeSelector(
                        value: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                          // TODO: Implement font size persistence
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  AnimationPresets.textFadeIn(
                    delay: 550,
                    child: const SectionTitle('Data & Sync'),
                  ),
                  const SizedBox(height: 12),
                  AnimationPresets.cardEntrance(
                    delay: 650,
                    scaleFrom: 0.95,
                    child: SettingCard(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCloudDownload,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      label: 'Load progress with Google Account',
                      child: SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const BackupDialog(isLoad: true);
                              },
                            );
                          },
                          child: Text(
                            'Load',
                            style: AppTextStyles.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationPresets.cardEntrance(
                    delay: 750,
                    scaleFrom: 0.95,
                    child: SettingCard(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCloudUpload,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      label: 'Sync/Save progress with Google Account',
                      child: SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const BackupDialog(isLoad: false);
                              },
                            );
                          },
                          child: Text(
                            'Save',
                            style: AppTextStyles.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationPresets.cardEntrance(
                    delay: 850,
                    scaleFrom: 0.95,
                    child: SettingCard(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedDelete02,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      label: 'Reset Progress',
                      child: SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Reset'),
                                  content: const Text(
                                    'Are you sure you want to reset your progress? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        await ref
                                            .read(
                                              questionStatusProvider.notifier,
                                            )
                                            .reset();
                                        await ref
                                            .read(lessonStatusProvider.notifier)
                                            .resetAll();
                                        await ref
                                            .read(
                                              chapterQuizStatusProvider
                                                  .notifier,
                                            )
                                            .resetAll();
                                        await ref
                                            .read(studyTimeProvider.notifier)
                                            .reset();
                                        await ref
                                            .read(
                                              lessonHistoryProvider.notifier,
                                            )
                                            .clearHistory();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.errorColor,
                                      ),
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.errorColor),
                            foregroundColor: AppColors.errorColor,
                          ),
                          child: Text(
                            'Reset',
                            style: AppTextStyles.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  AnimationPresets.textFadeIn(
                    delay: 850,
                    child: const SectionTitle('About'),
                  ),
                  const SizedBox(height: 12),
                  AnimationPresets.cardEntrance(
                    delay: 950,
                    scaleFrom: 0.95,
                    child: SettingCard(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedInformationCircle,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      label: 'App Credits',
                      child: SizedBox(
                        width: 120,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement app credits
                          },
                          child: Text(
                            'View',
                            style: AppTextStyles.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
