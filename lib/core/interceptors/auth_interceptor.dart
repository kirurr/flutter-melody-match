import 'package:dio/dio.dart';
import 'package:melody_match/tokens/tokens_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokensService.instance.getTokens();
    if (token.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    return handler.next(options);
  }
}
