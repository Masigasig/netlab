import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:netlab/firebase_options.dart';
import 'package:netlab/core/provider/async_shared_prefs_provider.dart';
import 'package:netlab/core/provider/theme_mode_notifier.dart';
import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/dashboard/study/provider/chapter_quiz_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_history_notifier.dart';
import 'package:netlab/dashboard/study/provider/lesson_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_content_notifier.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';
import 'package:netlab/dashboard/study/provider/question_status_notifier.dart';
import 'package:netlab/dashboard/study/provider/study_time_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final asyncPrefs = SharedPreferencesAsync();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      ProviderScope(
        overrides: [asyncSharedPrefsProvider.overrideWithValue(asyncPrefs)],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startSplash() async {
    await ref.read(themeModeProvider.notifier).loadThemeMode();
    await _controller.forward();

    await Future.wait([
      _loadData(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    await _controller.reverse();

    setState(() => _showSplash = false);
  }

  Future<void> _loadData() async {
    final jsonString = await rootBundle.loadString(
      'assets/learning_material/material_details.json',
    );
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    ref.read(materialDetailProvider.notifier).setContent(jsonData);

    final Map<String, Map<String, String>> markdownContent = {};

    for (final chapter in jsonData.entries) {
      final chapterId = chapter.key;
      markdownContent[chapterId] = {};

      final lessons =
          (chapter.value['lessons'] as Map<String, dynamic>).entries;
      for (final lesson in lessons) {
        final lessonId = lesson.key;
        final contentPath = lesson.value['content_path'] as String;

        try {
          final markdownString = await rootBundle.loadString(contentPath);
          markdownContent[chapterId]![lessonId] = markdownString;
        } catch (e) {
          debugPrint('Error loading markdown for $chapterId/$lessonId: $e');
          markdownContent[chapterId]![lessonId] = 'Content not available';
        }
      }
    }
    ref.read(materialContentProvider.notifier).setContent(markdownContent);
    await ref.read(questionStatusProvider.notifier).loadStatuses();
    await ref.read(lessonStatusProvider.notifier).loadStatuses();
    await ref.read(chapterQuizStatusProvider.notifier).loadStatuses();
    await ref.read(studyTimeProvider.notifier).loadTime();
    await ref.read(lessonHistoryProvider.notifier).loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp Widget rebuit');
    final themeMode = ref.watch(themeModeProvider);

    if (_showSplash) {
      return MaterialApp(
        themeMode: themeMode,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: FadeTransition(
            opacity: _fade,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 200,
                height: 200,
                semanticsLabel: 'App Logo',
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      themeMode: themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
