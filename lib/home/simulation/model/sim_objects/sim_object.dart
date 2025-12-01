import 'package:netlab/home/simulation/core/enums.dart';

part 'access_point.dart';
part 'connection.dart';
part 'host.dart';
part 'message.dart';
part 'router.dart';
part 'switch.dart';
part 'wireless_con.dart';
part 'wireless_host.dart';

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
      case SimObjectType.accessPoint:
        return AccessPoint.fromMap(map);
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
      case SimObjectType.wirelessCon:
        return WirelessCon.fromMap(map);
      case SimObjectType.wirelessHost:
        return WirelessHost.fromMap(map);
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
