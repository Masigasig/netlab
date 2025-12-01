part of 'sim_object.dart';

class WirelessHost extends Device {
  final String ipAddress;
  final String subnetMask;
  final String defaultGateway;
  final String macAddress;
  final String wirelessConId;
  final Map<String, String> arpTable;
  final List<String> messageIds;

  WirelessHost({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.ipAddress = '',
    this.subnetMask = '/24',
    this.defaultGateway = '',
    required this.macAddress,
    this.wirelessConId = '',
    this.arpTable = const {},
    this.messageIds = const [],
  }) : super(type: SimObjectType.wirelessHost);

  @override
  WirelessHost copyWith({
    String? name,
    double? posX,
    double? posY,
    String? ipAddress,
    String? subnetMask,
    String? defaultGateway,
    String? wirelessConId,
    Map<String, String>? arpTable,
    List<String>? messageIds,
  }) {
    return WirelessHost(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
      defaultGateway: defaultGateway ?? this.defaultGateway,
      macAddress: macAddress,
      wirelessConId: wirelessConId ?? this.wirelessConId,
      arpTable: arpTable ?? Map<String, String>.from(this.arpTable),
      messageIds: messageIds ?? List<String>.from(this.messageIds),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'ipAddress': ipAddress,
      'subnetMask': subnetMask,
      'defaultGateway': defaultGateway,
      'macAddress': macAddress,
      'wirelessConId': wirelessConId,
      'messagesIds': messageIds,
    };
  }

  factory WirelessHost.fromMap(Map<String, dynamic> map) {
    return WirelessHost(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      ipAddress: map['ipAddress'].toString(),
      subnetMask: map['subnetMask'].toString(),
      defaultGateway: map['defaultGateway'].toString(),
      macAddress: map['macAddress'].toString(),
      wirelessConId: map['wirelessConId'].toString(),
      messageIds: List<String>.from(map['messagesIds']),
    );
  }
}
