import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the secure storage package
import 'package:frontend/dio_interceptor/dio_interceptor.dart';

class SignInRepository {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  // Constructor with interceptors for logging and authentication
  SignInRepository({required this.dio}) : secureStorage = FlutterSecureStorage() {
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

  // Function to handle the sign-in process
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    print("SignIn API called");

    // Sending the POST request for sign-in
    final response = await dio.post(
      'http://10.0.2.2:8080/auth/login',
      options: Options(
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
      data: jsonEncode(<String, String>{
        'user_email': email,
        'user_password': password,
      }),
    );

    // Checking for a successful response
    if (response.statusCode != 200) {
      throw Exception('Failed to sign in');
    }

    // Storing the token in secure storage
    final String token = response.data['token'];
    await secureStorage.write(key: 'auth_token', value: token);

    // Returning the response data as a Map
    return response.data as Map<String, dynamic>;
  }
}


