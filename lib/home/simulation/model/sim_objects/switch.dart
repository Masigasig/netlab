part of 'sim_object.dart';

class Switch extends Device {
  final String port0conId;
  final String port1conId;
  final String port2conId;
  final String port3conId;
  final String port4conId;
  final String port5conId;
  final Map<String, String> macTable;

  Map<String, String> get portToConIdMap => {
    'port0': port0conId,
    'port1': port1conId,
    'port2': port2conId,
    'port3': port3conId,
    'port4': port4conId,
    'port5': port5conId,
  };

  Map<String, String> get conIdToPortMap => {
    port0conId: 'port0',
    port1conId: 'port1',
    port2conId: 'port2',
    port3conId: 'port3',
    port4conId: 'port4',
    port5conId: 'port5',
  };

  List<String> get activeConnectionIds {
    return portToConIdMap.values.where((id) => id.isNotEmpty).toList();
  }

  const Switch({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.port0conId = '',
    this.port1conId = '',
    this.port2conId = '',
    this.port3conId = '',
    this.port4conId = '',
    this.port5conId = '',
    this.macTable = const {},
  }) : super(type: SimObjectType.switch_);

  @override
  Switch copyWith({
    String? name,
    double? posX,
    double? posY,
    String? port0conId,
    String? port1conId,
    String? port2conId,
    String? port3conId,
    String? port4conId,
    String? port5conId,
    Map<String, String>? macTable,
  }) {
    return Switch(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      port0conId: port0conId ?? this.port0conId,
      port1conId: port1conId ?? this.port1conId,
      port2conId: port2conId ?? this.port2conId,
      port3conId: port3conId ?? this.port3conId,
      port4conId: port4conId ?? this.port4conId,
      port5conId: port5conId ?? this.port5conId,
      macTable: macTable ?? this.macTable,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'port0conId': port0conId,
      'port1conId': port1conId,
      'port2conId': port2conId,
      'port3conId': port3conId,
      'port4conId': port4conId,
      'port5conId': port5conId,
    };
  }

  factory Switch.fromMap(Map<String, dynamic> map) {
    return Switch(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      port0conId: map['port0conId'].toString(),
      port1conId: map['port1conId'].toString(),
      port2conId: map['port2conId'].toString(),
      port3conId: map['port3conId'].toString(),
      port4conId: map['port4conId'].toString(),
      port5conId: map['port5conId'].toString(),
    );
  }
}
