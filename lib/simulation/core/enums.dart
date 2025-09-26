enum SimObjectType { connection, host, message, router, switch_ }

extension Label on SimObjectType {
  String get label {
    switch (this) {
      case SimObjectType.connection:
        return 'Connection';
      case SimObjectType.host:
        return 'Host';
      case SimObjectType.message:
        return 'Message';
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
    }
  }
}

enum LogType { info, success, error }
