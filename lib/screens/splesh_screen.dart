// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:worknest/screens/getstarted.dart'; // Import the GetStarted screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(); // Call this function when the splash screen is shown
  }

  // Function to handle navigation to the next screen after delay
  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Simulate a 3-second delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => getStarted()), // Navigate to GetStarted screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF102C57), // Background color
        child: Center(
          child: Text(
            'WORK NEST',
            style: TextStyle(
              fontSize: 36,
              color: Color(0xFFDAC0A3), // Text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
