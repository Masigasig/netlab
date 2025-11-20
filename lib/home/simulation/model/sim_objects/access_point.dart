part of 'sim_object.dart';

class AccessPoint extends Device {
  final Map<String, String> macTable;

  AccessPoint({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.macTable = const {},
  }) : super(type: SimObjectType.accessPoint);

  @override
  Device copyWith({
    String? name,
    double? posX,
    double? posY,
    Map<String, String>? macTable,
  }) {
    return AccessPoint(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      macTable: macTable ?? this.macTable,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap()};
  }

  factory AccessPoint.fromMap(Map<String, dynamic> map) {
    return AccessPoint(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
    );
  }
}
