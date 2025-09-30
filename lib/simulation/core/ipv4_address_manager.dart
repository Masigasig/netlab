class Ipv4AddressManager {
  static final Set<String> _ipv4Storage = {};

  static const _validSubnetMasks = {
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

  static String _normalizeSubnet(String subnet) {
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

  static bool isValidIp(String ip) {
    final regex = RegExp(
      r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$',
    );
    return regex.hasMatch(ip);
  }

  static bool isValidSubnet(String subnet) {
    if (subnet.startsWith('/')) {
      final cidr = int.tryParse(subnet.substring(1));
      return cidr != null && cidr >= 0 && cidr <= 32;
    }

    return _validSubnetMasks.contains(subnet);
  }

  static String getNetworkAddress(String ip, String subnet) {
    if (ip.isEmpty || subnet.isEmpty) return 'Ip and Subnet required';
    if (!isValidIp(ip)) return 'Not Valid IP address';
    if (!isValidSubnet(subnet)) return 'Not Valid Subnetmask';

    final ipParts = ip.split('.').map(int.parse).toList();
    final subnetParts = _normalizeSubnet(
      subnet,
    ).split('.').map(int.parse).toList();
    final networkParts = List.generate(4, (i) => ipParts[i] & subnetParts[i]);

    return networkParts.join('.');
  }

  static String getBroadcastAddress(String ip, String subnet) {
    if (!isValidIp(ip)) return 'Not Valid IP address';
    if (!isValidSubnet(subnet)) return 'Not Valid Subnetmask';

    final ipParts = ip.split('.').map(int.parse).toList();
    final subnetParts = _normalizeSubnet(
      subnet,
    ).split('.').map(int.parse).toList();
    final broadcastParts = List.generate(
      4,
      (i) => ipParts[i] | (~subnetParts[i] & 255),
    );
    return broadcastParts.join('.');
  }

  static bool isValidIpForSubnet(String ip, String subnet) {
    if (!isValidIp(ip) || !isValidSubnet(subnet)) return false;
    final network = getNetworkAddress(ip, subnet);
    final broadcast = getBroadcastAddress(ip, subnet);
    return ip != network && ip != broadcast;
  }

  static bool isInSameNetwork(String ip1, String subnet, String ip2) {
    if (!isValidIp(ip1) ||
        !isValidIp(ip2) ||
        !isValidSubnet(subnet) ||
        !isValidIpForSubnet(ip1, subnet) ||
        !isValidIpForSubnet(ip2, subnet)) {
      return false;
    }

    final network1 = getNetworkAddress(ip1, subnet);
    final network2 = getNetworkAddress(ip2, subnet);
    return network1 == network2;
  }

  static String subnetToCidr(String subnetMask) {
    if (subnetMask.startsWith('/')) return subnetMask;
    final bits = subnetMask
        .split('.')
        .map(int.parse)
        .map((octet) => octet.toRadixString(2))
        .join();

    final prefixLength = bits.replaceAll('0', '').length;
    return '/$prefixLength';
  }

  static Map<String, dynamic> exportStorage() {
    return {'ipv4Addresses': _ipv4Storage.toList()};
  }

  static void importStorage(Map<String, dynamic> data) {
    final ipList = data['ipv4Addresses'];
    if (ipList is List) {
      _ipv4Storage
        ..clear()
        ..addAll(ipList.whereType<String>());
    }
  }
}
