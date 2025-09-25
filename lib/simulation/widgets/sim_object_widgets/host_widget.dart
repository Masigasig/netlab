part of 'sim_object_widget.dart';

class HostWidget extends DeviceWidget {
  const HostWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.host);

  @override
  ConsumerState<HostWidget> createState() => _HostWidgetState();
}

class _HostWidgetState extends _DeviceWidgetState<HostWidget> {
  @override
  NotifierProviderFamily<HostNotifier, Host, String> get provider =>
      hostProvider;
}
