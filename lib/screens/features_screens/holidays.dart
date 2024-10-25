import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class holidaysShow extends StatelessWidget {
  const holidaysShow({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetching data from Firestore collection 'Holidays'
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
              // StreamBuilder to get live data from Firestore
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Holidays')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFDAC0A3),
                      ),
                    );
                  }

                  // Parse the fetched documents
                  final holidays = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: holidays.length,
                    itemBuilder: (context, index) {
                      // Extracting data from each document
                      var holidayData =
                          holidays[index].data() as Map<String, dynamic>;
                      String date = holidayData['date'] ?? 'Unknown Date';
                      String festival =
                          holidayData['festival'] ?? 'Unknown Festival';

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
                            Text(date, style: TextStyle(color: Colors.white)),
                            SizedBox(width: 40),
                            Text(festival,
                                style: TextStyle(color: Color(0xFFDAC0A3))),
                          ],
                        ),
                      );
                    },
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
