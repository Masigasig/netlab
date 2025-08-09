part of 'sim_object.dart';

class Message extends SimObject {
  final String srcId;
  final String dstId;
  final String currentPlaceId;
  final List<Map<String, dynamic>> layerStack;

  final bool shouldAnimate;

  const Message({
    required super.id,
    required this.srcId,
    required this.dstId,
    this.currentPlaceId = '',
    this.layerStack = const [],
    this.shouldAnimate = false,
  }) : super(type: SimObjectType.message);

  @override
  Message copyWith({
    String? currentPlaceId,
    List<Map<String, dynamic>>? layerStack,
    bool? shouldAnimate,
  }) {
    return Message(
      id: id,
      srcId: srcId,
      dstId: dstId,
      currentPlaceId: currentPlaceId ?? this.currentPlaceId,
      layerStack:
          layerStack ?? List<Map<String, dynamic>>.from(this.layerStack),
      shouldAnimate: shouldAnimate ?? this.shouldAnimate,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'srcId': srcId,
      'dstId': dstId,
      'currentPlaceId': currentPlaceId,
      'layerStack': layerStack,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'].toString(),
      srcId: map['srcId'].toString(),
      dstId: map['dstId'].toString(),
      currentPlaceId: map['currentPlaceId'].toString(),
      layerStack: List<Map<String, dynamic>>.from(map['layerStack']),
    );
  }
}
