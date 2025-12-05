part of 'sim_object.dart';

class AccessPoint extends Device {
  final String port0conId;
  final Map<String, String> wirelessConIdToDeviceIdMap;

  AccessPoint({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.port0conId = '',
    this.wirelessConIdToDeviceIdMap = const {},
  }) : super(type: SimObjectType.accessPoint);

  @override
  AccessPoint copyWith({
    String? name,
    double? posX,
    double? posY,
    String? port0conId,
    Map<String, String>? wirelessConIdToDeviceIdMap,
  }) {
    return AccessPoint(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      port0conId: port0conId ?? this.port0conId,
      wirelessConIdToDeviceIdMap:
          wirelessConIdToDeviceIdMap ?? this.wirelessConIdToDeviceIdMap,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'port0conId': port0conId,
      'wirelessConIdToDeviceIdMap': wirelessConIdToDeviceIdMap,
    };
  }

  factory AccessPoint.fromMap(Map<String, dynamic> map) {
    return AccessPoint(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      port0conId: map['port0conId'].toString(),
      wirelessConIdToDeviceIdMap:
          (map['wirelessConIdToDeviceIdMap'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ) ??
          {},
    );
  }
}
