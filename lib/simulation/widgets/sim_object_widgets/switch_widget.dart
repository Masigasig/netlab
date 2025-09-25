part of 'sim_object_widget.dart';

class SwitchWidget extends DeviceWidget {
  const SwitchWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.switch_);

  @override
  ConsumerState<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends _DeviceWidgetState<SwitchWidget> {}
