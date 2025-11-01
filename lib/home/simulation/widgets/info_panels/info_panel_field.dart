part of 'info_panel.dart';

class _InfoPanelField extends ConsumerWidget {
  final String label;
  final String value;
  final String? Function(String?)? validator;
  final Function(String)? onSave;

  const _InfoPanelField({
    required this.label,
    required this.value,
    this.validator,
    this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('InfoPanel for $label Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(value.isEmpty ? 'Not set' : value),
                ],
              ),
            ),

            if (onSave != null)
              IconButton(
                iconSize: 10,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: isPlaying
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => _EditDialog(
                            label: label,
                            currentValue: value,
                            validator: validator!,
                            onSave: onSave!,
                          ),
                        );
                      },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPencilEdit01,
                  color: isPlaying
                      ? Colors.grey
                      : Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RouterInterfaceField extends ConsumerWidget {
  final String title;
  final String ipAddress;
  final String subnetMask;
  final String macAddress;
  final Function(String, String)? onSave;

  const _RouterInterfaceField({
    required this.title,
    required this.ipAddress,
    required this.subnetMask,
    required this.macAddress,
    this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('InterfaceField for $title Rebuilt');
    final isPlaying = ref.watch(simScreenProvider.select((s) => s.isPlaying));

    final networkId = Ipv4AddressManager.getNetworkAddress(
      ipAddress,
      subnetMask,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  iconSize: 10,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: isPlaying
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => _EditInterfaceDialog(
                              ipAddress: ipAddress,
                              subnetMask: subnetMask,
                              onSave: onSave!,
                            ),
                          );
                        },
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedPencilEdit01,
                    color: isPlaying
                        ? Colors.grey
                        : Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Network Id :',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(networkId),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ipv4 Address :',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(ipAddress.isEmpty ? 'Not set' : ipAddress),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SubnetMask :',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(subnetMask.isEmpty ? 'Not set' : subnetMask),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mac Address:',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(macAddress),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
