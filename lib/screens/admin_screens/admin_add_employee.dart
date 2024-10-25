import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth

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

  // Firestore and Firebase Auth instances
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF102C57),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFF102C57),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
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
                        _buildTextField(
                          controller: nameController,
                          label: 'Name',
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: passwordController,
                          label: 'Password',
                          obscureText: true,
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: numberController,
                          label: 'Number',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: teamNameController,
                          label: 'Team Name',
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: positionController,
                          label: 'Position',
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: salaryController,
                          label: 'Salary',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addEmployee(); // Call the updated function to add employee
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDAC0A3),
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

  // Function to add employee to Firebase Auth and Firestore
  Future<void> _addEmployee() async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the user's unique ID (UID)
      String uid = userCredential.user!.uid;

      // Add employee details to Firestore 'Users' collection with the same UID
      await firestore.collection('Users').doc(uid).set({
        'uid': uid,
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': numberController.text,
        'teamName': teamNameController.text,
        'position': positionController.text,
        'salary': salaryController.text,
        'isAdmin': false, // Default value for isAdmin
      });

      print("Employee added to Firebase Auth and Firestore");
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
    } catch (e) {
      print("Failed to add employee: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add employee')),
      );
    }
  }
}
