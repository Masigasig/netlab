part of 'sim_object.dart';

class Switch extends Device {
  const Switch({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
  }) : super(type: SimObjectType.switch_);

  @override
  Switch copyWith({double? posX, double? posY}) {
    return Switch(
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

  factory Switch.fromMap(Map<String, dynamic> map) {
    return Switch(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
    );
  }
}
