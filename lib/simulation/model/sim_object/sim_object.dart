part 'connection.dart';
part 'device.dart';
part 'host.dart';
part 'router.dart';
part 'switch.dart';

enum SimObjectType { router, switch_, host, connection }

abstract class SimObject {
  final String id;
  final SimObjectType type;

  SimObject({required this.id, required this.type});
}

extension SimObjectTypeX on SimObjectType {
  String get label {
    switch (this) {
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
      case SimObjectType.host:
        return 'Host';
      case SimObjectType.connection:
        return 'Connection';
    }
  }
}
