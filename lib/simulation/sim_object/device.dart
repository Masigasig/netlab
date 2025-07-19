part of 'sim_object.dart';

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
