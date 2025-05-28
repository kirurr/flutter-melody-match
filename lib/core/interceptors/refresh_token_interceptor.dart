import 'package:dio/dio.dart';
import 'package:melody_match/auth/entities/tokens.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/user/user_state_manager.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  final UserStateManager tokensService = UserStateManager.instance;

  bool _isRefreshing = false;

  RefreshTokenInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final isRefreshRequest = err.requestOptions.extra['refresh'] == true;

    if (statusCode == 401 && !isRefreshRequest) {
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

        _isRefreshing = false;

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

        return handler.resolve(retryResponse);
      } on DioException catch (e) {
        if (e.response == null) {
          _isRefreshing = false;
          rethrow;
        }

        if (e.response?.statusCode == 400 &&
            e.response?.extra['refresh'] == true) {
          _isRefreshing = false;

          LogoutManager.logout();

          return;
        }
        _isRefreshing = false;
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }
}
