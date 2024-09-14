import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/screens/features_screens/attendance.dart';
import 'package:worknest/screens/features_screens/checkout.dart';
import 'package:worknest/screens/features_screens/contactus.dart';
import 'package:worknest/screens/features_screens/holidays.dart';
import 'package:worknest/screens/features_screens/takeleave.dart';
import 'package:worknest/screens/features_screens/tasks.dart';

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
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF102C57)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Welcome Page
            Container(
              // margin: EdgeInsets.symmetric(vertical: 50),
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
                  Container(
                    height: 80,
                    child: Image.asset("assets/images/login_avatar.png"),
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
}
