part of 'sim_object.dart';

class Host extends Device {
  Host({required super.id, required super.posX, required super.posY})
    : super(type: SimObjectType.host);

  @override
  Host copyWith({String? id, double? posX, double? posY}) {
    return Host(
      id: id ?? this.id,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }
}
