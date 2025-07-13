part of '../simulation_screen.dart';

class _DeviceWidgetStack extends ConsumerWidget {
  const _DeviceWidgetStack();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('DeviceWidgetStack Widget Rebuilt');
    final deviceWidgets = ref.watch(deviceWidgetProvider);

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(children: [...deviceWidgets.values]),
    );
  }
}

class _ConnectionWidgetStack extends ConsumerWidget {
  const _ConnectionWidgetStack();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ConnectionWidgetStack Widget Rebuilt');
    final connectionWidgets = ref.watch(connectionWidgetProvider);

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(children: [...connectionWidgets.values]),
    );
  }
}
