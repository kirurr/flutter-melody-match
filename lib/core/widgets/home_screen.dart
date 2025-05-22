import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/core/network/api_client.dart';
import 'package:melody_match/core/widgets/startup_screen.dart';
import 'package:melody_match/tokens/tokens_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();

  Future<void> _clearAccessToken() async {
    TokensService.instance.clearAccessToken();
  }

  Future<void> _clearTokens() async {
    LogoutManager.logout();
  }

  Future<void> _makeRequest() async {
    final Response res = await _apiClient.dio.get('/user');
    print(res.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('main page'),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: _clearAccessToken, child: Text('clear access token')),
          ElevatedButton(onPressed: _clearTokens, child: Text('clear tokens')),
          ElevatedButton(onPressed: _makeRequest, child: Text('make request')),
        ],
      ),
    );
  }
}
