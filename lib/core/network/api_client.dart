import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:melody_match/core/interceptors/auth_interceptor.dart';
import 'package:melody_match/core/interceptors/refresh_token_interceptor.dart';

class ApiClient {
  late final Dio dio;
  final String? serverUrl = dotenv.env['SERVER_URL'];

  ApiClient() {
    if (serverUrl == null) throw Exception("serverUrl env variable is not set");
    dio = Dio(BaseOptions(baseUrl: serverUrl!));
    dio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(dio: dio),
    ]);
  }
}
