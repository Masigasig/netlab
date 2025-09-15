part of 'sim_object_widget.dart';

class RouterWidget extends DeviceWidget {
  const RouterWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.router);

  factory RouterWidget.fromId(String simObjectId) =>
      RouterWidget(simObjectId: simObjectId);

  @override
  ConsumerState<RouterWidget> createState() => _RouterDeviceState();
}

class _RouterDeviceState extends _DeviceWidgetState<RouterWidget> {
  @override
  NotifierProviderFamily<DeviceNotifier<dynamic>, dynamic, String>
  get provider => routerProvider;
}
