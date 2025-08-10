part of 'sim_object.dart';

class Connection extends SimObject {
  final String conAmac;
  final String conBmac;
  final String conAId;
  final String conBId;

  Map<String, String> get macToIdMap => {conAmac: conAId, conBmac: conBId};

  const Connection({
    required super.id,
    required this.conAmac,
    required this.conBmac,
    required this.conAId,
    required this.conBId,
  }) : super(type: SimObjectType.connection);

  @override
  Connection copyWith() {
    return Connection(
      id: id,
      conAmac: conAmac,
      conBmac: conBmac,
      conAId: conAId,
      conBId: conBId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'conAmac': conAmac,
      'conBmac': conBmac,
      'conAId': conAId,
      'conBId': conBId,
    };
  }

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      id: map['id'].toString(),
      conAmac: map['conAmac'].toString(),
      conBmac: map['conBmac'].toString(),
      conAId: map['conAId'].toString(),
      conBId: map['conBId'].toString(),
    );
  }
}
