import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class Settings {
  final double speed;
  final double waitingTime;

  const Settings({required this.speed, required this.waitingTime});
}

final settingsProvider = StateProvider<Settings>((ref) {
  return const Settings(speed: 100, waitingTime: 60);
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Settings', home: HomeScreen());
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Speed: ${settings.speed.toInt()}'),
            Text('Waiting Time: ${settings.waitingTime.toInt()}s'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => showSettingsDialog(context, ref),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void showSettingsDialog(BuildContext context, WidgetRef ref) {
    final currentSettings = ref.read(settingsProvider);
    double tempSpeed = currentSettings.speed;
    double tempWaitingTime = currentSettings.waitingTime;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Speed: ${tempSpeed.toInt()}'),
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 18),
                      onPressed: () => showInfoDialog(
                        context,
                        'Speed',
                        'Controls the speed of the operation. Range: 50-150.',
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: tempSpeed,
                  min: 50,
                  max: 150,
                  divisions: 100,
                  onChanged: (value) => setState(() => tempSpeed = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Waiting Time: ${tempWaitingTime.toInt()}s'),
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 18),
                      onPressed: () => showInfoDialog(
                        context,
                        'Waiting Time',
                        'Sets how long to wait between operations. Range: 20-100 seconds.',
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: tempWaitingTime,
                  min: 20,
                  max: 100,
                  divisions: 80,
                  onChanged: (value) => setState(() => tempWaitingTime = value),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(settingsProvider.notifier).state = Settings(
                          speed: tempSpeed,
                          waitingTime: tempWaitingTime,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(message),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
