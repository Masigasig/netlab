part of 'sim_object_widget.dart';

abstract class DeviceWidget extends SimObjectWidget {
  final String imagePath;
  static const size = 100.0;

  const DeviceWidget({
    super.key,
    required super.simObjectId,
    required this.imagePath,
  });
}

abstract class _DeviceWidgetState<T extends DeviceWidget>
    extends _SimObjectWidgetState<T> {
  NotifierProviderFamily<DeviceNotifier, Device, String> get provider;

  @override
  Widget build(BuildContext context) {
    debugPrint('Device_${widget.simObjectId} Rebuilt');

    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    final posX = ref.watch(provider(widget.simObjectId).select((d) => d.posX));
    final posY = ref.watch(provider(widget.simObjectId).select((d) => d.posY));

    return Positioned(
      left: posX - DeviceWidget.size / 2,
      top: posY - DeviceWidget.size / 2,
      child: GestureDetector(
        onTap: _handleTap,
        child: isPlaying
            ? _deviceWithLabel()
            : Draggable(
                feedback: Transform.translate(
                  offset: const Offset(
                    -DeviceWidget.size / 2,
                    -DeviceWidget.size / 2,
                  ),
                  child: _deviceWithLabel(),
                ),
                dragAnchorStrategy: pointerDragAnchorStrategy,
                childWhenDragging: const SizedBox.shrink(),
                onDragUpdate: (details) => _updatePosition(details, posX, posY),
                child: _deviceWithLabel(),
              ),
      ),
    );
  }

  Widget _deviceWithLabel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: DeviceWidget.size,
          height: DeviceWidget.size,
          child: Image.asset(widget.imagePath, fit: BoxFit.contain),
        ),
        Material(
          color: Colors.transparent,
          child: Text(
            ref.read(provider(widget.simObjectId)).name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _handleTap() {
    if (ref.read(simScreenProvider.select((s) => s.isConnectionModeOn))) {
      ref
          .read(simScreenProvider.notifier)
          .setSelectedDeviceOnConn(widget.simObjectId);
    } else if (ref.read(simScreenProvider.select((s) => s.isMessageModeOn))) {
      ref.read(simScreenProvider.notifier).createMessage(widget.simObjectId);
    } else {
      ref
          .read(simScreenProvider.notifier)
          .setSelectedDeviceOnInfo(widget.simObjectId);
    }
  }

  void _updatePosition(DragUpdateDetails details, double posX, double posY) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    final newX = posX + localPosition.dx - DeviceWidget.size / 2;
    final newY = posY + localPosition.dy - DeviceWidget.size / 2;

    ref.read(provider(widget.simObjectId).notifier).updatePosition(newX, newY);
  }
}
