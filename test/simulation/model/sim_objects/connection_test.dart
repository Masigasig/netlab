import 'package:flutter_test/flutter_test.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/model/sim_objects/sim_object.dart';

void main() {
  late Connection connection;

  setUp(() {
    connection = const Connection(
      id: 'connId',
      name: 'connName',
      conAId: 'deviceId1',
      conBId: 'deviceId2',
    );
  });

  test('copyWith creates new Connection with updated properties', () {
    final updatedConnection = connection.copyWith(name: 'newName');

    expect(updatedConnection.id, connection.id);
    expect(updatedConnection.name, equals('newName'));
    expect(updatedConnection.conAId, connection.conAId);
    expect(updatedConnection.conBId, connection.conBId);
    expect(updatedConnection.type, SimObjectType.connection);
  });

  test('toMap and fromMap work correctly', () {
    final map = connection.toMap();
    final newConnection = Connection.fromMap(map);

    expect(newConnection.id, connection.id);
    expect(newConnection.name, connection.name);
    expect(newConnection.conAId, connection.conAId);
    expect(newConnection.conBId, connection.conBId);
    expect(newConnection.type, connection.type);
  });
}
