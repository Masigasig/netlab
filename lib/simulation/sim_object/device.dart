part of 'sim_object.dart';

abstract class Device extends SimObject {
  final double posX;
  final double posY;

  Device({
    required super.id,
    required super.type,
    required this.posX,
    required this.posY,
  });

  Device copyWith({String? id, double? posX, double? posY});
}
