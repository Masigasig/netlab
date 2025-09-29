part of 'info_panel.dart';

class _InfoPanelField extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                onPressed: () {
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
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
