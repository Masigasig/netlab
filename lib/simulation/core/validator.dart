import 'package:netlab/simulation/core/ipv4_address_manager.dart';

class Validator {
  static String? validateName(String? input) {
    if (input == null || input.trim().isEmpty) return 'Name is required';
    return null;
  }

  static String? validateIpAddress(String? input, String subnetMask) {
    if (input == null || input.trim().isEmpty) return null;
    if (!Ipv4AddressManager.isValidIp(input)) return 'Invalid Ipv4 Address';
    if (subnetMask.isEmpty) return 'Input subnetMask First';
    if (!Ipv4AddressManager.isValidIpForSubnet(input, subnetMask)) {
      return 'Invalid Ipv4 Address for your subnetMask';
    }
    return null;
  }

  static String? validateSubnetMask(String? input, String ipAddress) {
    if (input == null || input.trim().isEmpty) return 'Subnet Mask is required';
    if (!Ipv4AddressManager.isValidSubnet(input)) {
      return 'Invalid Subnet Mask, use (255.255.255.0) or (/24)';
    }
    if (ipAddress.isEmpty) return null;
    if (!Ipv4AddressManager.isValidIpForSubnet(ipAddress, input)) {
      return 'Invalid Subnet Mask for your Ip, change you IP first';
    }
    return null;
  }

  static String? validateDefaultGateway(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    if (!Ipv4AddressManager.isValidIp(input)) return 'Invalid Default GateWay';
    return null;
  }

  static String? validateIpOnRouterInterface(
    String? input,
    String subnetMask,
    Map<String, Map<String, String>> routingTable,
  ) {
    if (input == null || input.trim().isEmpty) return null;
    if (!Ipv4AddressManager.isValidIp(input)) return 'Invalid Ipv4 Address';
    if (subnetMask.isEmpty) return 'Input subnetMask First';
    if (!Ipv4AddressManager.isValidIpForSubnet(input, subnetMask)) {
      return 'Invalid Ipv4 Address for your subnetMask';
    }

    final networkAddress = Ipv4AddressManager.getNetworkAddress(
      input,
      subnetMask,
    );

    if (routingTable.containsKey(networkAddress + subnetMask)) {
      return 'Network Id is already in Routing Table';
    }
    return null;
  }

  static String? validatSubnetOnRouterInterface(
    String? input,
    String ipAddress,
    Map<String, Map<String, String>> routingTable,
  ) {
    if (input == null || input.trim().isEmpty) return 'Subnet Mask is required';
    if (!Ipv4AddressManager.isValidSubnet(input)) {
      return 'Invalid Subnet Mask, use (255.255.255.0) or (/24)';
    }
    if (ipAddress.isEmpty) return null;
    if (!Ipv4AddressManager.isValidIpForSubnet(ipAddress, input)) {
      return 'Invalid Subnet Mask for your Ip, change you IP first';
    }

    final networkAddress = Ipv4AddressManager.getNetworkAddress(
      ipAddress,
      input,
    );

    if (routingTable.containsKey(networkAddress + input)) {
      return 'Network Id is already in Routing Table';
    }
    return null;
  }
}
