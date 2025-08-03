import 'dart:math';

final List<String> _macStorage = [];

String generateUniqueMacAddress() {
  final rng = Random();
  String mac;

  do {
    mac = List.generate(6, (_) {
      int byte = rng.nextInt(256);
      return byte.toRadixString(16).padLeft(2, '0');
    }).join(':').toUpperCase();
  } while (_macStorage.contains(mac) ||
      mac == 'FF:FF:FF:FF:FF:FF' || //BroadCast Address
      mac ==
          '00:00:00:00:00:00' //Uninitialized/invalid
          );

  _macStorage.add(mac);
  return mac;
}

bool isValidIpForSubnet(String ip, String subnet) {
  if (!isValidIp(ip) || !isValidSubnet(subnet)) return false;
  final network = getNetworkAddress(ip, subnet);
  final broadcast = getBroadcastAddress(ip, subnet);
  return ip != network && ip != broadcast;
}

String _normalizeSubnet(String subnet) {
  if (!subnet.startsWith('/')) return subnet;
  final cidr = int.parse(subnet.substring(1));
  final mask = -1 << (32 - cidr);
  return [
    (mask >> 24) & 255,
    (mask >> 16) & 255,
    (mask >> 8) & 255,
    mask & 255,
  ].join('.');
}

bool isValidIp(String ip) {
  final regex = RegExp(
    r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$',
  );
  return regex.hasMatch(ip);
}

bool isValidSubnet(String subnet) {
  if (subnet.startsWith('/')) {
    final cidr = int.tryParse(subnet.substring(1));
    return cidr != null && cidr >= 0 && cidr <= 32;
  }
  const validMasks = {
    '0.0.0.0',
    '128.0.0.0',
    '192.0.0.0',
    '224.0.0.0',
    '240.0.0.0',
    '248.0.0.0',
    '252.0.0.0',
    '254.0.0.0',
    '255.0.0.0',
    '255.128.0.0',
    '255.192.0.0',
    '255.224.0.0',
    '255.240.0.0',
    '255.248.0.0',
    '255.252.0.0',
    '255.254.0.0',
    '255.255.0.0',
    '255.255.128.0',
    '255.255.192.0',
    '255.255.224.0',
    '255.255.240.0',
    '255.255.248.0',
    '255.255.252.0',
    '255.255.254.0',
    '255.255.255.0',
    '255.255.255.128',
    '255.255.255.192',
    '255.255.255.224',
    '255.255.255.240',
    '255.255.255.248',
    '255.255.255.252',
    '255.255.255.254',
    '255.255.255.255',
  };
  return validMasks.contains(subnet);
}

String getNetworkAddress(String ip, String subnet) {
  if (!isValidIp(ip)) return 'Not Valid IP address';
  final ipParts = ip.split('.').map(int.parse).toList();
  if (!isValidSubnet(subnet)) return 'Not Valid Subnetmask';
  final subnetParts = _normalizeSubnet(
    subnet,
  ).split('.').map(int.parse).toList();
  final networkParts = List.generate(4, (i) => ipParts[i] & subnetParts[i]);
  return networkParts.join('.');
}

String getBroadcastAddress(String ip, String subnet) {
  if (!isValidIp(ip)) return 'Not Valid IP address';
  final ipParts = ip.split('.').map(int.parse).toList();
  if (!isValidSubnet(subnet)) return 'Not Valid Subnetmask';
  final subnetParts = _normalizeSubnet(
    subnet,
  ).split('.').map(int.parse).toList();
  final broadcastParts = List.generate(
    4,
    (i) => ipParts[i] | (~subnetParts[i] & 255),
  );
  return broadcastParts.join('.');
}
