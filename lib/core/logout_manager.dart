import 'package:flutter/material.dart';
import 'package:melody_match/core/widgets/startup_screen.dart';
import 'package:melody_match/main.dart';
import 'package:melody_match/user/user_state_manager.dart';

typedef LogoutCallback = void Function();

class LogoutManager {
  static LogoutCallback? onLogout;

  static void logout() async {
    await UserStateManager.instance.clearTokens();
    UserStateManager.user = null;
    await UserStateManager.instance.clearSeenIds();
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => StartupScreen()),
    );
  }
}
