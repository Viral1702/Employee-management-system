import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:image_picker/image_picker.dart'; // For selecting images

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({super.key});

  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  // Controllers for the editable fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _teamController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User's data
  Map<String, dynamic>? userData;
  File? _imageFile; // Image file selected by user
  String? _imageUrl; // URL of the uploaded image

  @override
  void dispose() {
    _nameController.dispose();
    _teamController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fetch user data from Firestore based on the current user's UID
  Future<void> fetchUserData() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>?;
            _imageUrl = userData?['profileImage'] ?? "images/login_avatar.png";
            // Populate the text controllers with user data
            _nameController.text = userData?['name'] ?? '';
            _teamController.text = userData?['teamName'] ?? '';
            _phoneController.text = userData?['phoneNumber'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Update user data in Firestore
  Future<void> updateUserProfile() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        await _firestore.collection('Users').doc(currentUser.uid).update({
          'name': _nameController.text,
          'teamName': _teamController.text,
          'phoneNumber': _phoneController.text,
          'profileImage': _imageUrl ?? '',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile.")),
      );
    }
  }

  // Function to upload image to Firebase Storage
  Future<void> uploadImage(File imageFile) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Create a unique file path for the image
        Reference storageRef = _storage
            .ref()
            .child('profileImages')
            .child(currentUser.uid + '.jpg');

        // Upload the image file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;

        // Get the image URL after upload
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update the state with the image URL
        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image.")),
      );
    }
  }

  // Function to select an image using the image picker
  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the selected image to Firebase Storage
      await uploadImage(_imageFile!);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF102C57),
      appBar: AppBar(
        backgroundColor: Color(0xFF102C57),
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Edit Profile",
                          style:
                              TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
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

                    // Profile Picture with Edit Icon
                    Center(
                      child: Stack(
                        children: [
                          // Circular Avatar
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : AssetImage("images/login_avatar.png")
                                    as ImageProvider,
                          ),
                          // Edit Icon
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _selectImage(); // Handle image selection
                              },
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFDAC0A3),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Input Fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildEditableInputField("Name", _nameController),
                        buildNonEditableInputField(
                            "Team Name", userData?['teamName'] ?? ''),
                        buildEditableInputField(
                            "Phone Number", _phoneController),
                        buildNonEditableInputField(
                            "Email", userData?['email'] ?? ''),
                        buildNonEditableInputField(
                            "Position", userData?['position'] ?? ''),
                        buildNonEditableInputField(
                            "Salary", userData?['salary'] ?? ''),
                        SizedBox(height: 30),

                        // Submit button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              updateUserProfile();
                            },
                            child: Text(
                              "Update Profile",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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

  // Function to build editable input fields
  Widget buildEditableInputField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, color: Color(0xFFDAC0A3)),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(5)),
            height: 50,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build non-editable input fields
  Widget buildNonEditableInputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, color: Color(0xFFDAC0A3)),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(5)),
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                value,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
