part 'connection.dart';
part 'host.dart';
part 'message.dart';
part 'router.dart';
part 'switch.dart';

enum SimObjectType { connection, host, message, router, switch_ }

extension Label on SimObjectType {
  String get label {
    switch (this) {
      case SimObjectType.connection:
        return 'Connection';
      case SimObjectType.host:
        return 'Host';
      case SimObjectType.message:
        return 'Message';
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
    }
  }
}

abstract class SimObject {
  final String id;
  final String name;
  final SimObjectType type;

  const SimObject({required this.id, required this.name, required this.type});

  SimObject copyWith({String? name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type.name};
  }

  factory SimObject.fromMap(Map<String, dynamic> map) {
    final type = SimObjectType.values.byName(map['type']);

    switch (type) {
      case SimObjectType.connection:
        return Connection.fromMap(map);
      case SimObjectType.host:
        return Host.fromMap(map);
      case SimObjectType.message:
        return Message.fromMap(map);
      case SimObjectType.router:
        return Router.fromMap(map);
      case SimObjectType.switch_:
        return Switch.fromMap(map);
    }
  }
}

abstract class Device extends SimObject {
  final double posX;
  final double posY;

  const Device({
    required super.id,
    required super.name,
    required super.type,
    required this.posX,
    required this.posY,
  });

  @override
  Device copyWith({String? name, double? posX, double? posY});

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'posX': posX, 'posY': posY};
  }
}
