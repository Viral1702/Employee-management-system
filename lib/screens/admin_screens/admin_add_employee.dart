import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF102C57), // Set background for full screen
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
      ),
      body: SafeArea(
        // Wrap in SafeArea to avoid status bar overlap
        child: Container(
          color: Color(
              0xFF102C57), // Ensure the container background color is consistent
          child: SingleChildScrollView(
            // Added SingleChildScrollView for scrolling
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          "Add Employee",
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

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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

                        // Number Field
                        _buildTextField(
                          controller: numberController,
                          label: 'Number',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 15),

                        // Team Name Field
                        _buildTextField(
                          controller: teamNameController,
                          label: 'Team Name',
                        ),
                        SizedBox(height: 15),

                        // Position Field
                        _buildTextField(
                          controller: positionController,
                          label: 'Position',
                        ),
                        SizedBox(height: 15),

                        // Salary Field
                        _buildTextField(
                          controller: salaryController,
                          label: 'Salary',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 30),

                        // Add Employee Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addEmployee(); // Call the function to add employee to Firebase
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
                            'Add Employee',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
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

  // Function to add employee to Firebase
  void _addEmployee() {
    firestore.collection('Users').add({
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'number': numberController.text,
      'teamName': teamNameController.text,
      'position': positionController.text,
      'salary': salaryController.text,
      'isAdmin': false, // Default value for isAdmin
    }).then((value) {
      print("Employee Added to Firebase");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Employee added successfully')),
      );
      // Clear the form after submission
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      numberController.clear();
      teamNameController.clear();
      positionController.clear();
      salaryController.clear();
    }).catchError((error) {
      print("Failed to add employee: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add employee')),
      );
    });
  }
}
