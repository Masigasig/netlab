part of 'sim_object.dart';

class Message extends SimObject {
  final double posX;
  final double posY;
  final Duration duration;
  final String srcId;
  final String dstId;
  final String currentPlaceId;
  final List<Map<String, String>> layerStack;

  const Message({
    required super.id,
    required super.name,
    this.posX = 0,
    this.posY = 0,
    this.duration = const Duration(milliseconds: 0),
    required this.srcId,
    required this.dstId,
    this.currentPlaceId = '',
    this.layerStack = const [],
  }) : super(type: SimObjectType.message);

  @override
  Message copyWith({
    String? name,
    double? posX,
    double? posY,
    Duration? duration,
    String? currentPlaceId,
    List<Map<String, String>>? layerStack,
  }) {
    return Message(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      duration: duration ?? this.duration,
      srcId: srcId,
      dstId: dstId,
      currentPlaceId: currentPlaceId ?? this.currentPlaceId,
      layerStack: layerStack ?? List<Map<String, String>>.from(this.layerStack),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'posX': posX,
      'posY': posY,
      'srcId': srcId,
      'dstId': dstId,
      'currentPlaceId': currentPlaceId,
      'layerStack': layerStack,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      srcId: map['srcId'].toString(),
      dstId: map['dstId'].toString(),
      currentPlaceId: map['currentPlaceId'].toString(),
      layerStack: List<Map<String, String>>.from(map['layerStack']),
    );
  }
}
