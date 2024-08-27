import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user.dart';

class AddExpenseRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  AddExpenseRepository() {
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

  Future<List<User>> getGroupMembers(String groupName) async {
    try {
      final String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null) throw Exception('Token not found');

      final response = await _dio.get(
        'http://10.0.2.2:8080/group/get_members',
        data: jsonEncode(<String, String>{
          'group_name': groupName
        }),
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> membersJson = response.data;
        return membersJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load group members');
      }
    } catch (e) {
      print('Failed to load group members: $e');
      throw Exception('Failed to load group members');
    }
  }

  Future<int> addExpense({
    required double amount,
    required String description,
    required String category,
    required String groupName,
  }) async {
    try {
      final String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null) throw Exception('Token not found');

      final response = await _dio.post(
        'http://10.0.2.2:8080/expense/create_expense',
        data: jsonEncode(<String, dynamic>{
          'exp_amount': amount,
          'exp_desc': description,
          'exp_category': category,
          'group_name': groupName,
        }),
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data']['exp_id']; // Assuming API returns exp_id

      } else {
        throw Exception('Failed to create expense');
      }
    } catch (e) {
      print('Failed to ak create expense: $e');
      throw Exception('Failed to create expense');
    }
  }

  Future<void> createDebts({
    required int expId,
    required List<String> participants,
    required double expAmount,
  }) async {
    try {
      final String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null) throw Exception('Token not found');

      final response = await _dio.post(
        'http://10.0.2.2:8080/expense/create_balance',
        data: jsonEncode(<String, dynamic>{
          'participants': participants,
          'exp_amount': expAmount,
          'exp_id': expId,
        }),
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create debts');
      }
    } catch (e) {
      print('Failed to create debts: $e');
      throw Exception('Failed to create debts');
    }
  }
}
