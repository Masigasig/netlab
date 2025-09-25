part of 'sim_object_widget.dart';

class RouterWidget extends DeviceWidget {
  const RouterWidget({super.key, required super.simObjectId})
    : super(imagePath: AppImage.router);

  @override
  ConsumerState<RouterWidget> createState() => _RouterWidgetState();
}

class _RouterWidgetState extends _DeviceWidgetState<RouterWidget> {}
