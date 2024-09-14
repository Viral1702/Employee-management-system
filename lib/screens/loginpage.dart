import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/screens/homepage.dart';

class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFFDAC0A3)),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.3,
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Color(0xFF102C57),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.7,
                decoration: BoxDecoration(
                  color: Color(0xFF102C57),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Image.asset("assets/images/login_avatar.png"),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  hintText: "Em@il",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFDAC0A3),
                                  )),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFDAC0A3),
                                  )),
                            ),
                            SizedBox(height: 30),
                            Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(homePage());
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFDAC0A3),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
