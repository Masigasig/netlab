part of 'sim_object.dart';

class Connection extends SimObject {
  final String conAId;
  final String conBId;

  const Connection({
    required super.id,
    required this.conAId,
    required this.conBId,
  }) : super(type: SimObjectType.connection);

  @override
  Connection copyWith() {
    return Connection(id: id, conAId: conAId, conBId: conBId);
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'conAId': conAId, 'conBId': conBId};
  }

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      id: map['id'].toString(),
      conAId: map['conAId'].toString(),
      conBId: map['conBId'].toString(),
    );
  }
}
