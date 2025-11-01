part of 'sim_object.dart';

class Connection extends SimObject {
  final String conAId;
  final String conBId;

  const Connection({
    required super.id,
    required super.name,
    required this.conAId,
    required this.conBId,
  }) : super(type: SimObjectType.connection);

  @override
  Connection copyWith({String? name}) {
    return Connection(
      id: id,
      name: name ?? this.name,
      conAId: conAId,
      conBId: conBId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'conAId': conAId, 'conBId': conBId};
  }

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      id: map['id'].toString(),
      name: map['name'].toString(),
      conAId: map['conAId'].toString(),
      conBId: map['conBId'].toString(),
    );
  }
}
