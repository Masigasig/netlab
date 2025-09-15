part of 'sim_object.dart';

class Router extends Device {
  final String eth0IpAddress;
  final String eth1IpAddress;
  final String eth2IpAddress;
  final String eth3IpAddress;

  final String eth0SubnetMask;
  final String eth1SubnetMask;
  final String eth2SubnetMask;
  final String eth3SubnetMask;

  final String eth0MacAddress;
  final String eth1MacAddress;
  final String eth2MacAddress;
  final String eth3MacAddress;

  final String eth0conId;
  final String eth1conId;
  final String eth2conId;
  final String eth3conId;

  final Map<String, String> arpTable;
  final Map<String, Map<String, String>> routingTable;
  /* Sample of the routing table 
  {
    192.168.0.0/24(network address + subnet mask): {
      'type': (either Directed, Static, Dynamic),
      'interface': either 'eth0' or some Ip address
    },
  }

  */

  Map<String, String> get conIdToMacMap => {
    eth0conId: eth0MacAddress,
    eth1conId: eth1MacAddress,
    eth2conId: eth2MacAddress,
    eth3conId: eth3MacAddress,
  };

  Map<String, String> get conIdToIpAddMap => {
    eth0conId: eth0IpAddress,
    eth1conId: eth1IpAddress,
    eth2conId: eth2IpAddress,
    eth3conId: eth3IpAddress,
  };

  Map<String, String> get conIdToSubNetMap => {
    eth0conId: eth0SubnetMask,
    eth1conId: eth1SubnetMask,
    eth2conId: eth2SubnetMask,
    eth3conId: eth3SubnetMask,
  };

  Map<String, String> get ethToConId => {
    'eth0': eth0conId,
    'eth1': eth1conId,
    'eth2': eth2conId,
    'eth3': eth3conId,
  };

  const Router({
    required super.id,
    required super.name,
    required super.posX,
    required super.posY,
    this.eth0IpAddress = '',
    this.eth1IpAddress = '',
    this.eth2IpAddress = '',
    this.eth3IpAddress = '',
    this.eth0SubnetMask = '',
    this.eth1SubnetMask = '',
    this.eth2SubnetMask = '',
    this.eth3SubnetMask = '',
    required this.eth0MacAddress,
    required this.eth1MacAddress,
    required this.eth2MacAddress,
    required this.eth3MacAddress,
    this.eth0conId = '',
    this.eth1conId = '',
    this.eth2conId = '',
    this.eth3conId = '',
    this.arpTable = const {},
    this.routingTable = const {},
  }) : super(type: SimObjectType.router);

  @override
  Router copyWith({
    double? posX,
    double? posY,
    String? eth0IpAddress,
    String? eth1IpAddress,
    String? eth2IpAddress,
    String? eth3IpAddress,
    String? eth0SubnetMask,
    String? eth1SubnetMask,
    String? eth2SubnetMask,
    String? eth3SubnetMask,
    String? eth0conId,
    String? eth1conId,
    String? eth2conId,
    String? eth3conId,
    Map<String, String>? arpTable,
    Map<String, Map<String, String>>? routingTable,
  }) {
    return Router(
      id: id,
      name: name,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      eth0IpAddress: eth0IpAddress ?? this.eth0IpAddress,
      eth1IpAddress: eth1IpAddress ?? this.eth1IpAddress,
      eth2IpAddress: eth2IpAddress ?? this.eth2IpAddress,
      eth3IpAddress: eth3IpAddress ?? this.eth3IpAddress,
      eth0SubnetMask: eth0SubnetMask ?? this.eth0SubnetMask,
      eth1SubnetMask: eth1SubnetMask ?? this.eth1SubnetMask,
      eth2SubnetMask: eth2SubnetMask ?? this.eth2SubnetMask,
      eth3SubnetMask: eth3SubnetMask ?? this.eth3SubnetMask,
      eth0MacAddress: eth0MacAddress,
      eth1MacAddress: eth1MacAddress,
      eth2MacAddress: eth2MacAddress,
      eth3MacAddress: eth3MacAddress,
      eth0conId: eth0conId ?? this.eth0conId,
      eth1conId: eth1conId ?? this.eth1conId,
      eth2conId: eth2conId ?? this.eth2conId,
      eth3conId: eth3conId ?? this.eth3conId,
      arpTable: arpTable ?? Map<String, String>.from(this.arpTable),
      routingTable:
          routingTable ??
          Map<String, Map<String, String>>.from(this.routingTable),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'eth0IpAddress': eth0IpAddress,
      'eth1IpAddress': eth1IpAddress,
      'eth2IpAddress': eth2IpAddress,
      'eth3IpAddress': eth3IpAddress,
      'eth0SubnetMask': eth0SubnetMask,
      'eth1SubnetMask': eth1SubnetMask,
      'eth2SubnetMask': eth2SubnetMask,
      'eth3SubnetMask': eth3SubnetMask,
      'eth0MacAddress': eth0MacAddress,
      'eth1MacAddress': eth1MacAddress,
      'eth2MacAddress': eth2MacAddress,
      'eth3MacAddress': eth3MacAddress,
      'eth0conId': eth0conId,
      'eth1conId': eth1conId,
      'eth2conId': eth2conId,
      'eth3conId': eth3conId,
      'routingTable': routingTable,
    };
  }

  factory Router.fromMap(Map<String, dynamic> map) {
    return Router(
      id: map['id'].toString(),
      name: map['name'].toString(),
      posX: map['posX'].toDouble(),
      posY: map['posY'].toDouble(),
      eth0IpAddress: map['eth0IpAddress']?.toString() ?? '',
      eth1IpAddress: map['eth1IpAddress']?.toString() ?? '',
      eth2IpAddress: map['eth2IpAddress']?.toString() ?? '',
      eth3IpAddress: map['eth3IpAddress']?.toString() ?? '',

      eth0SubnetMask: map['eth0SubnetMask']?.toString() ?? '',
      eth1SubnetMask: map['eth1SubnetMask']?.toString() ?? '',
      eth2SubnetMask: map['eth2SubnetMask']?.toString() ?? '',
      eth3SubnetMask: map['eth3SubnetMask']?.toString() ?? '',

      eth0MacAddress: map['eth0MacAddress'].toString(),
      eth1MacAddress: map['eth1MacAddress'].toString(),
      eth2MacAddress: map['eth2MacAddress'].toString(),
      eth3MacAddress: map['eth3MacAddress'].toString(),

      eth0conId: map['eth0conId']?.toString() ?? '',
      eth1conId: map['eth1conId']?.toString() ?? '',
      eth2conId: map['eth2conId']?.toString() ?? '',
      eth3conId: map['eth3conId']?.toString() ?? '',

      routingTable:
          (map['routingTable'] as Map?)?.map(
            (key, value) => MapEntry(
              key.toString(),
              Map<String, String>.from(value as Map),
            ),
          ) ??
          {},
    );
  }
}
