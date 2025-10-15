import 'package:flutter/material.dart';
import 'package:netlab/core/themes/app_color.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

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
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'IPv4 Converter',
                style: AppTextStyles.forSurface(
                  AppTextStyles.headerMedium,
                  context,
                ),
              ),
              const SizedBox(height: 24),

              // Conversion Type Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  label: Text(
                    'Conversion Type',
                    style: AppTextStyles.withColor(
                      AppTextStyles.subtitleMedium,
                      cs.secondary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: cs.secondary, width: 2),
                  ),
                ),
                style: AppTextStyles.forSurface(
                  AppTextStyles.bodyMedium,
                  context,
                ),
                initialValue: ipConvType,
                items: [
                  _buildDropdownItem(
                    'Decimal to Binary',
                    'Decimal → Binary',
                    context,
                  ),
                  _buildDropdownItem(
                    'Decimal to Hex',
                    'Decimal → Hex',
                    context,
                  ),
                  _buildDropdownItem(
                    'Binary to Decimal',
                    'Binary → Decimal',
                    context,
                  ),
                  _buildDropdownItem('Binary to Hex', 'Binary → Hex', context),
                  _buildDropdownItem(
                    'Hex to Decimal',
                    'Hex → Decimal',
                    context,
                  ),
                  _buildDropdownItem('Hex to Binary', 'Hex → Binary', context),
                ],
                onChanged: (value) {
                  setState(() {
                    ipConvType = value!;
                    ipConvController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Input Field
              TextField(
                controller: ipConvController,
                style: AppTextStyles.forSurface(
                  AppTextStyles.bodyMedium,
                  context,
                ),
                decoration: InputDecoration(
                  labelText: _getIPLabel(ipConvType),
                  labelStyle: AppTextStyles.withColor(
                    AppTextStyles.subtitleMedium,
                    cs.secondary,
                  ),
                  hintText: _getIPHint(ipConvType),
                  hintStyle: AppTextStyles.withOpacity(
                    AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      cs.secondary,
                    ),
                    0.5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: cs.secondary, width: 2),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Result Display
              if (ipConvController.text.isNotEmpty) _buildIPConvResult(),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    String text,
    BuildContext context,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        text,
        style: AppTextStyles.forSurface(AppTextStyles.bodyMedium, context),
      ),
    );
  }

  Widget _buildIPConvResult() {
    final cs = Theme.of(context).colorScheme;

    try {
      final result = _convertIP(ipConvType, ipConvController.text);
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SelectableText(
          result,
          style: AppTextStyles.secondaryCustom(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ).copyWith(fontFamily: 'monospace'),
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
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.errorColor,
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
    if (type.startsWith('Decimal')) return 'IP Address';
    if (type.startsWith('Binary')) return 'Binary IP';
    return 'Hex IP';
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

  @override
  void dispose() {
    ipConvController.dispose();
    super.dispose();
  }
}
