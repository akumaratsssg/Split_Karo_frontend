import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/dio_interceptor/dio_interceptor.dart';

class RegisterRepository {
  final Dio dio;

  // Adding the LogInterceptor for detailed logging
  RegisterRepository({required this.dio}) {
    // Adding the AuthInterceptor
    dio.interceptors.add(AuthInterceptor());

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

  Future<void> register(String fullName, String email, String password) async {
    print("Register API called");
    print(fullName);
    print(email);
    print(password);
    try{
      final response = await dio.post(
        'http://10.0.2.2:8080/auth/register',
        options: Options(
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
          }
        ),
        data: jsonEncode(<String, String>{
          'user_name': fullName,
          'user_email': email,
          'user_password': password,
        }),
      );
    } catch (e){
      if (e is DioException) {
        print('Error: ${e.response?.data['error']}');
      } else {
        print('Unexpected error: $e');
      }
    }

    // print(result);
    // print("Register API response: ${response.data}");
    // if (response.statusCode != 200) {
    //   throw Exception('Failed to register');
    // }
  }
}


