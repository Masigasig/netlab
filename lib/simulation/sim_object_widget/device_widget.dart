part of 'sim_object_widget.dart';

abstract class DeviceWidget extends SimObjectWidget {
  final String imagePath;
  final double size = 100;

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
    debugPrint('Device_${widget.simObjectId} Rebuilt');

    final device = ref.watch(
      deviceProvider.select((map) => map[widget.simObjectId]!),
    );

    Column deviceWithLabel() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
          Material(
            color: Colors.transparent,
            child: Text(
              device.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      );
    }

    return Positioned(
      left: device.posX - widget.size / 2,
      top: device.posY - widget.size / 2,
      child: GestureDetector(
        onTap: _handleTap,
        child: Draggable(
          feedback: Transform.translate(
            offset: Offset(-widget.size / 2, -widget.size / 2),
            child: deviceWithLabel(),
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          childWhenDragging: Container(),
          onDragUpdate: (details) =>
              _updatePosition(details, device.posX, device.posY),
          child: deviceWithLabel(),
        ),
      ),
    );
  }

  void _handleTap() {
    if (ref.read(wireModeProvider)) {
      ref
          .read(simScreenState.notifier)
          .createConnection(simObjectId: widget.simObjectId);
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
        .read(deviceProvider.notifier)
        .updatePosition(widget.simObjectId, newX, newY);
  }
}
