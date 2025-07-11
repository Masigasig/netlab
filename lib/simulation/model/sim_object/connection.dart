part of 'sim_object.dart';

class Connection extends SimObject {
  final String conA;
  final String conB;

  Connection({required super.id, required this.conA, required this.conB})
    : super(type: SimObjectType.connection);
}
