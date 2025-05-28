import 'dart:async';

import 'package:flutter/material.dart';
import 'package:melody_match/auth/auth_service.dart';
import 'package:melody_match/core/widgets/startup_screen.dart';

class AuthScreen extends StatefulWidget {
  final AuthService _authService = AuthService();

  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _handleSpotifyAuth() async {
    await widget._authService.startSpotifyOAuth2();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => StartupScreen()),
    );
  }

  Future<void> _handleGoogleAuth() async {
    await widget._authService.startGoogleOAuth2();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => StartupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'sign in',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: _handleGoogleAuth,
            child: Text('sign in with google'),
          ),
          ElevatedButton(
            onPressed: _handleSpotifyAuth,
            child: Text('sign in with spotify'),
          ),
        ],
      ),
    );
  }
}
