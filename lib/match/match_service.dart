import 'package:dio/dio.dart';
import 'package:melody_match/core/network/api_client.dart';
import 'package:melody_match/match/entities/user_data_match.dart';
import 'package:melody_match/user/entities/user.dart';

class MatchService {
  final ApiClient _apiClient = ApiClient();

  Future<void> acceptMatch({required int id}) async {
    try {
       await _apiClient.dio.post('/match/accepted', data: {'id': id});
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<MatchWithUser>> getUnacceptedMatchesWithUserData() async {
    try {
      final Response res = await _apiClient.dio.get('/match/unaccepted');
      return (res.data as List<dynamic>).map((e) => MatchWithUser.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<User>> getAcceptedMatchesWithUserData() async {
    try {
      final Response res = await _apiClient.dio.get('/match/accepted');
      return (res.data as List<dynamic>).map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> createMatch({required int id}) async {
    try {
      await _apiClient.dio.post('/match', data: {'likedUserId': id});
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<User>> findMatchesForUser({List<int> seenIds = const []}) async {
    try {
      final Response res = await _apiClient.dio.get(
        '/match/find',
        queryParameters: {'seen': seenIds.join(',')},
      );
      return (res.data as List<dynamic>).map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
