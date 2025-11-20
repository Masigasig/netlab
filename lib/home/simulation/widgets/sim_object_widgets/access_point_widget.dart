part of 'sim_object_widget.dart';

class AccessPointWidget extends DeviceWidget {
  const AccessPointWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.accessPoint);

  @override
  ConsumerState<AccessPointWidget> createState() => _AccessPointWidgetState();
}

class _AccessPointWidgetState extends _DeviceWidgetState<AccessPointWidget> {
  @override
  NotifierProviderFamily<AccessPointNotifier, AccessPoint, String>
  get provider => accessPointProvider;
}
