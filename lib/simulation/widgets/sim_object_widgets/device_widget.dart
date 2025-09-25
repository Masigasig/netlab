part of 'sim_object_widget.dart';

abstract class DeviceWidget extends SimObjectWidget {
  final String imagePath;
  static const size = 100;

  const DeviceWidget({
    super.key,
    required super.simObjectId,
    required this.imagePath,
  });
}

abstract class _DeviceWidgetState<T extends DeviceWidget>
    extends _SimObjectWidgetState<T> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
