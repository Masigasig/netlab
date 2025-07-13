part of 'sim_object.dart';

abstract class Device extends SimObject {
  final double posX;
  final double posY;
  final String name;

  Device({
    required super.id,
    required super.type,
    required this.posX,
    required this.posY,
    required this.name,
  });

  Device copyWith({double? posX, double? posY});
}
