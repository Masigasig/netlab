part of 'sim_object.dart';

class Switch extends Device {
  Switch({
    required super.id,
    required super.posX,
    required super.posY,
    required super.name,
  }) : super(type: SimObjectType.switch_);

  @override
  Switch copyWith({double? posX, double? posY}) {
    return Switch(
      id: id,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      name: name,
    );
  }
}
