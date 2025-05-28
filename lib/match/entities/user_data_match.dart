import 'package:melody_match/match/entities/match.dart';
import 'package:melody_match/user/entities/user.dart';

class MatchWithUser {
  final Match match;
  final User user;

  MatchWithUser({required this.match, required this.user});

  factory MatchWithUser.fromJson(Map<String, dynamic> json) {
    if (json['match'] == null || json['user'] == null) {
      throw Exception('UserDataMatch json is not valid');
    }

    return MatchWithUser(
      match: Match.fromJson(json['match']),
      user: User.fromJson(json['user']),
    );
  }
}
