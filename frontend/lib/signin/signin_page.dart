import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signin_core/signin_bloc.dart';
import 'signin_core/signin_event.dart';
import 'signin_core/signin_state.dart';
import 'signin_core/signin_repository.dart';
import 'package:dio/dio.dart';
import 'package:frontend/user_home/user_home_page.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(repository: SignInRepository(dio: Dio())),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Sign In'),
          backgroundColor: Color(0xFF708090), // Slate gray color
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login Successful')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage(userName: state.userName)),
                );
              } else if (state is SignInFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login Failed: ${state.error}')),
                );
              }
            },
            child: BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                if (state is SignInLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white), // White text color
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white), // White text color
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    // login submit button
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        context.read<SignInBloc>().add(
                          SignInSubmitted(
                            email: email,
                            password: password,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan, // Cyan button color
                        foregroundColor: Colors.white, // White text color
                      ),
                      child: const Text('Log In'),
                    ),
                    // Back button
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan, // Cyan button color
                        foregroundColor: Colors.white, // White text color
                      ),
                      child: const Text('Back'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}



