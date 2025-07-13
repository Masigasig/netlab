part of 'sim_object.dart';

class Router extends Device {
  Router({
    required super.id,
    required super.posX,
    required super.posY,
    required super.name,
  }) : super(type: SimObjectType.router);

  @override
  Router copyWith({double? posX, double? posY}) {
    return Router(
      id: id,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      name: name,
    );
  }
}
