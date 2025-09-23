class LogEntry {
  final String message;
  final String time;
  final LogType type;

  LogEntry({required this.message, required this.time, required this.type});
}

enum LogType { info, success, error }
