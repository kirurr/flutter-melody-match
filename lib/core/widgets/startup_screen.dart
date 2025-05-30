import 'package:flutter/material.dart';
import 'package:melody_match/auth/widgets/auth_screen.dart';
import 'package:melody_match/auth/widgets/user_contacts_screen.dart';
import 'package:melody_match/auth/widgets/user_data_screen.dart';
import 'package:melody_match/auth/widgets/user_preferences_screen.dart';
import 'package:melody_match/auth/entities/tokens.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/core/widgets/error_screen.dart';
import 'package:melody_match/core/widgets/home_screen.dart';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/user_service.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> _checkAuth() async {
    final Tokens tokens = await UserStateManager.instance.getTokens();

    if (!mounted) return;
    if (tokens.refreshToken == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen()),
      );
      return;
    }

    try {
      User user = await _userService.getUserWithContacts();
      UserStateManager.user = user;

      if (user.userData == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserDataScreen()),
        );
        return;
      }
      if (user.userData!.contacts == null || user.userData!.contacts.isEmpty) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserContactsScreen()),
        );
        return;
      }

      if (user.userPreferences == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserPreferencesScreen(user: user,)),
        );
        return;
      }
    } catch (e) {

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ErrorScreen(errorMessage: e.toString())),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }
}
