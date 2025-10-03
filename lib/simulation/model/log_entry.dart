import 'package:netlab/simulation/core/enums.dart';

class LogEntry {
  final String message;
  final String time;
  final LogType type;

  const LogEntry({
    required this.message,
    required this.time,
    required this.type,
  });
}
