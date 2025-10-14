import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Tools',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const NetworkToolsScreen(),
    );
  }
}

class NetworkToolsScreen extends StatefulWidget {
  const NetworkToolsScreen({super.key});

  @override
  State<NetworkToolsScreen> createState() => _NetworkToolsScreenState();
}

class _NetworkToolsScreenState extends State<NetworkToolsScreen> {
  // Analyzer
  final ipController = TextEditingController(text: '192.168.1.10');
  final cidrController = TextEditingController(text: '24');

  // IP Converter
  String ipConvType = 'Decimal to Binary';
  final ipConvController = TextEditingController();

  // Subnet Converter
  String subnetConvType = 'CIDR to Subnet';
  final subnetConvController = TextEditingController();

  @override
  void dispose() {
    ipController.dispose();
    cidrController.dispose();
    ipConvController.dispose();
    subnetConvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Tools'), centerTitle: true),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAnalyzer(),
                const SizedBox(height: 24),
                _buildIPConverter(),
                const SizedBox(height: 24),
                _buildSubnetConverter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzer() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'IP & Subnet Analyzer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      labelText: 'IP Address',
                      border: OutlineInputBorder(),
                      hintText: '192.168.1.10',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: cidrController,
                    decoration: const InputDecoration(
                      labelText: 'CIDR',
                      border: OutlineInputBorder(),
                      hintText: '24',
                      prefixText: '/',
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                e.toString(),
                style: TextStyle(color: Colors.red.shade700, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildIPConverter() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'IP Address Converter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Conversion Type',
                border: OutlineInputBorder(),
              ),
              initialValue: ipConvType,
              items: const [
                DropdownMenuItem(
                  value: 'Decimal to Binary',
                  child: Text('Decimal → Binary'),
                ),
                DropdownMenuItem(
                  value: 'Decimal to Hex',
                  child: Text('Decimal → Hex'),
                ),
                DropdownMenuItem(
                  value: 'Binary to Decimal',
                  child: Text('Binary → Decimal'),
                ),
                DropdownMenuItem(
                  value: 'Binary to Hex',
                  child: Text('Binary → Hex'),
                ),
                DropdownMenuItem(
                  value: 'Hex to Decimal',
                  child: Text('Hex → Decimal'),
                ),
                DropdownMenuItem(
                  value: 'Hex to Binary',
                  child: Text('Hex → Binary'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  ipConvType = value!;
                  ipConvController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ipConvController,
              decoration: InputDecoration(
                labelText: _getIPLabel(ipConvType),
                border: const OutlineInputBorder(),
                hintText: _getIPHint(ipConvType),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (ipConvController.text.isNotEmpty) _buildIPConvResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubnetConverter() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subnet Converter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Conversion Type',
                border: OutlineInputBorder(),
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
                labelText: subnetConvType == 'CIDR to Subnet'
                    ? 'CIDR'
                    : 'Subnet Mask',
                border: const OutlineInputBorder(),
                hintText: subnetConvType == 'CIDR to Subnet'
                    ? '24'
                    : '255.255.255.0',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (subnetConvController.text.isNotEmpty) _buildSubnetConvResult(),
          ],
        ),
      ),
    );
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

  Widget _buildIPConvResult() {
    try {
      final result = _convertIP(ipConvType, ipConvController.text);
      return Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            result,
            style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
          ),
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                e.toString(),
                style: TextStyle(color: Colors.red.shade700, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSubnetConvResult() {
    try {
      final result = subnetConvType == 'CIDR to Subnet'
          ? _cidrToSubnet(subnetConvController.text)
          : _subnetToCidr(subnetConvController.text);
      return Card(
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            result,
            style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
          ),
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                e.toString(),
                style: TextStyle(color: Colors.red.shade700, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _getIPLabel(String type) {
    if (type.startsWith('Decimal')) return 'IP Address';
    if (type.startsWith('Binary')) return 'Binary IP';
    return 'Hex IP';
  }

  String _getIPHint(String type) {
    if (type.startsWith('Decimal')) return '192.168.1.1';
    if (type.startsWith('Binary')) return '11000000.10101000.00000001.00000001';
    return 'C0.A8.01.01';
  }

  Map<String, String> _analyzeNetwork(String ipStr, String cidrStr) {
    // Validate CIDR
    final cidr = int.tryParse(cidrStr);
    if (cidr == null) {
      throw Exception('Invalid CIDR format. Please enter a number (e.g., 24)');
    }
    if (cidr < 0 || cidr > 32) {
      throw Exception('CIDR must be between 0 and 32. You entered: $cidr');
    }

    // Validate IP format
    final parts = ipStr.split('.');
    if (parts.length != 4) {
      throw Exception(
        'Invalid IP format. Must have 4 octets separated by dots (e.g., 192.168.1.10)',
      );
    }

    // Validate each octet
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

  String _convertIP(String type, String input) {
    switch (type) {
      case 'Decimal to Binary':
        return input
            .split('.')
            .map((e) => int.parse(e).toRadixString(2).padLeft(8, '0'))
            .join('.');
      case 'Decimal to Hex':
        return input
            .split('.')
            .map(
              (e) =>
                  int.parse(e).toRadixString(16).toUpperCase().padLeft(2, '0'),
            )
            .join('.');
      case 'Binary to Decimal':
        return input
            .split('.')
            .map((e) => int.parse(e, radix: 2).toString())
            .join('.');
      case 'Binary to Hex':
        final dec = input
            .split('.')
            .map((e) => int.parse(e, radix: 2).toString())
            .join('.');
        return dec
            .split('.')
            .map(
              (e) =>
                  int.parse(e).toRadixString(16).toUpperCase().padLeft(2, '0'),
            )
            .join('.');
      case 'Hex to Decimal':
        return input
            .split('.')
            .map((e) => int.parse(e, radix: 16).toString())
            .join('.');
      case 'Hex to Binary':
        final dec = input
            .split('.')
            .map((e) => int.parse(e, radix: 16).toString())
            .join('.');
        return dec
            .split('.')
            .map((e) => int.parse(e).toRadixString(2).padLeft(8, '0'))
            .join('.');
      default:
        return '';
    }
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
}
