import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/simulation/provider/sim_screen_notifier.dart';

class UtilityControls extends StatelessWidget {
  final VoidCallback onExit;
  final VoidCallback onSave;
  final VoidCallback onLoad;

  const UtilityControls({
    super.key,
    required this.onExit,
    required this.onSave,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('UtilityControls Widget Rebuilt');
    return Positioned(
      top: 10,
      left: 10,
      child: Center(
        child: Wrap(
          spacing: 8,
          children: [
            _ControlButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft02,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onExit,
            ),

            Consumer(
              builder: (context, ref, _) {
                final isPlaying = ref.watch(
                  simScreenProvider.select((simScreen) => simScreen.isPlaying),
                );

                return _ControlButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedFileDownload,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: isPlaying ? null : onSave,
                  isDisabled: isPlaying,
                );
              },
            ),

            Consumer(
              builder: (context, ref, _) {
                final isPlaying = ref.watch(
                  simScreenProvider.select((simScreen) => simScreen.isPlaying),
                );

                return _ControlButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedFileUpload,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: isPlaying ? null : onLoad,
                  isDisabled: isPlaying,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SimulationControls extends StatelessWidget {
  final VoidCallback onOpenLogs;
  final VoidCallback onStop;
  final VoidCallback onPlay;
  final VoidCallback onCenterView;

  const SimulationControls({
    super.key,

    required this.onOpenLogs,
    required this.onCenterView,
    required this.onStop,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('SimulationControls Widget Rebuilt');
    return Positioned(
      top: 0,
      bottom: 0,
      right: 10,
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          spacing: 8,
          runSpacing: 8,
          children: [
            Consumer(
              builder: (context, ref, _) {
                return _ControlButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedComputerTerminal01,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: onOpenLogs,
                );
              },
            ),

            Consumer(
              builder: (context, ref, _) {
                final isPlaying = ref.watch(
                  simScreenProvider.select((simScreen) => simScreen.isPlaying),
                );

                return _ControlButton(
                  icon: HugeIcon(
                    icon: isPlaying
                        ? HugeIcons.strokeRoundedStop
                        : HugeIcons.strokeRoundedPlay,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: isPlaying ? onStop : onPlay,
                );
              },
            ),

            _ControlButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedKeyframeAlignCenter,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onCenterView,
            ),
          ],
        ),
      ),
    );
  }
}

class AddDeviceButton extends ConsumerWidget {
  final VoidCallback onOpen;
  final VoidCallback onClose;

  const AddDeviceButton({
    super.key,
    required this.onOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('AddDevice Widget Rebuilt');

    final isDevicePanelOpen = ref.watch(
      simScreenProvider.select((simScreen) => simScreen.isDevicePanelOpen),
    );

    return Positioned(
      bottom: 10,
      left: 10,
      child: _ControlButton(
        icon: HugeIcon(
          icon: isDevicePanelOpen
              ? HugeIcons.strokeRoundedMultiplicationSign
              : HugeIcons.strokeRoundedAdd01,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: isDevicePanelOpen ? onClose : onOpen,
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('Icon ${icon.toString()}');
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isDisabled
              ? Colors.grey.shade400
              : Theme.of(context).colorScheme.primary,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
