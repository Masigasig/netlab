part of 'sim_object_widget.dart';

class SwitchWidget extends DeviceWidget {
  const SwitchWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.switch_);

  @override
  ConsumerState<SwitchWidget> createState() => _SwitchDeviceState();
}

class _SwitchDeviceState extends _DeviceWidgetState<SwitchWidget> {}