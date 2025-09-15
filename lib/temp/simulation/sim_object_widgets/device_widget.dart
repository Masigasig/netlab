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
  NotifierProviderFamily<DeviceNotifier<dynamic>, dynamic, String> get provider;

  @override
  Widget build(BuildContext context) {
    debugPrint('Device_${widget.simObjectId} Rebuilt');

    final devicePosX = ref.watch(
      provider(widget.simObjectId).select((device) => device.posX),
    );
    final devicePosY = ref.watch(
      provider(widget.simObjectId).select((device) => device.posY),
    );
    final isPlaying = ref.watch(playingModeProvider);

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
              ref.read(provider(widget.simObjectId)).name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      );
    }

    return Positioned(
      left: devicePosX - widget.size / 2,
      top: devicePosY - widget.size / 2,
      child: GestureDetector(
        onTap: _handleTap,
        child: isPlaying
            ? deviceWithLabel()
            : Draggable(
                feedback: Transform.translate(
                  offset: Offset(-widget.size / 2, -widget.size / 2),
                  child: deviceWithLabel(),
                ),
                dragAnchorStrategy: pointerDragAnchorStrategy,
                childWhenDragging: Container(),
                onDragUpdate: (details) =>
                    _updatePosition(details, devicePosX, devicePosY),
                child: deviceWithLabel(),
              ),
      ),
    );
  }

  void _handleTap() {
    if (ref.read(wireModeProvider)) {
      ref
          .read(selectedDeviceOnConnProvider.notifier)
          .setSelectedDevice(widget.simObjectId);
    } else if (ref.read(messageModeProvider)) {
      ref.read(simScreenState.notifier).createMessage(widget.simObjectId);
    } else {
      ref
          .read(selectedDeviceOnInfoProvider.notifier)
          .setSelectedDevice(widget.simObjectId);
    }
  }

  void _updatePosition(DragUpdateDetails details, double posX, double posY) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(
      details.globalPosition,
    );

    final newX = posX + localPosition.dx - widget.size / 2;
    final newY = posY + localPosition.dy - widget.size / 2;

    ref.read(provider(widget.simObjectId).notifier).updatePosition(newX, newY);
  }
}
