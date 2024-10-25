import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutForm extends StatefulWidget {
  const CheckoutForm({super.key});

  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  final TextEditingController taskIdController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final TextEditingController taskCompletedController = TextEditingController();

  // Method to get the current logged-in user's ID
  String? _getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Method to validate Task ID and submit data to Firestore
  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      String checkIn = checkInController.text;
      String checkOut = checkOutController.text;
      String taskId = taskIdController.text;
      String taskDesc = taskDescController.text;
      String taskCompleted = taskCompletedController.text;

      // Get the logged-in user's ID
      String? userId = _getCurrentUserId();
      if (userId == null) {
        // If the user is not logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in!')),
        );
        return;
      }

      try {
        // Check if the taskId exists in the Tasks collection where 'id' matches
        var taskSnapshot = await FirebaseFirestore.instance
            .collection('Tasks')
            .where('id', isEqualTo: taskId)
            .get();

        if (taskSnapshot.docs.isNotEmpty) {
          // Add data to Firestore collection 'Attendance'
          await FirebaseFirestore.instance.collection('Attendance').add({
            'checkIn': checkIn,
            'checkOut': checkOut,
            'taskId': taskId,
            'taskDesc': taskDesc,
            'taskCompleted': taskCompleted,
            'userId': userId, // Include the logged-in user's ID
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data submitted successfully!')),
          );

          // Clear the input fields
          checkInController.clear();
          checkOutController.clear();
          taskIdController.clear();
          taskDescController.clear();
          taskCompletedController.clear();
        } else {
          // Show error message if Task ID is invalid
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid Task ID!')),
          );
        }
      } catch (e) {
        // Handle Firestore submission error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF102C57),
      appBar: AppBar(
        backgroundColor: Color(0xFF102C57),
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      "Check In/Out",
                      style: TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 250,
                      height: 1,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputField(
                      "Check In Time",
                      controller: checkInController,
                      keyboardType: TextInputType.datetime,
                      errorMessage: 'Check In time is required',
                    ),
                    buildInputField(
                      "Check Out Time",
                      controller: checkOutController,
                      keyboardType: TextInputType.datetime,
                      errorMessage: 'Check Out time is required',
                    ),
                    buildInputField(
                      "Task ID",
                      controller: taskIdController,
                      height: 50,
                      errorMessage: 'Task ID is required',
                    ),
                    buildInputField(
                      "Task Definition",
                      controller: taskDescController,
                      height: 50,
                      errorMessage: 'Task description is required',
                    ),
                    buildInputField(
                      "Task Completed",
                      controller: taskCompletedController,
                      height: 50,
                      errorMessage: 'Task completion status is required',
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitData,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAC0A3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label,
      {double height = 30,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      required String errorMessage}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFDAC0A3),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(5)),
            height: height,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorMessage;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    checkInController.dispose();
    checkOutController.dispose();
    taskIdController.dispose();
    taskDescController.dispose();
    taskCompletedController.dispose();
    super.dispose();
  }
}
