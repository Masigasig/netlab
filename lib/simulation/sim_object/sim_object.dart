part 'connection.dart';
part 'device.dart';
part 'host.dart';
part 'router.dart';
part 'switch.dart';
part 'message.dart';

enum SimObjectType { connection, host, message, router, switch_ }

abstract class SimObject {
  final String id;
  final SimObjectType type;

  const SimObject({required this.id, required this.type});

  SimObject copyWith();

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type.name};
  }
}
