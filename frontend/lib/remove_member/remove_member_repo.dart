import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class RemoveMemberRepo {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  RemoveMemberRepo({required this.dio})
      : secureStorage = FlutterSecureStorage() {
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

  Future<void> removeMember(String userEmail, String groupName) async {
    try {
      // Retrieve the token from secure storage
      final String? token = await secureStorage.read(key: 'auth_token');
      print("token value:");
      print(token);

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await dio.delete(
        'http://10.0.2.2:8080/group/remove_member',
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(<String, String>{
          'user_email': userEmail,
          'group_name': groupName,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove member');
      }
    } catch (e) {
      throw Exception('Error removing this member: $e');
    }
  }
}
