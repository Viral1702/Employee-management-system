import 'package:flutter/material.dart';

class holidaysShow extends StatelessWidget {
  const holidaysShow({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> date = ["14 Jan", "25 Dec"];
    List<String> festivals = ["Sankranti", "Christmas"];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
      ),
      body: Container(
        color: Color(0xFF102C57),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Holidays",
                    style: TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                  ),
                  Container(
                    width: 250,
                    height: 1,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: date.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(top: 8.0, left: 30),
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.pages, color: Color(0xFFDAC0A3)),
                              Text("  |  ",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        Text(date[index],
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 40),
                        Text(festivals[index],
                            style: TextStyle(color: Color(0xFFDAC0A3))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
