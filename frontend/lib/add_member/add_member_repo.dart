import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user.dart';

class AddMembersRepo {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  AddMembersRepo() {
    // Add log interceptor with detailed logging
    _dio.interceptors.add(
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

  Future<Map<String, dynamic>> searchUsers(String userName) async {
    try {
      final String? token = await _secureStorage.read(key: 'auth_token');

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        'http://10.0.2.2:8080/auth/search_user',
        data: jsonEncode(<String, String>{
          'user_name': userName,
        }),
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // Assuming response.data is a single user object with 'user_name' and 'user_email'
      if (response.statusCode == 200) {
        // Assuming response.data is a single user object
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      print('Failed to search users: $e');
      throw Exception('Failed to search users');
    }
  }

  Future<void> addUserToGroup(String userEmail, String groupName) async {
    try {
      final String? token = await _secureStorage.read(key: 'auth_token');

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.post(
        'http://10.0.2.2:8080/group/add_member',
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
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print('Failed to add user to group: $e');
      throw Exception('Failed to add user to group');
    }
  }
}
