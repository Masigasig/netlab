enum SimObjectType { connection, host, message, router, switch_ }

extension SimObjectTypeLabel on SimObjectType {
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

extension EthLabel on Eth {
  String get label {
    switch (this) {
      case Eth.eth0:
        return 'Interface 0';
      case Eth.eth1:
        return 'Interface 1';
      case Eth.eth2:
        return 'Interface 2';
      case Eth.eth3:
        return 'Interface 3';
    }
  }
}

enum Port { port0, port1, port2, port3, port4, port5 }

enum RouteType { directed, static_, dynamic_ }

extension RouteTypeLabel on RouteType {
  String get label {
    switch (this) {
      case RouteType.directed:
        return 'Directed';
      case RouteType.static_:
        return 'Static';
      case RouteType.dynamic_:
        return 'Dynamic';
    }
  }
}

enum MessageKey { targetIp, senderIp, operation, destination, source, type }

enum DataLinkLayerType { arp, ipv4 }

enum OperationType { request, reply }
