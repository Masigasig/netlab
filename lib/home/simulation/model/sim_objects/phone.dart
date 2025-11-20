part of 'sim_object.dart';

class Phone extends Device {
  final String ipAddress;
  final String subnetMask;
  final String defaultGateway;
  final String macAddress;
  final String connectionId;
  final Map<String, String> arpTable;
  final List<String> messageIds;

  Phone({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.ipAddress = '',
    this.subnetMask = '/24',
    this.defaultGateway = '',
    required this.macAddress,
    this.connectionId = '',
    this.arpTable = const {},
    this.messageIds = const [],
  }) : super(type: SimObjectType.phone);

  @override
  Phone copyWith({
    String? name,
    double? posX,
    double? posY,
    String? ipAddress,
    String? subnetMask,
    String? defaultGateway,
    String? connectionId,
    Map<String, String>? arpTable,
    List<String>? messageIds,
  }) {
    return Phone(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
      defaultGateway: defaultGateway ?? this.defaultGateway,
      macAddress: macAddress,
      connectionId: connectionId ?? this.connectionId,
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
      'connectionId': connectionId,
      'messagesIds': messageIds,
    };
  }

  factory Phone.fromMap(Map<String, dynamic> map) {
    return Phone(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      ipAddress: map['ipAddress'].toString(),
      subnetMask: map['subnetMask'].toString(),
      defaultGateway: map['defaultGateway'].toString(),
      macAddress: map['macAddress'].toString(),
      connectionId: map['connectionId'].toString(),
      messageIds: List<String>.from(map['messagesIds']),
    );
  }
}
