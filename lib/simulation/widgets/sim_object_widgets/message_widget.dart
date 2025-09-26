part of 'sim_object_widget.dart';

class MessageWidget extends SimObjectWidget {
  static const imagePath = AppImage.message;
  static const size = 50.0;

  const MessageWidget({super.key, required super.simObjectId});

  @override
  ConsumerState<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends _SimObjectWidgetState<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('${widget.simObjectId} Rebuilt');
    final message = ref.read(messageProvider(widget.simObjectId));

    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    final messagePosX = ref.watch(
      messageProvider(widget.simObjectId).select((msg) => msg.posX),
    );
    final messagePosY = ref.watch(
      messageProvider(widget.simObjectId).select((msg) => msg.posY),
    );
    final messageDuration = ref.watch(
      messageProvider(widget.simObjectId).select((msg) => msg.duration),
    );

    double originPosX = 0;
    double originPosY = 0;

    if (!isPlaying) {
      originPosX = ref.watch(
        hostProvider(message.srcId).select((host) => host.posX),
      );
      originPosY = ref.watch(
        hostProvider(message.srcId).select((host) => host.posY),
      );
    }

    return isPlaying
        ? AnimatedPositioned(
            left: messagePosX - MessageWidget.size / 2,
            top: messagePosY - MessageWidget.size / 2,
            duration: messageDuration,
            curve: Curves.easeIn,
            onEnd: () {
              //* TODO: onEnd Function in Message
            },
            child: GestureDetector(
              onTap: _handleTap,
              child: _messageWithLabel(),
            ),
          )
        : Positioned(
            left: originPosX - MessageWidget.size / 2,
            top: originPosY - MessageWidget.size / 2,
            child: GestureDetector(
              onTap: _handleTap,
              child: _messageWithLabel(),
            ),
          );
  }

  void _handleTap() {
    ref
        .read(simScreenProvider.notifier)
        .setSelectedDeviceOnInfo(widget.simObjectId);
  }

  Column _messageWithLabel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Text(
            ref.read(messageProvider(widget.simObjectId)).name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),

        SizedBox(
          width: MessageWidget.size,
          height: MessageWidget.size,
          child: Image.asset(MessageWidget.imagePath, fit: BoxFit.contain),
        ),
      ],
    );
  }
}
