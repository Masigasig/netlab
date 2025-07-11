part of 'sim_object.dart';

class Switch extends Device {
  Switch({required super.id, required super.posX, required super.posY})
    : super(type: SimObjectType.switch_);

  @override
  Switch copyWith({String? id, double? posX, double? posY}) {
    return Switch(
      id: id ?? this.id,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }
}
