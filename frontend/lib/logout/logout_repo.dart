// user_home_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LogoutRepository {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  LogoutRepository({required this.dio}) : secureStorage = FlutterSecureStorage() {
    // Adding the LogInterceptor for detailed logging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          print(object); // This is where the logs will be printed.
        },
      ),
    );
  }

  Future<void> logout() async {
    try {
      // Retrieve the token from secure storage
      final String? token = await secureStorage.read(key: 'auth_token');

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }

      // Assume this is your logout API endpoint
      final response = await dio.post(
          'http://10.0.2.2:8080/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to log out');
      }
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }
}
