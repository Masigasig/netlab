part of 'sim_object.dart';

class Host extends Device {
  final String ipAddress;
  final String subnetMask;
  final String macAddress;
  final String defaultGateway;
  final String connectedDeviceId;
  final Map<String, String> arpTable;

  const Host({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.ipAddress = '',
    this.subnetMask = '',
    required this.macAddress,
    this.defaultGateway = '',
    this.connectedDeviceId = '',
    this.arpTable = const {},
  }) : super(type: SimObjectType.host);

  @override
  Host copyWith({
    double? posX,
    double? posY,
    String? ipAddress,
    String? subnetMask,
    String? defaultGateway,
    String? connectedDeviceId,
    Map<String, String>? arpTable,
  }) {
    return Host(
      id: id,
      name: name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
      macAddress: macAddress,
      defaultGateway: defaultGateway ?? this.defaultGateway,
      connectedDeviceId: connectedDeviceId ?? this.connectedDeviceId,
      arpTable: arpTable ?? Map<String, String>.from(this.arpTable),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'ipAddress': ipAddress,
      'subnetMask': subnetMask,
      'macAddress': macAddress,
      'defaultGateway': defaultGateway,
      'connectedDeviceId': connectedDeviceId,
      'arpTable': arpTable,
    };
  }

  factory Host.fromMap(Map<String, dynamic> map) {
    return Host(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      ipAddress: map['ipAddress']?.toString() ?? '',
      subnetMask: map['subnetMask']?.toString() ?? '',
      macAddress: map['macAddress'].toString(),
      defaultGateway: map['defaultGateway']?.toString() ?? '',
      connectedDeviceId: map['connectedDeviceId']?.toString() ?? '',
      arpTable: Map<String, String>.from(map['arpTable'] ?? {}),
    );
  }
}
