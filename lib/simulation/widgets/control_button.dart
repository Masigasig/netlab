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

            _DisabledWhenPlayingButton(
              onPressed: onSave,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedFileDownload,

                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            _DisabledWhenPlayingButton(
              onPressed: onSave,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedFileUpload,

                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimulationControls extends StatelessWidget {
  final VoidCallback onOpenLogs;
  final VoidCallback onCloseLogs;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onCenterView;
  final VoidCallback onClearAll;

  const SimulationControls({
    super.key,
    required this.onOpenLogs,
    required this.onCloseLogs,
    required this.onStop,
    required this.onPlay,
    required this.onCenterView,
    required this.onClearAll,
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
            _LogPanelButton(onOpen: onOpenLogs, onClose: onCloseLogs),

            _PlayPauseButton(onPlay: onPlay, onStop: onStop),

            _ControlButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedKeyframeAlignCenter,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onCenterView,
            ),

            _DisabledWhenPlayingButton(
              onPressed: onClearAll,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedClean,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
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

class _PlayPauseButton extends ConsumerWidget {
  final VoidCallback onPlay;
  final VoidCallback onStop;

  const _PlayPauseButton({required this.onPlay, required this.onStop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PlayPuaseButton Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    return _ControlButton(
      icon: HugeIcon(
        icon: isPlaying
            ? HugeIcons.strokeRoundedStop
            : HugeIcons.strokeRoundedPlay,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: isPlaying ? onStop : onPlay,
    );
  }
}

class _LogPanelButton extends ConsumerWidget {
  final VoidCallback onOpen;
  final VoidCallback onClose;

  const _LogPanelButton({required this.onOpen, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('LogPanelButton Rebuilt');
    final isOpen = ref.watch(simScreenProvider.select((s) => s.isLogPanelOpen));

    return _ControlButton(
      icon: HugeIcon(
        icon: isOpen
            ? HugeIcons.strokeRoundedMultiplicationSign
            : HugeIcons.strokeRoundedComputerTerminal01,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: isOpen ? onClose : onOpen,
    );
  }
}

class _DisabledWhenPlayingButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const _DisabledWhenPlayingButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('DisabledWhenPlayingButton Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    return _ControlButton(icon: icon, onPressed: isPlaying ? null : onPressed);
  }
}

class _ControlButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;

  const _ControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    debugPrint('Icon ${icon.toString()}');
    return SizedBox(
      height: 40,
      width: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: icon,
      ),
    );
  }
}
