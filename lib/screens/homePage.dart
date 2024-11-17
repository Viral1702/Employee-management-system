import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/screens/features_screens/attendance.dart';
import 'package:worknest/screens/features_screens/checkout.dart';
import 'package:worknest/screens/features_screens/contactus.dart';
import 'package:worknest/screens/features_screens/holidays.dart';
import 'package:worknest/screens/features_screens/profile.dart';
import 'package:worknest/screens/features_screens/takeleave.dart';
import 'package:worknest/screens/features_screens/tasks.dart';
import 'package:worknest/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var document = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      return document.data() ?? {}; // Return the user data map if available
    }
    return {}; // Return an empty map if no user is logged in
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
      "Attendance",
      "Check in/out",
      "Tasks",
      "Take a Leave",
      "Holidays",
      "Contact Us"
    ];
    List myFuns = [
      AttendanceScreen(),
      CheckoutForm(),
      tasksShow(),
      TakeLeave(),
      holidaysShow(),
      contactusShow()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF102C57),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
          color: const Color(0xFFDAC0A3),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF102C57)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: fetchUserData(),
              builder: (context, snapshot) {
                String name = "User";
                String profileImageUrl = "assets/images/login_avatar.png";

                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Placeholder image while loading
                  profileImageUrl = "assets/images/login_avatar.png";
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Get name and profileImage from snapshot
                  name = snapshot.data!['name'] ?? "User";
                  profileImageUrl = snapshot.data!['profileImage'] ??
                      "assets/images/login_avatar.png";
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Hi, $name",
                          style: const TextStyle(
                            color: Color(0xFFC1AE99),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Welcome to WorkNest",
                          style: TextStyle(color: Color(0xFFDAC0A3)),
                        ),
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
                            image: profileImageUrl.isNotEmpty &&
                                    Uri.parse(profileImageUrl).isAbsolute
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
                );
              },
            ),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
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
                            Text(
                              myFeatures[i],
                              style: const TextStyle(
                                  color: Color(0xFFDAC0A3), fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                Navigator.of(context).pop();
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
