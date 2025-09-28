// ignore_for_file: deprecated_member_use

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

  UserModel({this.name = '', this.email = ''});

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
      title: 'Profile Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile Editor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            ProfileField(
              icon: Icons.person_outline,
              label: 'Name',
              value: user.name,
              onEdit: () => _editField(
                context,
                ref,
                'Name',
                user.name,
                validateName,
                (value) => ref.read(userProvider.notifier).state = user
                    .copyWith(name: value),
              ),
            ),

            const SizedBox(height: 16),

            // Email Field
            ProfileField(
              icon: Icons.email_outlined,
              label: 'Email',
              value: user.email,
              onEdit: () => _editField(
                context,
                ref,
                'Email',
                user.email,
                validateEmail,
                (value) => ref.read(userProvider.notifier).state = user
                    .copyWith(email: value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editField(
    BuildContext context,
    WidgetRef ref,
    String label,
    String currentValue,
    String? Function(String?) validator,
    Function(String) onSave,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditDialog(
        label: label,
        currentValue: currentValue,
        validator: validator,
        onSave: onSave,
      ),
    );
  }
}

// VALIDATORS
String? validateName(String? input) {
  if (input == null || input.trim().isEmpty) return null; // Allow empty
  if (input.length < 3) return 'Name must be at least 3 characters';
  return null;
}

String? validateEmail(String? input) {
  if (input == null || input.trim().isEmpty) return null; // Allow empty
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
    return 'Invalid email format';
  }
  return null;
}

// PROFILE FIELD WIDGET
class ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onEdit;

  const ProfileField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: hasValue ? Colors.blue[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: hasValue ? Colors.blue[600] : Colors.grey[500],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasValue ? value : 'Not set',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: hasValue ? Colors.grey[800] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, color: Colors.grey[600]),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[50],
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

// EDIT DIALOG
class EditDialog extends StatefulWidget {
  final String label;
  final String currentValue;
  final String? Function(String?) validator;
  final Function(String) onSave;

  const EditDialog({
    super.key,
    required this.label,
    required this.currentValue,
    required this.validator,
    required this.onSave,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Edit ${widget.label}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                autofocus: true,
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText:
                      'Enter ${widget.label.toLowerCase()} or leave empty',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
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
