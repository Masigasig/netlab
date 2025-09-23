part of 'sim_object.dart';

class Router extends Device {
  const Router({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
  }) : super(type: SimObjectType.router);

  @override
  Router copyWith({String? name, double? posX, double? posY}) {
    return Router(
      id: id,
      name: name ?? this.name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap()};
  }

  factory Router.fromMap(Map<String, dynamic> map) {
    return Router(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
    );
  }
}
