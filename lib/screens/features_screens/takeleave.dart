import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package

class TakeLeave extends StatefulWidget {
  @override
  _TakeLeaveState createState() => _TakeLeaveState();
}

class _TakeLeaveState extends State<TakeLeave> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? reasonError;
  String? descriptionError;
  String? fromDateError;
  String? toDateError;
  String userName = '';
  String profileImage = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  // Fetch user data from Firestore
  Future<void> fetchUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Get user data from Firestore based on UID
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          // Set dynamic user info
          userName = userDoc['name']; // 'name' field from Firestore
          profileImage = userDoc['profile']; // 'profile' field (image URL)
        });
      } else {
        print("User data not found");
      }
    } else {
      print("No user signed in");
    }
  }

  // Method to handle leave application submission
  Future<void> applyLeave() async {
    setState(() {
      // Reset error messages
      reasonError = reasonController.text.isEmpty ? "Reason is required" : null;
      descriptionError =
          descriptionController.text.isEmpty ? "Description is required" : null;
      fromDateError =
          fromDateController.text.isEmpty ? "From date is required" : null;
      toDateError =
          toDateController.text.isEmpty ? "To date is required" : null;
    });

    // Check if there are any errors
    if (reasonError == null &&
        descriptionError == null &&
        fromDateError == null &&
        toDateError == null) {
      try {
        // Get current userId
        User? user = _auth.currentUser;
        String userId = user?.uid ?? 'unknown_user';

        // Store data in Firestore's Leaves collection
        await _firestore.collection('Leaves').add({
          'userId': userId,
          'name': userName,
          'profileImage': profileImage,
          'reason': reasonController.text,
          'description': descriptionController.text,
          'fromDate': fromDateController.text,
          'toDate': toDateController.text,
          'status': 'Pending', // Optionally track status
          'appliedOn':
              FieldValue.serverTimestamp(), // Store application timestamp
        });

        // Notify admin of new leave application
        await _firestore.collection('MessageNotification').add({
          'isAdmin': true,
          'message': 'New Leave Application Submitted',
          'userId': userId,
          'status': 'unread',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success message and clear fields
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Leave application submitted successfully'),
          backgroundColor: Colors.green,
        ));

        // Clear fields after submission
        reasonController.clear();
        descriptionController.clear();
        fromDateController.clear();
        toDateController.clear();
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
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
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Take Leave",
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
                    "Reason",
                    controller: reasonController,
                    errorMessage: reasonError,
                  ),
                  buildInputField(
                    "Enter a Description",
                    controller: descriptionController,
                    errorMessage: descriptionError,
                  ),
                  buildInputField(
                    "From",
                    controller: fromDateController,
                    icon: Icon(Icons.calendar_today),
                    errorMessage: fromDateError,
                  ),
                  buildInputField(
                    "To",
                    controller: toDateController,
                    icon: Icon(Icons.calendar_today),
                    errorMessage: toDateError,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: applyLeave, // Call applyLeave method
                      child: Text(
                        "Apply",
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
    );
  }

  Widget buildInputField(
    String label, {
    required TextEditingController controller,
    double height = 30,
    double width = double.infinity,
    Icon? icon,
    String? errorMessage,
  }) {
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
            width: width,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(5),
            ),
            height: height,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: icon,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15),
            ),
          ),
          if (errorMessage != null) ...[
            SizedBox(height: 5),
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
