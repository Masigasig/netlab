class Device {
  final String id;
  final String name;
  final String type;
  final double posX;
  final double posY;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.posX,
    required this.posY,
  });

  Device copyWith({
    String? id,
    String? name,
    String? type,
    double? posX,
    double? posY,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }
}
