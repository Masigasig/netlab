import 'package:flutter/material.dart';

import 'package:netlab/core/themes/app_color.dart';

class SubnetConverter extends StatefulWidget {
  const SubnetConverter({super.key});

  @override
  State<SubnetConverter> createState() => _SubnetConverterState();
}

class _SubnetConverterState extends State<SubnetConverter> {
  String subnetConvType = 'CIDR to Subnet';
  final subnetConvController = TextEditingController();

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
                'Subnet Mask Converter',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              // Add your subnet conversion UI elements here
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  label: Text(
                    'Conversion Type :',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
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
                initialValue: subnetConvType,
                items: const [
                  DropdownMenuItem(
                    value: 'CIDR to Subnet',
                    child: Text('CIDR → Subnet Mask'),
                  ),
                  DropdownMenuItem(
                    value: 'Subnet to CIDR',
                    child: Text('Subnet Mask → CIDR'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    subnetConvType = value!;
                    subnetConvController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: subnetConvController,
                decoration: InputDecoration(
                  label: Text(
                    subnetConvType == 'CIDR to Subnet' ? 'CIDR' : 'Subnet Mask',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  hintText: subnetConvType == 'CIDR to Subnet'
                      ? '24'
                      : '255.255.255.0',
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
              const SizedBox(height: 16),
              if (subnetConvController.text.isNotEmpty)
                _buildSubnetConvResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubnetConvResult() {
    try {
      final result = subnetConvType == 'CIDR to Subnet'
          ? _cidrToSubnet(subnetConvController.text)
          : _subnetToCidr(subnetConvController.text);
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          result,
          style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
        ),
      );
    } catch (e) {
      final errorMessage = _getFriendlySubnetError(e, subnetConvType);
      return Container(
        padding: const EdgeInsets.all(16),
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
                errorMessage,
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

  String _getFriendlySubnetError(Object e, String type) {
    if (e is FormatException || e is RangeError || e is Exception) {
      if (type == 'CIDR to Subnet') {
        return 'Invalid CIDR value. Please enter a number between 0 and 32 (e.g., 24).';
      } else {
        return 'Invalid subnet mask format. Please enter a valid IPv4 subnet mask like 255.255.255.0.';
      }
    }
    return 'Unexpected error: ${e.toString().replaceFirst('Exception: ', '')}';
  }

  String _cidrToSubnet(String cidr) {
    final c = int.parse(cidr);
    if (c < 0 || c > 32) throw Exception('CIDR must be 0-32');

    final mask = (0xFFFFFFFF << (32 - c)) & 0xFFFFFFFF;
    final dec = _intToIp(mask);
    final bin = _ipToBinary(dec);

    return 'Decimal: $dec\nBinary: $bin';
  }

  String _subnetToCidr(String subnet) {
    final octets = subnet.split('.').map(int.parse).toList();
    final mask =
        (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];

    int cidr = 0;
    int temp = mask;
    while (temp != 0) {
      cidr += temp & 1;
      temp >>= 1;
    }

    return '/$cidr';
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
