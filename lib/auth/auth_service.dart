import 'dart:async';
import 'package:melody_match/tokens/tokens_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final AppLinks _appLinks = AppLinks();
  final TokensService _tokensService = TokensService.instance;

  String? serverUrl = dotenv.env['SERVER_URL'];

  AuthService() {
    if (serverUrl == null) throw Exception("serverUrl env variable is not set");
  }

  Future<void> startGoogleOAuth2() async {
    final url = Uri.parse('$serverUrl/auth/google/redirect');

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
          completer.completeError(Exception('Oauth google error: $err'));
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
