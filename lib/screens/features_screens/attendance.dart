import 'package:flutter/material.dart';

class attendanceScreen extends StatelessWidget {
  const attendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> date = [
      "12 Aug 2024",
      "11 Aug 2024",
      "10 Aug 2024",
      "09 Aug 2024"
    ];

    List<String> timeIn = [
      "8:00 AM",
      "8:00 AM",
      "8:00 AM",
      "8:00 AM",
    ];
    List<String> timeOut = [
      "5:00 PM",
      "5:00 PM",
      "5:00 PM",
      "5:00 PM",
    ];
    List<String> status = ["P", "A", "P", "P"];

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
                    "Attendance",
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
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "DATE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "TIME-IN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "TIME-OUT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "STATUS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFDAC0A3)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: date.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xFF787880),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                date[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFFDAC0A3)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xFF787880),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                timeIn[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFFDAC0A3)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xFF787880),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                timeOut[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFFDAC0A3)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xFF787880),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                status[index],
                                style: TextStyle(
                                  color: status[index] == "A"
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
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
