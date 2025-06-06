import 'package:flutter/material.dart';
import 'package:melody_match/user/widgets/user_contacts_form.dart';
import 'package:melody_match/auth/widgets/user_preferences_screen.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/user/entities/user_contact.dart';
import 'package:melody_match/user/user_service.dart';
import 'package:melody_match/user/user_state_manager.dart';

class UserContactsScreen extends StatefulWidget {
  const UserContactsScreen({super.key});

  @override
  State<UserContactsScreen> createState() => _UserContactsScreenState();
}

class _UserContactsScreenState extends State<UserContactsScreen> {
  final UserService _userService = UserService();

  Future<void> _submit(List<UserContact> contacts) async {
      await _userService.createContacts(contacts);
      UserStateManager.user = await _userService.getUserWithContacts();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const UserPreferencesScreen(user: null),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('user contacts'),
        actions: [
          IconButton(
            onPressed: () {
              LogoutManager.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(child: UserContactsForm(onSubmit: _submit,)),
    );
  }
}
