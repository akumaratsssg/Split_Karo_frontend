import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width; // Add this line

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.width, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Apply the width to the container
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0), // Adjust button padding
        ),
        child: Text(text),
      ),
    );
  }
}

