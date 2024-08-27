import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:frontend/models/group_member.dart'; // Import your GroupMember model

class ViewGroupMembersRepo {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ViewGroupMembersRepo({required this.dio})
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

  Future<List<GroupMember>> getGroupMembers(String groupName) async {
    try {
      // Retrieve the token from secure storage
      final String? token = await secureStorage.read(key: 'auth_token');

      // Check if the token is null
      if (token == null) {
        throw Exception('Token not found');
      }

      // Send the request to get group members
      final response = await dio.get(
        'http://10.0.2.2:8080/group/get_members',
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(<String, String>{
          'group_name': groupName
        }), // Send data as JSON body
      );

      // Check if the response status code is 200
      if (response.statusCode == 200) {
        // Assuming the response data is in the format: {'groupMembers': List<Map<String, String>>}
        List<dynamic> data = response.data;

        // Convert the dynamic list to a list of GroupMember objects
        List<GroupMember> groupMembers = data.map((memberData) {
          return GroupMember.fromJson(memberData);
        }).toList();

        return groupMembers;
      } else {
        throw Exception('Failed to load group members');
      }
    } catch (e) {
      // Log the error and rethrow it
      print('Error fetching group members: $e');
      throw e;
    }
  }
}
