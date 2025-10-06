part of 'sim_object_widget.dart';

class MessageWidget extends SimObjectWidget {
  static const imagePath = AppImage.message;
  static const size = 100.0;

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
              final currentPlaceId = ref
                  .read(messageProvider(widget.simObjectId))
                  .currentPlaceId;

              if (currentPlaceId.startsWith(SimObjectType.connection.label)) {
                ref
                    .read(connectionProvider(currentPlaceId).notifier)
                    .sendMessage(widget.simObjectId);
              }
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

    if (ref.read(simScreenProvider).isInfoPanelOpen) {
      if (ref.read(simScreenProvider).selectedDeviceOnInfo.isEmpty) {
        ref.read(simScreenProvider.notifier).closeInfoPanel();
      }
    } else {
      if (ref.read(simScreenProvider).selectedDeviceOnInfo.isNotEmpty) {
        ref.read(simScreenProvider.notifier).openInfoPanel();
      }
    }
  }

  Column _messageWithLabel() {
    final name = ref.read(messageProvider(widget.simObjectId)).name;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MessageWidget.size,
            child: Consumer(
              builder: (context, ref, child) {
                final name = ref.watch(
                  messageProvider(widget.simObjectId).select((m) => m.name),
                );
                final selectedIdOnInfo = ref.watch(
                  simScreenProvider.select((s) => s.selectedDeviceOnInfo),
                );

                final isSelected = widget.simObjectId == selectedIdOnInfo;

                return Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(
          width: MessageWidget.size - 50,
          height: MessageWidget.size - 25 - 50,
          child: name.startsWith('ARP')
              ? Image.asset(AppImage.arpMessage, fit: BoxFit.contain)
              : Image.asset(MessageWidget.imagePath, fit: BoxFit.contain),
        ),
      ],
    );
  }
}
