part 'host.dart';

enum SimObjectType { connection, host, message, router, switch_ }

abstract class SimObject {
  final String id;
  final SimObjectType type;

  const SimObject({required this.id, required this.type});

  SimObject copyWith();

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type.name};
  }

  // factory SimObject.fromMap(Map<String, dynamic> map) {
  //   final type = SimObjectType.values.byName(map['type']);

  //   switch (type) {
  //     case SimObjectType.connection:
  //       return Connection.fromMap(map);
  //     case SimObjectType.host:
  //       return Host.fromMap(map);
  //     case SimObjectType.message:
  //       return Message.fromMap(map);
  //     case SimObjectType.router:
  //       return Router.fromMap(map);
  //     case SimObjectType.switch_:
  //       return Switch.fromMap(map);
  //   }
  // }
}

abstract class Device extends SimObject {
  final String name;
  final double posX;
  final double posY;

  const Device({
    required super.id,
    required super.type,
    required this.name,
    required this.posX,
    required this.posY,
  });

  @override
  Device copyWith({double? posX, double? posY});

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'name': name, 'posX': posX, 'posY': posY};
  }
}
