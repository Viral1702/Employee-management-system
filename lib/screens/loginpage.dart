import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:get/get.dart';
import 'package:worknest/screens/admin_screens/admin_home_screen.dart';
import 'package:worknest/screens/homepage.dart'; // Ensure the correct path for HomeScreen

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = ''; // For displaying errors

  // Sign in method
  Future<void> _signIn() async {
    setState(() {
      errorMessage = ''; // Clear previous errors
    });

    // Check if fields are empty
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Email and password fields are required.";
      });
      return;
    }

    try {
      // Firebase sign in
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          bool isAdmin = userDoc.get('isAdmin'); // Get the isAdmin field

          // Navigate to the appropriate page based on isAdmin field
          if (isAdmin) {
            Get.to(() => AdminHomeScreen());
          } else {
            Get.to(() => HomePage()); // Navigate to HomeScreen if not admin
          }
        } else {
          setState(() {
            errorMessage = "User data not found!";
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = "No user found with this email.";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = "Incorrect password.";
        });
      } else {
        setState(() {
          errorMessage = "Login failed: ${e.message}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Login failed: ${e.toString()}";
      });
    }
  }

  // Forgot password method
  Future<void> _forgotPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = "Please enter your email to reset password.";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        errorMessage = "Password reset link sent! Please check your email.";
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = "No user found with this email.";
        });
      } else {
        setState(() {
          errorMessage = "Error: ${e.message}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(color: Color(0xFF102C57)),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  color: Color(0xFF102C57),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Color(0xFFDAC0A3),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity, // Set width to 100%
                decoration: BoxDecoration(
                  color: Color(0xFF102C57), // Dark blue color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFFDAC0A3),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Color(0xFFDAC0A3)),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Color(0xFFDAC0A3)),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFFDAC0A3)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Color(0xFFDAC0A3)),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Color(0xFFDAC0A3)),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFFDAC0A3)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _signIn,
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDAC0A3),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFFDAC0A3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
