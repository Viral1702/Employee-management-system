import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/screens/admin_screens/admin_add_employee.dart';
import 'package:worknest/screens/admin_screens/admin_add_hr.dart';
import 'package:worknest/screens/admin_screens/admin_edit_holidays.dart';
import 'package:worknest/screens/admin_screens/admin_employees.dart';
import 'package:worknest/screens/admin_screens/admin_leaves.dart';
import 'package:worknest/screens/admin_screens/admin_tasks.dart';
import 'package:worknest/screens/features_screens/profile.dart';
import 'package:worknest/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user ID

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<String> fetchUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var document = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      return document['profileImage'] ?? 'assets/images/default_avatar.png';
    }
    return 'assets/images/default_avatar.png';
  }

  @override
  Widget build(BuildContext context) {
    List myIcons = [
      Icons.person,
      Icons.person_remove,
      Icons.edit_square,
      Icons.event,
      Icons.add,
      Icons.person_add
    ];
    List myFeatures = [
      "Employees",
      "Leaves",
      "Give Tasks",
      "Edit Holidays",
      "Add Employee",
      "Add Project Manager"
    ];
    List myFuns = [
      Employees(),
      Leaves(),
      Tasks(),
      EditHolidays(),
      AddEmployee(),
      AddHR()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF102C57),
        automaticallyImplyLeading: false, // Removes the default back arrow
        leading: IconButton(
          icon: const Icon(Icons.logout), // Logout icon on the left
          onPressed: () {
            _showLogoutConfirmationDialog(context); // Show confirmation dialog
          },
          color: const Color(0xFFDAC0A3), // Color for the icon
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF102C57)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Page
            FutureBuilder<String>(
              future: fetchUserProfileImage(), // Fetch the profile image URL
              builder: (context, snapshot) {
                String profileImageUrl;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  profileImageUrl =
                      "assets/images/login_avatar.png"; // Placeholder
                } else if (snapshot.hasError || snapshot.data == null) {
                  profileImageUrl =
                      "assets/images/login_avatar.png"; // Fallback to default image
                } else {
                  profileImageUrl = snapshot.data!;
                }

                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "Hi, Admin",
                            style: TextStyle(
                                color: Color(0xFFC1AE99),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("Welcome to WorkNest",
                              style: TextStyle(color: Color(0xFFDAC0A3))),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(EmployeeProfile());
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileImageUrl)
                                  : const AssetImage(
                                          "assets/images/login_avatar.png")
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Cards Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0;
                      i < myIcons.length && i < myFeatures.length;
                      i++)
                    GestureDetector(
                      onTap: () => Get.to(myFuns[i]),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF212C3D),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50))),
                              child: Icon(
                                myIcons[i],
                                color: const Color(0xFFDAC0A3),
                              ),
                            ),
                            const Text(
                              "  |  ",
                              style: TextStyle(
                                  color: Color(0xFFDAC0A3), fontSize: 30),
                            ),
                            Text(myFeatures[i],
                                style: const TextStyle(
                                    color: Color(0xFFDAC0A3), fontSize: 20))
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                Get.offAll(() => LoginPage());
              },
            ),
          ],
        );
      },
    );
  }
}
