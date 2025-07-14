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
