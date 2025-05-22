import 'package:flutter/material.dart';
import 'package:melody_match/auth/widgets/auth_widget.dart';
import 'package:melody_match/core/entities/tokens.dart';
import 'package:melody_match/core/widgets/home_screen.dart';
import 'package:melody_match/tokens/tokens_service.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
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
    final Tokens tokens = await TokensService.instance.getTokens();
    if (!mounted) return;

    if (tokens.refreshToken == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }
}
