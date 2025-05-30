import 'package:flutter/material.dart';
import 'package:melody_match/core/logout_manager.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(errorMessage),
              ElevatedButton(
                onPressed: () {
                  LogoutManager.logout();
                },
                child: Text('logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
