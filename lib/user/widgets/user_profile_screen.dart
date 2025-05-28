import 'package:flutter/material.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/match/widgets/contact_widget.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/user_service.dart';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:melody_match/user/widgets/user_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final User? user = UserStateManager.user;
  final UserService _userService = UserService();

  @override
  void initState() {
    if (user == null) LogoutManager.logout();
    super.initState();
  }

  void _deleteUser() async {
    try {
      await _userService.deleteUser();
    } catch (e) {
      print(e);
    } finally {
      LogoutManager.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('beautiful you'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserCard(user: user!),
            Column(
              children: user!.userData!.contacts
                  .map((e) => ContactItem(contact: e))
                  .toList(),
            ),
            TextButton(
              onPressed: () => LogoutManager.logout(),
              child: Text('log out'),
            ),
            TextButton(
              onPressed: () => _deleteUser(),
              child: Text(
                'delete user',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
