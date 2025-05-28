import 'package:melody_match/auth/entities/tokens.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStateManager {
  UserStateManager._privateConstructor();

  static final UserStateManager _instance = UserStateManager._privateConstructor();

  static UserStateManager get instance => _instance;

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _spotifyAccessTokenKey = 'spotifyAccessToken';

  static const String _seenIdsKey = 'seenIds';

  static User? user;

  Future<void> addSeenId(int id) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> seenIds = prefs.getStringList(_seenIdsKey) ?? [];
    seenIds.add(id.toString());
    await prefs.setStringList(_seenIdsKey, seenIds);
  }

  Future<void> clearSeenIds() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_seenIdsKey, []);
  }

  Future<List<int>> getSeenIds() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> seenIds = prefs.getStringList(_seenIdsKey) ?? [];
    return seenIds.map((e) => int.parse(e)).toList();
  }

  Future<Tokens> getTokens() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);
    final spotifyAccessToken = prefs.getString(_spotifyAccessTokenKey);

    return Tokens(
      accessToken,
      refreshToken,
      spotifyAccessToken,
    );
  }

  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_accessTokenKey, accessToken);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> saveSpotifyAccessToken(String spotifyAccessToken) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_spotifyAccessTokenKey, spotifyAccessToken);
  }

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_spotifyAccessTokenKey);
  }
}
