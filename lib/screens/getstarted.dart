import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/screens/loginpage.dart';

class getStarted extends StatelessWidget {
  const getStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        decoration: BoxDecoration(color: Color(0xFF102C57)),
        child: Container(
          margin: EdgeInsets.only(top: 150, bottom: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image.asset('assets/images/illustration.png'),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Text("Start Together",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("We will guid you to where",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          Text("you wanted it too",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(LoginPage());
                    },
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDAC0A3), // Background color
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
