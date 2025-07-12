part of '../simulation_screen.dart';

class _DeviceWidgetStack extends ConsumerWidget {
  const _DeviceWidgetStack();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final connectionWidgets = ref.watch(connectionWidgetProvider);

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(children: [...connectionWidgets.values]),
    );
  }
}
