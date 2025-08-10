part of 'sim_object_widget.dart';

class HostWidget extends DeviceWidget {
  const HostWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.host);

  factory HostWidget.fromId(String simObjectId) =>
      HostWidget(simObjectId: simObjectId);

  @override
  ConsumerState<HostWidget> createState() => _HostDeviceState();
}

class _HostDeviceState extends _DeviceWidgetState<HostWidget> {
  @override
  AutoDisposeStateNotifierProviderFamily<
    DeviceNotifier<dynamic>,
    dynamic,
    String
  >
  get provider => hostProvider;
}
