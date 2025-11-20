part of 'sim_object.dart';

class WirelessCon extends SimObject {
  final String conAId;
  final String conBId;

  WirelessCon({
    required super.id,
    required super.name,
    required this.conAId,
    required this.conBId,
  }) : super(type: SimObjectType.wirelessCon);

  @override
  WirelessCon copyWith({String? name}) {
    return WirelessCon(
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

  factory WirelessCon.fromMap(Map<String, dynamic> map) {
    return WirelessCon(
      id: map['id'].toString(),
      name: map['name'].toString(),
      conAId: map['conAId'].toString(),
      conBId: map['conBId'].toString(),
    );
  }
}
