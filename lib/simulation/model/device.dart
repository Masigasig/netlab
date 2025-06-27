import 'dart:convert';

class Device {
  final String id;
  final String name;
  final String type;
  final double posX;
  final double posY;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.posX,
    required this.posY,
  });

  Device copyWith({
    String? id,
    String? name,
    String? type,
    double? posX,
    double? posY,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'posX': posX,
      'posY': posY,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      posX: map['posX'] as double,
      posY: map['posY'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source) as Map<String, dynamic>);
}
