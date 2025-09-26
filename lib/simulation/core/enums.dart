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

enum ConnInfoKey { name, conId }

enum Eth { eth0, eth1, eth2, eth3 }

enum Port { port0, port1, port2, port3, port4, port5 }
