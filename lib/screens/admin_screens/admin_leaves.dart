import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaves extends StatefulWidget {
  const Leaves({Key? key}) : super(key: key);

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> {
  final CollectionReference leavesCollection =
      FirebaseFirestore.instance.collection('Leaves');

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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: leavesCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No leave applications found.'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'assets/images/login_avatar.png'),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      data['name'] ?? 'Unknown', // Display name
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  data['resone'] ??
                                      'Leave Type', // Display leave type
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF102C57),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${data['fromDate']} to ${data['toDate']}', // Display date range
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  data['message'] ??
                                      'Description', // Display description
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        // Handle decline action
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                      ),
                                      child: Text(
                                        'Decline',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 10),
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
                      );
                    }).toList(),
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
