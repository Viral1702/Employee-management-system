import 'package:cloud_firestore/cloud_firestore.dart';
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Add HR logic with isAdmin true
                        FirebaseFirestore.instance.collection('Users').add({
                          'name': nameController.text,
                          'email': emailController.text,
                          'password': passwordController.text,
                          'position': positionController.text,
                          'teamName': teamNameController.text,
                          'salary': salaryController.text,
                          'isAdmin': true, // isAdmin is set to true
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('HR Added Successfully')),
                          );
                          // Clear form fields
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          positionController.clear();
                          teamNameController.clear();
                          salaryController.clear();
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to add HR: $error')),
                          );
                        });
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
}
