import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateGroupRepository {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  CreateGroupRepository({required this.dio}) : secureStorage = FlutterSecureStorage() {
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

  Future<void> createGroup(String groupName, String groupDescription) async {
    try {
      // Retrieve the token from secure storage
      final String? token = await secureStorage.read(key: 'auth_token');

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }
      print("my_req_data:");
      print(groupName);
      print(" ");
      print(groupDescription);
      // Make the POST request to create a new group
      final response = await dio.post(
        'http://10.0.2.2:8080/group/create_group',
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(<String, String>{
          'group_name': groupName,
          'group_desc': groupDescription,
        }),
      );

      // Check if the response status code indicates success
      if (response.statusCode != 200) {
        throw Exception('Failed to create group');
      }
    } catch (e) {
      // Log the error and rethrow it
      print('Error creating group: $e');
      throw e;
    }
  }
}
