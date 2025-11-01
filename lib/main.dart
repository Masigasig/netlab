import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:netlab/firebase_options.dart';
import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/core/themes/app_theme.dart';
import 'package:netlab/dashboard/study/provider/material_details_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
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
    await _controller.forward();

    await Future.wait([
      _loadJsonData(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    await _controller.reverse();

    setState(() => _showSplash = false);
  }

  Future<void> _loadJsonData() async {
    final jsonString = await rootBundle.loadString(
      'assets/learning_material/material_details.json',
    );
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    ref.read(materialDetailProvider.notifier).setContent(jsonData);
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
