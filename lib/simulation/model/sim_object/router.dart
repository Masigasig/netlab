part of 'sim_object.dart';

class Router extends Device {
  Router({required super.id, required super.posX, required super.posY})
    : super(type: SimObjectType.router);

  @override
  Router copyWith({String? id, double? posX, double? posY}) {
    return Router(
      id: id ?? this.id,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }
}
