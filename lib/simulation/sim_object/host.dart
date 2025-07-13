part of 'sim_object.dart';

class Host extends Device {
  Host({
    required super.id,
    required super.posX,
    required super.posY,
    required super.name,
  }) : super(type: SimObjectType.host);

  @override
  Host copyWith({double? posX, double? posY}) {
    return Host(
      id: id,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      name: name,
    );
  }
}
