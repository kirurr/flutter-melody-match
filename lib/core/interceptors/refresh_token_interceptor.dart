import 'package:dio/dio.dart';
import 'package:melody_match/core/entities/tokens.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/tokens/tokens_service.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  final TokensService tokensService = TokensService.instance;

  bool _isRefreshing = false;

  RefreshTokenInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final isRefreshRequest = err.requestOptions.extra['refresh'] == true;

    if (statusCode == 401 && !isRefreshRequest) {
      // Предотвращаем одновременные обновления
      if (_isRefreshing) {
        return handler.reject(err);
      }
      _isRefreshing = true;

      try {
        Tokens tokens = await tokensService.getTokens();

        if (tokens.refreshToken == null) {
          _isRefreshing = false;
          LogoutManager.logout();
          return;
        }

        final response = await dio.post(
          '/auth/refresh',
          data: {'refreshToken': tokens.refreshToken},
          options: Options(
            extra: {'refresh': true},
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        );

        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        await tokensService.saveAccessToken(newAccessToken);
        await tokensService.saveRefreshToken(newRefreshToken);

        final opts = Options(
          method: err.requestOptions.method,
          headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer $newAccessToken',
          },
        );

        final retryResponse = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: opts,
        );

        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;

        // Разлогинить пользователя (см. предыдущий ответ)
        LogoutManager.logout();

        return;
      }
    }

    return handler.next(err);
  }
}
