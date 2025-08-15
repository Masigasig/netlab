part of '../simulation_screen.dart';

class _DeviceWidgetStack extends ConsumerWidget {
  final SimObjectType type;

  const _DeviceWidgetStack({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('${type.label}Widget Stack Rebuilt');

    final provider = switch (type) {
      SimObjectType.connection => connectionWidgetProvider,
      SimObjectType.host => hostWidgetProvider,
      SimObjectType.message => messageWidgetProvider,
      SimObjectType.router => routerWidgetProvider,
      SimObjectType.switch_ => switchWidgetProvider,
    };

    final widgets = ref.watch(provider);

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(children: [...widgets.values]),
    );
  }
}
