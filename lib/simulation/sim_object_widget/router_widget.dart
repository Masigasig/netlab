part of 'sim_object_widget.dart';

class RouterWidget extends DeviceWidget {
  const RouterWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.router);

  @override
  ConsumerState<RouterWidget> createState() => _RouterDeviceState();
}

class _RouterDeviceState extends _DeviceWidgetState<RouterWidget> {
  @override
  StateNotifierProvider<DeviceNotifier<dynamic>, Map<String, dynamic>>
  get provider => routerProvider;
}
