// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

class ProfileForm extends ConsumerStatefulWidget {
  final User user;

  const ProfileForm({super.key, required this.user});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle save action
            final updatedUser = User(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
            );
            // Update user data in the repository
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
