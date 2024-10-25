import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddHR extends StatefulWidget {
  const AddHR({Key? key}) : super(key: key);

  @override
  _AddHRState createState() => _AddHRState();
}

class _AddHRState extends State<AddHR> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF102C57), // Full screen background color
        child: SingleChildScrollView(
          // Added SingleChildScrollView for scrolling
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          "Add Project Manager",
                          style:
                              TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                        ),
                        Container(
                          width: 250,
                          height: 1,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Name Field
                  _buildTextField(
                    controller: nameController,
                    label: 'Name',
                  ),
                  SizedBox(height: 15),

                  // Email Field
                  _buildTextField(
                    controller: emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),

                  // Password Field
                  _buildTextField(
                    controller: passwordController,
                    label: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 15),

                  _buildTextField(
                    controller: phoneNumberController,
                    label: 'Phone Number',
                    obscureText: true,
                  ),
                  SizedBox(height: 15),

                  // Position Field
                  _buildTextField(
                    controller: positionController,
                    label: 'Position',
                  ),
                  SizedBox(height: 15),

                  // Team Name Field
                  _buildTextField(
                    controller: teamNameController,
                    label: 'Team Name',
                  ),
                  SizedBox(height: 15),

                  // Salary Field
                  _buildTextField(
                    controller: salaryController,
                    label: 'Salary',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 30),

                  // Add HR Button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _registerHR();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDAC0A3), // Button color
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      'Add Project Manager',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom Text Field Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  // Function to register the HR in Firebase Auth and Firestore
  Future<void> _registerHR() async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Add user details to Firestore with isAdmin set to true
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'position': positionController.text,
        'phoneNumber': phoneNumberController.text,
        'teamName': teamNameController.text,
        'salary': salaryController.text,
        'isAdmin': true, // isAdmin is set to true for HR
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('HR Added Successfully')),
      );

      // Clear form fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneNumberController.clear();
      positionController.clear();
      teamNameController.clear();
      salaryController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add HR: $error')),
      );
    }
  }
}
