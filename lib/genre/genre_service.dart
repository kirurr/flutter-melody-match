import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:melody_match/core/network/api_client.dart';
import 'package:melody_match/genre/entities/genre.dart';

class GenreService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Genre>> findGenresByOneName(String name) async {
    try {
      final Response res = await _apiClient.dio.get(
        '/genre',
        queryParameters: {'name': name},
      );
      return (res.data as List).map((json) => Genre.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
