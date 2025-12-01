part of 'sim_object_widget.dart';

class WirelessHostWidget extends DeviceWidget {
  const WirelessHostWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.wirelessHost);

  @override
  ConsumerState<WirelessHostWidget> createState() => _WirelessHostWidgetState();
}

class _WirelessHostWidgetState extends _DeviceWidgetState<WirelessHostWidget> {
  @override
  NotifierProviderFamily<WirelessHostNotifier, WirelessHost, String>
  get provider => wirelessHostProvider;
}
