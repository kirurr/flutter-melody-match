import 'package:melody_match/user/entities/user_data.dart';
import 'package:melody_match/user/entities/user_preferences.dart';

class User {
  final int id;
  final String email;
  final String name;
  final String createdAt;
  final String updatedAt;
  final UserData? userData;
  final UserPreferences? userPreferences;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userData,
    required this.userPreferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'email': String email,
        'name': String name,
        'createdAt': String createdAt,
        'updatedAt': String updatedAt,
        'userData': dynamic userData,
        'userPreferences': dynamic userPreferences,
      } =>
        User(
          id: id,
          email: email,
          name: name,
          createdAt: createdAt,
          updatedAt: updatedAt,
          userData: userData != null ? UserData.fromJson(userData) : null,
          userPreferences: userPreferences != null
              ? UserPreferences.fromJson(userPreferences)
              : null,
        ),
      _ => throw Exception('Invalid user json'),
    };
  }
}
