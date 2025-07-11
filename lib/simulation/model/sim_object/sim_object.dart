import 'package:netlab/core/constants/app_constants.dart' show SimObjectType;

part 'connection.dart';
part 'device.dart';
part 'host.dart';
part 'router.dart';
part 'switch.dart';

abstract class SimObject {
  final String id;
  final SimObjectType type;

  SimObject({required this.id, required this.type});
}
