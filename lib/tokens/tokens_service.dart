import 'package:melody_match/core/entities/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokensService {
  TokensService._privateConstructor();

  static final TokensService _instance = TokensService._privateConstructor();

  static TokensService get instance => _instance;

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _spotifyAccessTokenKey = 'spotifyAccessToken';

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
