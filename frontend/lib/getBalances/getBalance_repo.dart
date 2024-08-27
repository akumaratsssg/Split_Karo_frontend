import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user_balance.dart';

class BalancesRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  BalancesRepository() {
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

  Future<List<UserBalance>> fetchBalances(String groupName) async {
    try {
      final String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null) throw Exception('Token not found');

      final response = await _dio.get(
        'http://10.0.2.2:8080/expense/get_balance',
        data: jsonEncode(<String, dynamic>{
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
        final List<dynamic> data = response.data;
        return data.map((item) => UserBalance.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load balances');
      }
    } catch (e) {
      print('Failed to load balances: $e');
      throw Exception('Failed to load balances');
    }
  }
}
