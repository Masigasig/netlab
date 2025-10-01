import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/core/ipv4_address_manager.dart';

class Validator {
  static String? validateName(String? input) =>
      (input == null || input.trim().isEmpty) ? 'Name is required' : null;

  static String? validateIpAddress(String? input, String subnetMask) {
    if (input == null || input.trim().isEmpty) return null;
    if (!Ipv4AddressManager.isValidIp(input)) return 'Invalid Ipv4 Address';
    if (subnetMask.isEmpty) return 'Input subnetMask First';
    if (!Ipv4AddressManager.isValidIpForSubnet(input, subnetMask)) {
      return 'Invalid Ipv4 Address for your subnetMask';
    }
    if (!Ipv4AddressManager.addIp(input)) {
      return 'IP Address already exists';
    }
    return null;
  }

  static String? validateSubnetMask(String? input, String ipAddress) {
    if (input == null || input.trim().isEmpty) return 'Subnet Mask is required';
    if (!Ipv4AddressManager.isValidSubnet(input)) {
      return 'Invalid Subnet Mask, use (255.255.255.0) or (/24)';
    }
    if (ipAddress.isNotEmpty &&
        !Ipv4AddressManager.isValidIpForSubnet(ipAddress, input)) {
      return 'Invalid Subnet Mask for your Ip, change your IP first';
    }
    return null;
  }

  static String? validateDefaultGateway(String? input) =>
      (input != null &&
          input.trim().isNotEmpty &&
          !Ipv4AddressManager.isValidIp(input))
      ? 'Invalid Default GateWay'
      : null;

  static String? validateIpOnRouterInterface(
    String? input,
    String subnetMask,
    Map<String, Map<String, String>> routingTable,
  ) {
    final error = validateIpAddress(input, subnetMask);
    if (error != null) return error;

    final networkAddress = Ipv4AddressManager.getNetworkAddress(
      input!,
      subnetMask,
    );
    if (routingTable.containsKey(networkAddress + subnetMask)) {
      return 'Network Id is already in Routing Table';
    }
    return null;
  }

  static String? validateSubnetOnRouterInterface(
    String? input,
    String ipAddress,
    Map<String, Map<String, String>> routingTable,
  ) {
    final error = validateSubnetMask(input, ipAddress);
    if (error != null) return error;

    final networkAddress = Ipv4AddressManager.getNetworkAddress(
      ipAddress,
      input!,
    );
    if (routingTable.containsKey(networkAddress + input)) {
      return 'Network Id is already in Routing Table';
    }
    return null;
  }

  static String? validateNetworkId(
    String? input,
    String subnetMask,
    Map<String, Map<String, String>> routingTable,
  ) {
    if (input == null || input.trim().isEmpty) {
      return 'Network ID is required';
    }

    if (!Ipv4AddressManager.isValidIp(input)) {
      return 'Invalid Network ID format';
    }

    final calculatedNetwork = Ipv4AddressManager.getNetworkAddress(
      input,
      subnetMask,
    );
    if (input != calculatedNetwork) {
      return 'This is not a valid network address';
    }

    if (routingTable.containsKey(input + subnetMask)) {
      return 'This network is already in the routing table';
    }

    return null;
  }

  static String? validateStaticRouteSubnet(String? input, String networkId) {
    if (input == null || input.trim().isEmpty) {
      return 'Subnet mask is required';
    }

    if (!Ipv4AddressManager.isValidSubnet(input)) {
      return 'Invalid subnet mask format, use (255.255.255.0) or (/24)';
    }

    return null;
  }

  static String? validateStaticRouteInterface(String? input, String subnet) {
    if (input == null || input.trim().isEmpty) {
      return 'Interface is required';
    }

    if (Ipv4AddressManager.isValidIp(input)) {
      final networkAddress = Ipv4AddressManager.getNetworkAddress(
        input,
        subnet,
      );
      if (networkAddress == input) {
        return 'Interface must not be a network ID';
      }
      return null;
    }

    final validInterfaces = Eth.values.map((e) => e.name).toList();
    if (!validInterfaces.contains(input)) {
      return 'Interface must be a valid IP or one of: ${validInterfaces.join(', ')}';
    }

    return null;
  }
}
