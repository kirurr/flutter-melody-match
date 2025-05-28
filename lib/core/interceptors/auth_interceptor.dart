import 'package:dio/dio.dart';
import 'package:melody_match/user/user_state_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await UserStateManager.instance.getTokens();
    if (token.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    return handler.next(options);
  }
}
