import 'package:flutter/material.dart';

import 'package:netlab/core/themes/app_color.dart';

class IpConverter extends StatefulWidget {
  const IpConverter({super.key});

  @override
  State<IpConverter> createState() => _IpConverterState();
}

class _IpConverterState extends State<IpConverter> {
  String ipConvType = 'Decimal to Binary';
  final ipConvController = TextEditingController();

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
                'IPv4 Converter',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
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
                  label: Text(
                    _getIPLabel(ipConvType),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  hintText: _getIPHint(ipConvType),
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
              if (ipConvController.text.isNotEmpty) _buildIPConvResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIPConvResult() {
    try {
      final result = _convertIP(ipConvType, ipConvController.text);
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          result,
          style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
        ),
      );
    } catch (e) {
      final errorMessage = _getFriendlyErrorMessage(e, ipConvType);
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

  String _getFriendlyErrorMessage(Object e, String type) {
    if (e is FormatException || e is RangeError || e is Exception) {
      switch (type) {
        case 'Decimal to Binary':
        case 'Decimal to Hex':
          return 'Please enter a valid IPv4 address in decimal format (e.g., 192.168.1.1). Each octet must be between 0 and 255.';
        case 'Binary to Decimal':
        case 'Binary to Hex':
          return 'Please enter a valid binary IP (e.g., 11000000.10101000.00000001.00000001). Each octet must be 8 bits.';
        case 'Hex to Decimal':
        case 'Hex to Binary':
          return 'Please enter a valid hexadecimal IP (e.g., C0.A8.01.01). Each octet must be two hex digits.';
        default:
          return 'Invalid input format. Please check your entry and try again.';
      }
    }
    return 'Unexpected error: ${e.toString().replaceFirst('Exception: ', '')}';
  }

  String _getIPLabel(String type) {
    if (type.startsWith('Decimal')) return 'IP Address :';
    if (type.startsWith('Binary')) return 'Binary IP :';
    return 'Hex IP :';
  }

  String _getIPHint(String type) {
    if (type.startsWith('Decimal')) return '192.168.1.1';
    if (type.startsWith('Binary')) return '11000000.10101000.00000001.00000001';
    return 'C0.A8.01.01';
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
}
