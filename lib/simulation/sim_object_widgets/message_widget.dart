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
    final message = ref.watch(messageProvider(widget.simObjectId));
    final host = ref.watch(hostProvider(message.srcId));
    final isPlaying = ref.watch(playingModeProvider);

    Column messageWithLabel() {
      final label = message.dstId.startsWith(DataLinkLayerType.arp.name)
          ? 'ARP'
          : message.name;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Text(
              label,
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
            left: message.posX - widget.size / 2,
            top: message.posY - widget.size / 2 - 25,
            duration: message.duration,
            curve: Curves.easeIn,
            child: GestureDetector(
              onTap: _handleTap,
              child: messageWithLabel(),
            ),
            onEnd: () {
              if (message.currentPlaceId.startsWith(
                SimObjectType.connection.label,
              )) {
                ref
                    .read(connectionProvider(message.currentPlaceId).notifier)
                    .receiveMessage(widget.simObjectId);
              }
            },
          )
        : Positioned(
            left: host.posX - widget.size / 2,
            top: host.posY - widget.size / 2 - 25,
            child: GestureDetector(
              onTap: _handleTap,
              child: messageWithLabel(),
            ),
          );
  }

  void _handleTap() {}
}
