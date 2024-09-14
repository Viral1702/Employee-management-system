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

class homePage extends StatelessWidget {
  const homePage({super.key});

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
      "Contect Us"
    ];
    List myFuns = [
      attendanceScreen(),
      checkoutForm(),
      tasksShow(),
      takeLeave(),
      holidaysShow(),
      contactusShow()
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF102C57),
        automaticallyImplyLeading: false, // Removes the default back arrow
        leading: IconButton(
          icon: Icon(Icons.logout), // Logout icon on the left
          onPressed: () {
            _showLogoutConfirmationDialog(context); // Show confirmation dialog
          },
          color: Color(0xFFDAC0A3), // Color for the icon
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF102C57)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Welcome Page
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Hi, NATASHA",
                        style: TextStyle(
                            color: Color(0xFFC1AE99),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Welocme to WorkNest",
                          style: TextStyle(color: Color(0xFFDAC0A3)))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(EmployeeProfile());
                    },
                    child: Container(
                      height: 80,
                      child: Image.asset("assets/images/login_avatar.png"),
                    ),
                  )
                ],
              ),
            ),
            // Cards Container
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
                        // color: Color(0xFF102C57),
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
                                      BorderRadius.all(Radius.circular(50))),
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
                            Text(myFeatures[i],
                                style: TextStyle(
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
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                Get.offAll(() => loginPage());
              },
            ),
          ],
        );
      },
    );
  }
}
