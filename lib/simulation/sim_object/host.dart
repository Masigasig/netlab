part of 'sim_object.dart';

class Host extends Device {
  const Host({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
  }) : super(type: SimObjectType.host);

  @override
  Host copyWith({double? posX, double? posY}) {
    return Host(
      id: id,
      name: name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap()};
  }

  factory Host.fromMap(Map<String, dynamic> map) {
    return Host(
      id: map['id'] as String,
      name: map['name'] as String,
      posX: map['posX'] as double,
      posY: map['posY'] as double,
    );
  }
}
