import 'package:flutter/material.dart';

class Leaves extends StatefulWidget {
  const Leaves({Key? key}) : super(key: key);

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFDAC0A3)),
        backgroundColor: Color(0xFF102C57),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF102C57), // Background color for the entire page
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Leave Application",
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Ensure card width is proportionate but height is dynamic based on content
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // Adjust card width (90% of screen width)
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min, // Dynamic height based on content
                    children: [
                      Row(
                        children: [
                          // Small Image
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('../../assets/login_avatar.png'),
                          ),
                          SizedBox(width: 10),

                          // Name
                          Text(
                            'VIRAL',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Card Body Head (Medical Leave)
                      Text(
                        'Medical Leave',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF102C57),
                        ),
                      ),
                      SizedBox(height: 5),

                      // Date
                      Text(
                        '12/03/2024 to 15/03/2024',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 10),

                      // Dummy Content
                      Text(
                        'This is a medical leave application for personal health reasons. '
                        'I kindly request a few days off for recovery.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Buttons (Decline and Accept)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Decline Button
                          OutlinedButton(
                            onPressed: () {
                              // Handle decline action
                            },
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                              side: BorderSide(color: Colors.black, width: 1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              'Decline',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),

                          // Accept Button
                          ElevatedButton(
                            onPressed: () {
                              // Handle accept action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDAC0A3),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              'Accept',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
