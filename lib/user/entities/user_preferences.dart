import 'package:melody_match/genre/entities/genre.dart';

enum UserPreferencesDesiredSex { BOTH, MALE, FEMALE }

class UserPreferences {
  final int id;
  final int userId;
  final UserPreferencesDesiredSex desiredSex;
  final List<Genre> genres;

  UserPreferences({
    required this.id,
    required this.userId,
    required this.desiredSex,
    required this.genres,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'userId': int userId,
        'desiredSex': String desiredSex,
        'genres': List<dynamic> genres,
      } =>
        UserPreferences(
          id: id,
          userId: userId,
          desiredSex: desiredSex == 'BOTH'
              ? UserPreferencesDesiredSex.BOTH
              : desiredSex == 'MALE'
              ? UserPreferencesDesiredSex.MALE
              : UserPreferencesDesiredSex.FEMALE,
          genres: genres.map((e) => Genre.fromJson(e)).toList(),
        ),
      _ => throw Exception('Invalid userPreferences json'),
    };
  }
}
