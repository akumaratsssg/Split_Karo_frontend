import 'package:flutter/material.dart';
import 'package:frontend/register/register_page.dart';
import 'package:frontend/signin/signin_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF708090), // Slate Grey color
        title: const Text('Split Karo'),
      ),
      body: Container(
        color: Colors.black, // Black background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Image.asset(
              //   'assets/images/logo.png',
              //   width: 150, // Adjust the width of the logo as needed
              // ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00CED1), // Cyan color for button
                    foregroundColor: Colors.white, // White text color
                    minimumSize: Size(double.infinity, 50), // Full-width button
                    padding: EdgeInsets.symmetric(vertical: 15), // Add padding
                  ),
                  onPressed: () {
                    // Navigate to Register Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('Register'),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00CED1), // Cyan color for button
                    foregroundColor: Colors.white, // White text color
                    minimumSize: Size(double.infinity, 50), // Full-width button
                    padding: EdgeInsets.symmetric(vertical: 15), // Add padding
                  ),
                  onPressed: () {
                    // Navigate to Sign In Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







