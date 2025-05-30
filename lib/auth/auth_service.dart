import 'dart:async';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final AppLinks _appLinks = AppLinks();
  final UserStateManager _tokensService = UserStateManager.instance;

  String? serverUrl = dotenv.env['SERVER_URL'];

  AuthService() {
    if (serverUrl == null) throw Exception("SERVER_URL env variable is not set");
  }
  Future<void> startSpotifyOAuth2() async {
    final url = Uri.parse('$serverUrl/auth/android/spotify/redirect');

    final completer = Completer<void>();

    late final StreamSubscription sub;

    sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) async {
        if (uri != null) {
          final accessToken = uri.queryParameters['access_token'];
          final refreshToken = uri.queryParameters['refresh_token'];
          final spotifyAccessToken =
              uri.queryParameters['spotify_access_token'];

          if (accessToken != null) {
            await _tokensService.saveAccessToken(accessToken);
          }
          if (refreshToken != null) {
            await _tokensService.saveRefreshToken(refreshToken);
          }
          if (spotifyAccessToken != null) {
            await _tokensService.saveSpotifyAccessToken(spotifyAccessToken);
          }

          if (!completer.isCompleted) completer.complete();
          await sub.cancel();
        }
      },
      onError: (err) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Oauth Spotify error: $err'));
        }
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Error launching Spotify Oauth: $url');
    }

    return completer.future;
  }

  Future<void> startGoogleOAuth2() async {
    final url = Uri.parse('$serverUrl/auth/android/google/redirect');

    final completer = Completer<void>();

    late final StreamSubscription sub;

    sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) async {
        if (uri != null) {
          final accessToken = uri.queryParameters['access_token'];
          final refreshToken = uri.queryParameters['refresh_token'];

          if (accessToken != null) {
            await _tokensService.saveAccessToken(accessToken);
          }
          if (refreshToken != null) {
            await _tokensService.saveRefreshToken(refreshToken);
          }

          if (!completer.isCompleted) completer.complete();
          await sub.cancel();
        }
      },
      onError: (err) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Oauth Google error: $err'));
        }
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Error launching Google Oauth: $url');
    }

    return completer.future;
  }
}
