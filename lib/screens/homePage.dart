import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:worknest/screens/features_screens/attendance.dart';
import 'package:worknest/screens/features_screens/checkout.dart';
import 'package:worknest/screens/features_screens/contactus.dart';
import 'package:worknest/screens/features_screens/holidays.dart';
import 'package:worknest/screens/features_screens/profile.dart';
import 'package:worknest/screens/features_screens/takeleave.dart';
import 'package:worknest/screens/features_screens/tasks.dart';
import 'package:worknest/screens/loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fetch username from Firestore
  Future<String> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var document = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      return document['name'] ?? 'User';
    }
    return 'User';
  }

  // Fetch user profile image
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
      Icons.edit,
      Icons.schedule,
      Icons.assignment,
      Icons.person_remove,
      Icons.event,
      Icons.contacts
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
        backgroundColor: Color(0xFF102C57),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
          color: Color(0xFFDAC0A3),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF102C57)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome and Profile Image
            FutureBuilder<List<String>>(
              future: Future.wait([fetchUsername(), fetchUserProfileImage()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading user data');
                } else {
                  String username = snapshot.data?[0] ?? 'User';
                  String profileImage =
                      snapshot.data?[1] ?? 'assets/images/default_avatar.png';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Hi, $username",
                            style: TextStyle(
                              color: Color(0xFFC1AE99),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Welcome to WorkNest",
                              style: TextStyle(color: Color(0xFFDAC0A3))),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => EmployeeProfile());
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: profileImage.startsWith('http')
                              ? NetworkImage(profileImage)
                              : AssetImage(profileImage) as ImageProvider,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            // Features List
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0xFF212C3D),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Icon(
                                myIcons[i],
                                color: Color(0xFFDAC0A3),
                              ),
                            ),
                            Text(
                              "  |  ",
                              style: TextStyle(
                                  color: Color(0xFFDAC0A3), fontSize: 30),
                            ),
                            Text(
                              myFeatures[i],
                              style: TextStyle(
                                  color: Color(0xFFDAC0A3), fontSize: 20),
                            ),
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
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Logout"),
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
