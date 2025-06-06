import 'package:flutter/material.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/entities/user_contact.dart';
import 'package:melody_match/user/user_service.dart';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:melody_match/user/widgets/user_contacts_form.dart';
import 'package:melody_match/user/widgets/user_profile_screen.dart';

class UpdateUserContactsScreen extends StatefulWidget {
  const UpdateUserContactsScreen({super.key});

  @override
  State<UpdateUserContactsScreen> createState() =>
      _UpdateUserContactsScreenState();
}

class _UpdateUserContactsScreenState extends State<UpdateUserContactsScreen> {
  final UserService _userService = UserService();
  late User? _user;

  _UpdateUserContactsScreenState() {
    _user = UserStateManager.user;
  }

  Future<void> _submit(List<UserContact> contacts) async {
    await _userService.updateContacts(contacts);
    UserStateManager.user = await _userService.getUserWithContacts();

    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const UserProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('update user contacts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: UserContactsForm(
        onSubmit: _submit,
        initialContacts: _user!.userData!.contacts,
      ),
    );
  }
}
