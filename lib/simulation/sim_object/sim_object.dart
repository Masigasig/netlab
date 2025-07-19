part 'connection.dart';
part 'device.dart';
part 'host.dart';
part 'router.dart';
part 'switch.dart';

enum SimObjectType { connection, host, router, switch_ }

abstract class SimObject {
  final String id;
  final SimObjectType type;

  const SimObject({required this.id, required this.type});

  SimObject copyWith();

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type.name};
  }

  factory SimObject.fromMap(Map<String, dynamic> map) {
    final type = SimObjectType.values.byName(map['type']);

    switch (type) {
      case SimObjectType.router:
        return Router.fromMap(map);
      case SimObjectType.switch_:
        return Switch.fromMap(map);
      case SimObjectType.host:
        return Host.fromMap(map);
      case SimObjectType.connection:
        return Connection.fromMap(map);
    }
  }
}
