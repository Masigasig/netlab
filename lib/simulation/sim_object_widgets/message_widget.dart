part of 'sim_object_widget.dart';

class MessageWidget extends SimObjectWidget {
  final String imagePath = AppImage.message;
  final double size = 50;

  const MessageWidget({super.key, required super.simObjectId});

  factory MessageWidget.fromId(String simObjectId) {
    return MessageWidget(simObjectId: simObjectId);
  }

  @override
  ConsumerState<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends _SimObjectWidgetState<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final message = ref.read(messageProvider(widget.simObjectId));
    final messagePosX = ref.watch(
      messageProvider(widget.simObjectId).select((msg) => msg.posX),
    );
    final messagePosY = ref.watch(
      messageProvider(widget.simObjectId).select((msg) => msg.posY),
    );
    final messageDuration = ref.watch(
      messageProvider(widget.simObjectId).select((msg) => msg.duration),
    );

    double originPosX;
    double originPosY;

    if (message.srcId.startsWith(SimObjectType.router.label)) {
      originPosX = ref.watch(
        routerProvider(message.srcId).select((router) => router.posX),
      );
    } else {
      originPosX = ref.watch(
        hostProvider(message.srcId).select((host) => host.posX),
      );
    }

    if (message.srcId.startsWith(SimObjectType.router.label)) {
      originPosY = ref.watch(
        routerProvider(message.srcId).select((router) => router.posY),
      );
    } else {
      originPosY = ref.watch(
        hostProvider(message.srcId).select((host) => host.posY),
      );
    }

    final isPlaying = ref.watch(playingModeProvider);

    Column messageWithLabel() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Text(
              message.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
          SizedBox(
            width: widget.size,
            height: widget.size - 25,
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
        ],
      );
    }

    return isPlaying
        ? AnimatedPositioned(
            left: messagePosX - widget.size / 2,
            top: messagePosY - widget.size / 2 - 25,
            duration: messageDuration,
            curve: Curves.easeIn,
            child: GestureDetector(
              onTap: _handleTap,
              child: messageWithLabel(),
            ),
            onEnd: () {
              final currentPlaceId = ref
                  .read(messageProvider(widget.simObjectId))
                  .currentPlaceId;

              if (currentPlaceId.startsWith(SimObjectType.connection.label)) {
                ref
                    .read(connectionProvider(currentPlaceId).notifier)
                    .sendMessage(widget.simObjectId);
              }
            },
          )
        : Positioned(
            left: originPosX - widget.size / 2,
            top: originPosY - widget.size / 2 - 25,
            child: GestureDetector(
              onTap: _handleTap,
              child: messageWithLabel(),
            ),
          );
  }

  void _handleTap() {
    ref
        .read(selectedDeviceOnInfoProvider.notifier)
        .setSelectedDevice(widget.simObjectId);
  }
}
