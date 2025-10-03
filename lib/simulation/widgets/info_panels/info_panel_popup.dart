part of 'info_panel.dart';

class _EditDialog extends StatefulWidget {
  final String label;
  final String currentValue;
  final String? Function(String?) validator;
  final Function(String) onSave;

  const _EditDialog({
    required this.label,
    required this.currentValue,
    required this.validator,
    required this.onSave,
  });

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_controller.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      form: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StyledFormField(
              controller: _controller,
              label: widget.label,
              hintText: 'Enter new ${widget.label.toLowerCase()}',
              validator: widget.validator,
            ),
          ],
        ),
      ),
      onSave: _save,
    );
  }
}

class _EditInterfaceDialog extends ConsumerStatefulWidget {
  final String ipAddress;
  final String subnetMask;
  final Function(String, String) onSave;

  const _EditInterfaceDialog({
    required this.ipAddress,
    required this.subnetMask,
    required this.onSave,
  });

  @override
  ConsumerState<_EditInterfaceDialog> createState() =>
      _EditInterfaceDialogState();
}

class _EditInterfaceDialogState extends ConsumerState<_EditInterfaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ipController;
  late TextEditingController _subnetController;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.ipAddress);
    _subnetController = TextEditingController(text: widget.subnetMask);
  }

  @override
  void dispose() {
    _ipController.dispose();
    _subnetController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_ipController.text.trim(), _subnetController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.read(simScreenProvider).selectedDeviceOnInfo;
    final routingTable = ref.read(routerProvider(selectedDevice)).routingTable;

    return _BaseDialog(
      form: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StyledFormField(
              controller: _ipController,
              label: 'New Ipv4 Address :',
              hintText: 'Enter new Ipv4 Address :',
              validator: (value) {
                return Validator.validateIpOnRouterInterface(
                  value,
                  _subnetController.text.trim(),
                  widget.ipAddress,
                  routingTable,
                );
              },
            ),
            const SizedBox(height: 12),
            _StyledFormField(
              controller: _subnetController,
              label: 'New subnet mask :',
              hintText: 'Enter new subnet mask :',
              validator: (value) {
                return Validator.validateSubnetOnRouterInterface(
                  value,
                  _ipController.text.trim(),
                  routingTable,
                );
              },
            ),
          ],
        ),
      ),
      onSave: _save,
    );
  }
}

class _AddStaticRouteDialog extends ConsumerStatefulWidget {
  final Function(String, String, String) onSave;

  const _AddStaticRouteDialog({required this.onSave});

  @override
  ConsumerState<_AddStaticRouteDialog> createState() =>
      _AddStaticRouteDialogState();
}

class _AddStaticRouteDialogState extends ConsumerState<_AddStaticRouteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _networkIdController = TextEditingController();
  final _subnetController = TextEditingController();
  final _interfaceController = TextEditingController();

  @override
  void dispose() {
    _networkIdController.dispose();
    _subnetController.dispose();
    _interfaceController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _networkIdController.text.trim(),
        _subnetController.text.trim(),
        _interfaceController.text.trim(),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.read(simScreenProvider).selectedDeviceOnInfo;
    final routingTable = ref.read(routerProvider(selectedDevice)).routingTable;

    return _BaseDialog(
      form: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StyledFormField(
              controller: _networkIdController,
              label: 'Network Id :',
              hintText: '192.168.1.0',
              validator: (value) {
                return Validator.validateNetworkId(
                  value,
                  _subnetController.text.trim(),
                  routingTable,
                );
              },
            ),
            const SizedBox(height: 12),
            _StyledFormField(
              controller: _subnetController,
              label: 'Subnet Mask :',
              hintText: 'Enter subnet mask :',
              validator: (value) {
                return Validator.validateStaticRouteSubnet(
                  value,
                  _networkIdController.text.trim(),
                );
              },
            ),
            const SizedBox(height: 12),
            _StyledFormField(
              controller: _interfaceController,
              label: 'Interface :',
              hintText: 'Enter an IP or directed Interface',
              validator: (value) {
                return Validator.validateStaticRouteInterface(
                  value,
                  _subnetController.text.trim(),
                );
              },
            ),
          ],
        ),
      ),
      onSave: _save,
    );
  }
}

class _StyledFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?) validator;

  const _StyledFormField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autofocus: true,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedPencilEdit01,
              color: Theme.of(context).colorScheme.secondary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _BaseDialog extends StatelessWidget {
  final Widget form;
  final VoidCallback onSave;

  const _BaseDialog({required this.form, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              form,
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: onSave, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
