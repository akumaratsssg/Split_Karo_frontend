import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/group.dart';

class UserHomeRepository {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  UserHomeRepository({required this.dio}) : secureStorage = FlutterSecureStorage() {
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

  Future<List<Group>> fetchUserGroups() async {
    try {
      // Retrieve the token from secure storage
      final String? token = await secureStorage.read(key: 'auth_token');

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }

      // Add the token to the request headers
      final response = await dio.get(
        'http://10.0.2.2:8080/group/get_groups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      // Check if the response status code is 200
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((group) {
          return Group(
            name: group['group_name'],
            description: group['group_desc'],
            adminName: group['group_admin_name'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load groups');
      }
    } catch (e) {
      // Log the error and rethrow it
      print('Error fetching user groups: $e');
      throw e;
    }
  }
}



