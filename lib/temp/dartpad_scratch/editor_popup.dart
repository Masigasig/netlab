import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// MODEL
class UserModel {
  final String name;
  final String email;

  UserModel({required this.name, required this.email});

  UserModel copyWith({String? name, String? email}) {
    return UserModel(name: name ?? this.name, email: email ?? this.email);
  }
}

// PROVIDER
final userProvider = StateProvider<UserModel>((ref) {
  return UserModel(name: 'John Doe', email: 'john@example.com');
});

// MAIN APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editable Form',
      home: Scaffold(
        appBar: AppBar(title: const Text('Editable Form')),
        body: const Padding(padding: EdgeInsets.all(16.0), child: UserForm()),
      ),
    );
  }
}

// FORM WIDGET
class UserForm extends ConsumerWidget {
  const UserForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditableField(
          label: 'Name',
          value: user.name,
          validator: validateName,
          onSave: (newValue) {
            ref.read(userProvider.notifier).state = user.copyWith(
              name: newValue,
            );
          },
        ),
        const SizedBox(height: 20),
        EditableField(
          label: 'Email',
          value: user.email,
          validator: validateEmail,
          onSave: (newValue) {
            ref.read(userProvider.notifier).state = user.copyWith(
              email: newValue,
            );
          },
        ),
      ],
    );
  }
}

// VALIDATORS
String? validateName(String? input) {
  if (input == null || input.trim().isEmpty) return 'Name cannot be empty';
  if (input.length < 3) return 'Name must be at least 3 characters';
  return null;
}

String? validateEmail(String? input) {
  if (input == null || input.trim().isEmpty) return 'Email cannot be empty';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
    return 'Invalid email format';
  }
  return null;
}

// EDITABLE FIELD WIDGET
class EditableField extends StatelessWidget {
  final String label;
  final String value;
  final void Function(String) onSave;
  // Changed validator signature to accept String?
  final FormFieldValidator<String>? validator;

  const EditableField({
    super.key,
    required this.label,
    required this.value,
    required this.onSave,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => EditPopup(
              label: label,
              initialValue: value,
              validator: validator,
              onSave: onSave,
            ),
          ),
        ),
      ],
    );
  }
}

// POPUP CARD WITH VALIDATION
class EditPopup extends StatefulWidget {
  final String label;
  final String initialValue;
  final void Function(String) onSave;
  // Changed validator signature to accept String?
  final String? Function(String?)? validator;

  const EditPopup({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onSave,
    required this.validator,
  });

  @override
  State<EditPopup> createState() => _EditPopupState();
}

class _EditPopupState extends State<EditPopup> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_controller.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit ${widget.label}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.label,
                ),
                validator: widget.validator,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: handleSave,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
