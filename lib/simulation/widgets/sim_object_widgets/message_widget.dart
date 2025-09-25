part of 'sim_object_widget.dart';

class MessageWidget extends SimObjectWidget {
  static const imagePath = AppImage.message;
  static const size = 50;

  const MessageWidget({super.key, required super.simObjectId});

  @override
  ConsumerState<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends _SimObjectWidgetState<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
