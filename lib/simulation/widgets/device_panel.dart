import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:netlab/core/constants/app_image.dart';
import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

class DevicePanel extends ConsumerWidget {
  const DevicePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('DevicePanel Widget Rebuilt');
    final isOpen = ref.watch(
      simScreenProvider.select((s) => s.isDevicePanelOpen),
    );

    if (!isOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 8,
      left: 20,
      right: 0,
      child: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const SizedBox(
            width: 420,
            height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DeviceSpawner(
                  type: SimObjectType.host,
                  imagePath: AppImage.host,
                ),
                _DeviceSpawner(
                  type: SimObjectType.switch_,
                  imagePath: AppImage.switch_,
                ),
                _DeviceSpawner(
                  type: SimObjectType.router,
                  imagePath: AppImage.router,
                ),
                _ConnectionSpawner(),
                _MessageSpawner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceSpawner extends ConsumerWidget {
  final SimObjectType type;
  final String imagePath;
  final size = 80.0;

  const _DeviceSpawner({required this.type, required this.imagePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('DeviceSpawner Widget Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    if (isPlaying) {
      return const Offstage(offstage: true);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Draggable<SimObjectType>(
          data: type,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Transform.translate(
            offset: Offset(-size / 2 - 15, -size / 2 - 15),
            child: SizedBox(
              width: size + 30, //? enlarge effect so it looks they're above
              height: size + 30,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(type.label),
        ),
      ],
    );
  }
}

class _ConnectionSpawner extends ConsumerWidget {
  final size = 80.0;

  const _ConnectionSpawner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ConnectionSpawner Widget Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    if (isPlaying) {
      return const Offstage(offstage: true);
    }

    final isActive = ref.watch(
      simScreenProvider.select((s) => s.isConnectionModeOn),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () =>
              ref.read(simScreenProvider.notifier).toggleConnectionMode(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              width: size,
              height: size - 20,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : null,
                shape: BoxShape.circle,
              ),
              child: Image.asset(AppImage.connection, fit: BoxFit.contain),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            SimObjectType.connection.label,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.secondary : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageSpawner extends ConsumerWidget {
  final size = 80.0;

  const _MessageSpawner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('MessageSpawner Widget Rebuilt');
    final isActive = ref.watch(
      simScreenProvider.select((s) => s.isMessageModeOn),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => ref.read(simScreenProvider.notifier).toggleMessageMode(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              width: size,
              height: size - 20,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : null,
                shape: BoxShape.circle,
              ),
              child: Image.asset(AppImage.message, fit: BoxFit.contain),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            SimObjectType.message.label,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.secondary : null,
            ),
          ),
        ),
      ],
    );
  }
}
