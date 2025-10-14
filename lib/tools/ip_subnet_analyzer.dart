import 'package:flutter/material.dart';

import 'package:netlab/core/themes/app_color.dart';

class IpSubnetAnalyzer extends StatefulWidget {
  const IpSubnetAnalyzer({super.key});

  @override
  State<IpSubnetAnalyzer> createState() => _IpSubnetAnalyzerState();
}

class _IpSubnetAnalyzerState extends State<IpSubnetAnalyzer> {
  final ipController = TextEditingController(text: '192.168.1.2');
  final cidrController = TextEditingController(text: '24');

  @override
  void dispose() {
    ipController.dispose();
    cidrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'IP & Subnet Analyzer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      autofocus: true,
                      controller: ipController,
                      decoration: InputDecoration(
                        label: Text(
                          'IPv4 Address :',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        hintText: '192.168.1.2',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: cidrController,
                      decoration: InputDecoration(
                        prefixText: '/ ',
                        prefixStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        label: Text(
                          'SubnetMask(CIDR) :',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        hintText: '24',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildAnalyzerResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzerResults() {
    try {
      final result = _analyzeNetwork(ipController.text, cidrController.text);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: result.entries.map((e) => _buildRow(e.key, e.value)).toList(),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.errorColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.errorColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                e.toString().replaceFirst('Exception: ', ''),
                style: const TextStyle(
                  color: AppColors.errorColor,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _analyzeNetwork(String ipStr, String cidrStr) {
    //* Validate CIDR
    final cidr = int.tryParse(cidrStr);
    if (cidr == null) {
      throw Exception('Invalid CIDR format. Please enter a number (e.g., 24)');
    }
    if (cidr < 0 || cidr > 32) {
      throw Exception('CIDR must be between 0 and 32. You entered: $cidr');
    }

    //* Validate IP format
    final parts = ipStr.split('.');
    if (parts.length != 4) {
      throw Exception(
        'Invalid IP format. Must have 4 octets separated by dots (e.g., 192.168.1.10)',
      );
    }

    //* Validate each octet
    final octets = <int>[];
    for (int i = 0; i < parts.length; i++) {
      final val = int.tryParse(parts[i]);
      if (val == null) {
        throw Exception('Octet ${i + 1} is not a valid number: "${parts[i]}"');
      }
      if (val < 0 || val > 255) {
        throw Exception(
          'Octet ${i + 1} must be between 0-255. You entered: $val',
        );
      }
      octets.add(val);
    }

    final ipInt =
        (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask = (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
    final networkInt = ipInt & mask;
    final broadcastInt = networkInt | (~mask & 0xFFFFFFFF);
    final wildcardMask = (~mask) & 0xFFFFFFFF;
    final totalIps = 1 << (32 - cidr);
    final totalHosts = totalIps > 2 ? totalIps - 2 : 0;

    final ipClass = octets[0] <= 127
        ? 'A'
        : octets[0] <= 191
        ? 'B'
        : octets[0] <= 223
        ? 'C'
        : octets[0] <= 239
        ? 'D'
        : 'E';

    return {
      'Network ID': _intToIp(networkInt),
      'Broadcast IP': _intToIp(broadcastInt),
      'First Host IP': _intToIp(networkInt + 1),
      'Last Host IP': _intToIp(broadcastInt - 1),
      'Next Network': _intToIp(broadcastInt + 1),
      'Total Hosts': totalHosts.toString(),
      'Total IPs': totalIps.toString(),
      'Subnet Mask (Decimal)': _intToIp(mask),
      'Subnet Mask (Binary)': _ipToBinary(_intToIp(mask)),
      'Wildcard Mask': _intToIp(wildcardMask),
      'IP Class': ipClass,
    };
  }

  String _intToIp(int value) {
    return '${(value >> 24) & 0xFF}.${(value >> 16) & 0xFF}.${(value >> 8) & 0xFF}.${value & 0xFF}';
  }

  String _ipToBinary(String ip) {
    return ip
        .split('.')
        .map((e) => int.parse(e).toRadixString(2).padLeft(8, '0'))
        .join('.');
  }
}
