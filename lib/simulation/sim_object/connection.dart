part of 'sim_object.dart';

class Connection extends SimObject {
  final String conA;
  final String conB;

  const Connection({required super.id, required this.conA, required this.conB})
    : super(type: SimObjectType.connection);

  @override
  Connection copyWith({String? conA, String? conB}) {
    return Connection(id: id, conA: conA ?? this.conA, conB: conB ?? this.conB);
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'conA': conA, 'conB': conB};
  }

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      id: map['id'] as String,
      conA: map['conA'] as String,
      conB: map['conB'] as String,
    );
  }
}
