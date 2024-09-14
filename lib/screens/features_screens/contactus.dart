import 'package:flutter/material.dart';

class contactusShow extends StatelessWidget {
  const contactusShow({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> positions = ["HR", "Project Manager"];
    List<String> emails = ["HR@gmail.com", "PM@gmail.com"];
    List<String> images = [
      "assets/images/login_avatar.png",
      "assets/images/login_avatar.png"
    ];
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
          backgroundColor: Color(0xFF102C57),
        ),
        body: Container(
          color: Color(0xFF102C57),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(color: Color(0xFFDAC0A3), fontSize: 30),
                  ),
                  Container(
                    width: 250,
                    height: 1,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: emails.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(images[index]),
                                SizedBox(width: 10),
                                Text(
                                  "  |  ",
                                  style: TextStyle(
                                      fontSize: 50, color: Colors.grey[50]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        positions[index],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(emails[index])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                    }))
          ]),
        ));
  }
}
