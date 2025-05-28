import 'package:dio/dio.dart';
import 'package:melody_match/core/network/api_client.dart';
import 'package:melody_match/genre/entities/genre.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/entities/user_contact.dart';
import 'package:melody_match/user/entities/user_data.dart';
import 'package:melody_match/user/entities/user_preferences.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  Future<void> deleteUser() async {
    try {
      await _apiClient.dio.delete('/user');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> assignSpotifyGenresToUser({required String? token}) async {
    try {
      await _apiClient.dio.post('/spotify/user', data: token == null ? {} : {'accessToken': token});
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> createContacts(List<UserContact> contacts) async {
    try {
      await _apiClient.dio.post(
        '/user/contacts',
        data: {
          'contacts': contacts
              .map((e) => {'name': e.name, 'value': e.value})
              .toList(),
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<User> getUserWithContacts({int? id}) async {
    try {
      final Response res = await _apiClient.dio.get(
        '/user/matched',
        queryParameters: id != null ? {'id': id} : {},
      );
      return User.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<User> getUser() async {
    try {
      final Response res = await _apiClient.dio.get('/user');
      return User.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> createUserPreferences({
    required UserPreferencesDesiredSex desiredSex,
    required List<Genre> genres,
  }) async {
    try {
      await _apiClient.dio.post(
        '/user/preferences',
        data: {
          'desiredSex': desiredSex.name,
          'genresIds': genres.map((e) => e.id).toList(),
        },
      );
      return;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.requestOptions.data);
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> createUserData({
    required int age,
    required UserDataSex sex,
    required String displayName,
    required String about,
    required String imageUrl,
  }) async {
    try {
      await _apiClient.dio.post(
        '/user/data',
        data: {
          'age': age,
          'sex': sex == UserDataSex.MALE ? 'MALE' : 'FEMALE',
          'displayName': displayName,
          'about': about,
          'imageUrl': imageUrl,
        },
      );
      return;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
