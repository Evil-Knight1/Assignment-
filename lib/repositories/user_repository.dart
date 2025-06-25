import 'package:dio/dio.dart';
import '../models/user.dart';

class UserRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('$_baseUrl/users');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}

