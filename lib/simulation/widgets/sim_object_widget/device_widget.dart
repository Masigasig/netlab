part of 'sim_object_widget.dart';

abstract class DeviceWidget extends SimObjectWidget {
  final String imagePath;
  final double size = AppConstants.deviceSize;

  const DeviceWidget({
    super.key,
    required this.imagePath,
    required super.simObjectId,
  });
}

abstract class _DeviceWidgetState<T extends DeviceWidget>
    extends _SimObjectWidgetState<T> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(
      simObjectMapProvider.select((map) => map[widget.simObjectId] as Device),
    );

    return Positioned(
      left: device.posX - widget.size / 2,
      top: device.posY - widget.size / 2,
      child: GestureDetector(
        onTap: _handleTap,
        child: Draggable(
          feedback: Transform.translate(
            offset: Offset(-widget.size / 2, -widget.size / 2),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Image.asset(widget.imagePath, fit: BoxFit.contain),
            ),
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          childWhenDragging: Container(),
          onDragUpdate: (details) =>
              _updatePosition(details, device.posX, device.posY),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    final wireModeNotifier = ref.read(wireModeProvider.notifier);
    final simObjectMapNotifier = ref.read(simObjectMapProvider.notifier);

    if (wireModeNotifier.isWireModeEnabled) {
      if (!wireModeNotifier.selectedDevices.contains(widget.simObjectId) &&
        wireModeNotifier.selectedDevices.length < 2){

        wireModeNotifier.addDevice(widget.simObjectId);

        if (wireModeNotifier.selectedDevices.length == 2) {
          final updated = wireModeNotifier.selectedDevices;
          simObjectMapNotifier.createConnection(conA: updated[0], conB: updated[1]);
          wireModeNotifier.clearDevices();
          wireModeNotifier.toggle();
        }
      }
    }


  }

  void _updatePosition(DragUpdateDetails details, double posX, double posY) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(
      details.globalPosition,
    );

    final newX = posX + localPosition.dx - widget.size / 2;
    final newY = posY + localPosition.dy - widget.size / 2;

    ref
        .read(simObjectMapProvider.notifier)
        .updatePosition(widget.simObjectId, newX, newY);
  }
}