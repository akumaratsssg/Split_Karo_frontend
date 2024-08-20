import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_core/register_bloc.dart';
import 'register_core/register_event.dart';
import 'register_core/register_state.dart';
import 'register_core/register_repository.dart';
import 'package:dio/dio.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(repository: RegisterRepository(dio: Dio())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Color(0xFF708090), // Slate Grey color
        ),
        body: Container(
          color: Colors.black, // Black background
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration Successful')),
                );
                Navigator.pop(context);
              } else if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration Failed: ${state.error}')),
                );
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                if (state is RegisterLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _fullNameController,
                      style: TextStyle(color: Colors.white), // White text color
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan), // Cyan border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan), // Cyan focused border color
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white), // White text color
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan), // Cyan border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan), // Cyan focused border color
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // White text color
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan), // Cyan border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan), // Cyan focused border color
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00CED1), // Cyan color for button
                        foregroundColor: Colors.black, // Black text color
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00CED1), // Cyan color for button
                        foregroundColor: Colors.black, // Black text color
                      ),
                      onPressed: () {
                        final fullName = _fullNameController.text;
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        context.read<RegisterBloc>().add(
                          RegisterSubmitted(
                            fullName: fullName,
                            email: email,
                            password: password,
                          ),
                        );
                      },
                      child: const Text('Submit'),
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



