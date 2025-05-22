import 'package:flutter/material.dart';
import 'package:melody_match/auth/widgets/auth_widget.dart';
import 'package:melody_match/main.dart';
import 'package:melody_match/tokens/tokens_service.dart';

typedef LogoutCallback = void Function();

class LogoutManager {
  static LogoutCallback? onLogout;

  static void logout() {
    TokensService.instance.clearTokens();
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => AuthScreen()),
    );
  }
}
